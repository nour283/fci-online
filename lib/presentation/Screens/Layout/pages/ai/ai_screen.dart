import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/ai/ai_widgets/GradientHeaderText.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/ai/ai_widgets/SubtitleText.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/presentation/widgets/showLanguageSelector.dart';
import 'package:tadrib_hub/cubit/chat_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class AiScreen extends StatefulWidget {
  final Function(Locale)? changeLocale;

  const AiScreen({Key? key, this.changeLocale}) : super(key: key);

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late ChatCubit _chatCubit;

  // Voice recognition
  late SpeechToText _speechToText;
  bool _speechEnabled = false;
  bool _isListening = false;
  String _wordsSpoken = "";

  // File handling
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _selectedFiles = [];

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _chatCubit = ChatCubit();
    _initializeSpeech();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _chatCubit.close();
    _speechToText.stop();
    super.dispose();
  }

  // Initialize speech recognition
  void _initializeSpeech() async {
    _speechToText = SpeechToText();
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        print('Speech status: $status');
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (errorNotification) {
        print('Speech error: $errorNotification');
        setState(() {
          _isListening = false;
        });
        _showSnackBar('خطأ في التعرف على الصوت: ${errorNotification.errorMsg}');
      },
    );
    setState(() {});
  }

  // Start/Stop listening
  void _startStopListening() async {
    if (_speechEnabled) {
      if (_isListening) {
        await _speechToText.stop();
        setState(() {
          _isListening = false;
        });
      } else {
        // Request microphone permission
        var status = await Permission.microphone.request();
        if (status == PermissionStatus.granted) {
          setState(() {
            _isListening = true;
            _wordsSpoken = "";
          });

          await _speechToText.listen(
            onResult: (result) {
              setState(() {
                _wordsSpoken = result.recognizedWords;
                _textController.text = _wordsSpoken;
              });
            },
            listenFor: Duration(seconds: 30),
            pauseFor: Duration(seconds: 3),
            localeId: 'ar_SA', // Arabic locale
          );
        } else {
          _showSnackBar('يجب السماح بالوصول للميكروفون');
        }
      }
    } else {
      _showSnackBar('التعرف على الصوت غير متاح');
    }
  }

  // Pick image from gallery or camera
  void _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.deepPurple),
              title: Text('التقاط صورة'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _imagePicker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 1024,
                  maxHeight: 1024,
                  imageQuality: 85,
                );
                if (image != null) {
                  setState(() {
                    _selectedFiles.add(image);
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.deepPurple),
              title: Text('اختيار من المعرض'),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile> images = await _imagePicker.pickMultiImage(
                  maxWidth: 1024,
                  maxHeight: 1024,
                  imageQuality: 85,
                );
                setState(() {
                  _selectedFiles.addAll(images);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_file, color: Colors.deepPurple),
              title: Text('اختيار ملف'),
              onTap: () async {
                Navigator.pop(context);
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xlsx', 'xls'],
                  allowMultiple: true,
                );
                if (result != null) {
                  List<XFile> files = result.paths
                      .where((path) => path != null)
                      .map((path) => XFile(path!))
                      .toList();
                  setState(() {
                    _selectedFiles.addAll(files);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Remove selected file
  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  // Show snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _sendMessage() {
    final message = _textController.text.trim();
    if (message.isEmpty && _selectedFiles.isEmpty) return;

    // إضافة رسالة المستخدم إلى القائمة
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
        files: List.from(_selectedFiles),
      ));
    });

    // إرسال الرسالة إلى Cubit
    _chatCubit.sendMessage(message, files: _selectedFiles);

    // مسح النص والملفات وإزالة التركيز
    _textController.clear();
    _selectedFiles.clear();
    _focusNode.unfocus();

    // التمرير إلى أسفل
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider.value(
        value: _chatCubit,
        child: BlocListener<ChatCubit, ChatState>(
          listener: (context, state) {
            print('[AiScreen] تم تلقي حالة: ${state.runtimeType}');
            if (state is ChatSuccess) {
              print('[AiScreen] تم تلقي رد: ${state.reply}');
              // إضافة رد الـ AI إلى القائمة
              setState(() {
                _messages.add(ChatMessage(
                  text: state.reply,
                  isUser: false,
                  timestamp: DateTime.now(),
                ));
              });
              _scrollToBottom();
            } else if (state is ChatError) {
              print('[AiScreen] تم تلقي خطأ: ${state.error}');
              // إضافة رسالة خطأ
              setState(() {
                _messages.add(ChatMessage(
                  text: state.error,
                  isUser: false,
                  isError: true,
                  timestamp: DateTime.now(),
                ));
              });
              _scrollToBottom();
            }
          },
          child: SafeArea(
            child: _messages.isEmpty ? _buildWelcomeScreen() : _buildChatScreen(),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GradientHeaderText(),
                  const SubtitleText(),
                  const SizedBox(height: 30),
                  _buildCardItem(
                    title: AppStrings.generate(context),
                    onTap: () {
                      _textController.text = AppStrings.generate(context);
                      _focusNode.requestFocus();
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildCardItem(
                    title: AppStrings.generate2(context),
                    onTap: () {
                      _textController.text = AppStrings.generate2(context);
                      _focusNode.requestFocus();
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
        _buildInputField(context),
      ],
    );
  }

  Widget _buildChatScreen() {
    return Column(
      children: [
        // Chat messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _buildMessageBubble(message);
            },
          ),
        ),
        // Input field
        _buildInputField(context),
      ],
    );
  }

  Widget _buildCardItem({required String title, required VoidCallback onTap}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double cardWidth = screenWidth * 0.6;
    double cardHeight = screenHeight * 0.23;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE6E0E9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () => showLanguageSelector(
                    context: context,
                    onLanguageSelected: widget.changeLocale,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.language,
                      size: 22,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: message.isError ? Colors.red : Colors.deepPurple,
              child: Icon(
                message.isError ? Icons.error : Icons.smart_toy,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Files preview
                if (message.files != null && message.files!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: message.files!.map((file) {
                        final isImage = file.path.toLowerCase().endsWith('.jpg') ||
                            file.path.toLowerCase().endsWith('.jpeg') ||
                            file.path.toLowerCase().endsWith('.png') ||
                            file.path.toLowerCase().endsWith('.gif');

                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: isImage
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(file.path),
                              fit: BoxFit.cover,
                            ),
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.attach_file, size: 24),
                              Text(
                                file.name,
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // Message text
                if (message.text.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? const Color(0xFFE6E0E9)
                          : message.isError
                          ? Colors.red.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser
                            ? const Color(0xFF333333)
                            : message.isError
                            ? Colors.red.shade800
                            : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      bloc: _chatCubit,
      builder: (context, state) {
        final isLoading = state is ChatLoading;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selected files preview
              if (_selectedFiles.isNotEmpty)
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _selectedFiles[index];
                      final isImage = file.path.toLowerCase().endsWith('.jpg') ||
                          file.path.toLowerCase().endsWith('.jpeg') ||
                          file.path.toLowerCase().endsWith('.png') ||
                          file.path.toLowerCase().endsWith('.gif');

                      return Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Stack(
                          children: [
                            if (isImage)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(file.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            else
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.attach_file, size: 24),
                                    Text(
                                      file.name,
                                      style: TextStyle(fontSize: 10),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeFile(index),
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              // Input container
              GestureDetector(
                onTap: () {
                  _focusNode.requestFocus();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E0E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          enabled: !isLoading,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            hintText: isLoading
                                ? 'جاري المعالجة...'
                                : AppStrings.enterPrompt(context),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Attachment button
                      _buildActionButton(
                        icon: Icons.attach_file,
                        onTap: isLoading ? null : _pickImage,
                      ),
                      const SizedBox(width: 8),

                      if (isLoading) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          ),
                        ),
                      ] else ...[
                        // Send button
                        _buildActionButton(
                          icon: Icons.send,
                          onTap: _sendMessage,
                        ),
                        const SizedBox(width: 8),

                        // Voice button
                        _buildActionButton(
                          icon: _isListening ? Icons.mic_off : Icons.mic,
                          onTap: _speechEnabled ? _startStopListening : null,
                          color: _isListening ? Colors.red : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          icon,
          size: 20,
          color: color ?? Colors.black,
        ),
      ),
    );
  }
}

// نموذج لرسالة المحادثة
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;
  final DateTime timestamp;
  final List<XFile>? files;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
    required this.timestamp,
    this.files,
  });
}