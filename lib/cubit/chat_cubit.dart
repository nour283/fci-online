import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data'; // Import Uint8List

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial()) {
    print('[ChatCubit] تم إنشاء ChatCubit');
    _initializeModel();
  }

  // مفتاح API الخاص بك
  // يرجى ملاحظة: تضمين مفتاح API مباشرة في الكود ليس أفضل ممارسة للأمان في التطبيقات الحقيقية.
  // يفضل استخدام متغيرات البيئة أو خدمات التكوين الآمنة.
  final String _geminiApiKey = 'AIzaSyBeTGBSvn8Cqs2L2mrPTXoF9yHWMVQs9gk';

  late final GenerativeModel _model;

  // تهيئة النموذج
  void _initializeModel() {
    try {
      print('[ChatCubit] بدء تهيئة نموذج Gemini...');
      _model = GenerativeModel(
        model: 'gemini-1.5-flash', // يدعم الصور والملفات
        apiKey: _geminiApiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 8192,
        ),
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
        ],
      );
      print('[ChatCubit] تم تهيئة نموذج Gemini بنجاح');
    } catch (e) {
      print('[ChatCubit] خطأ في تهيئة النموذج: ${e.toString()}');
      emit(ChatError('خطأ في تهيئة النموذج: ${e.toString()}'));
    }
  }

  Future<void> sendMessage(String message, {List<XFile>? files}) async {
    print('[ChatCubit] sendMessage استُدعيت مع الرسالة: "$message"');

    if (message.trim().isEmpty && (files == null || files.isEmpty)) {
      print('[ChatCubit] الرسالة والملفات فارغة، تم تجاهلها');
      return;
    }

    emit(ChatLoading());
    print('[ChatCubit] تم إرسال حالة ChatLoading');

    try {
      print('[ChatCubit] بدء إرسال طلب إلى Gemini...');

      List<Content> content = [];

      // إضافة النص إذا كان متوفراً
      if (message.trim().isNotEmpty) {
        // تم تعديل هذا الجزء: تمت إزالة الطلب الصريح باللغة العربية
        final prompt = message; // النموذج سيكتشف اللغة من الرسالة
        content.add(Content.text(prompt));
      }

      // إضافة الملفات إذا كانت متوفرة
      if (files != null && files.isNotEmpty) {
        for (XFile file in files) {
          try {
            final Uint8List bytes = await file.readAsBytes(); // Ensure Uint8List
            final String fileName = file.name;
            final String extension = fileName.split('.').last.toLowerCase();

            // التحقق من نوع الملف
            if (_isImageFile(extension)) {
              // إضافة الصورة
              content.add(Content.data(_getMimeType(extension), bytes));
              if (message.trim().isEmpty) {
                // تم تعديل هذا الجزء: طلب وصف الصورة بالإنجليزية
                content.add(Content.text('Please describe this image in English.'));
              }
            } else if (_isTextFile(extension)) {
              // قراءة النص من الملف
              final String fileContent = String.fromCharCodes(bytes);
              content.add(Content.text('''
              Content from file "$fileName":
              
              $fileContent
              
              ${message.trim().isEmpty ? 'Please summarize the content of this file in English.' : message}
              '''));
            } else {
              // نوع ملف غير مدعوم
              content.add(Content.text('''
              A file of type "$extension" was attached, but I cannot read it currently.
              ${message.trim().isEmpty ? 'Please describe the file content or send an image of it in English.' : message}
              '''));
            }
          } catch (e) {
            print('[ChatCubit] خطأ في قراءة الملف ${file.name}: ${e.toString()}');
            content.add(Content.text('An error occurred while reading the file: ${file.name}'));
          }
        }
      }

      if (content.isEmpty) {
        emit(ChatError('No content found to send.')); // رسالة خطأ بالإنجليزية
        return;
      }

      print('[ChatCubit] تم تحضير المحتوى مع ${content.length} عنصر');

      final response = await _model.generateContent(content);
      print('[ChatCubit] تم استلام الرد من Gemini');

      // Check for null or empty text in the response
      if (response.text == null || response.text!.isEmpty) {
        print('[ChatCubit] الرد فارغ من Gemini');
        emit(ChatError('No response received from Gemini AI.')); // رسالة خطأ بالإنجليزية
        return;
      }

      final String reply = response.text!;
      print('[ChatCubit] الرد: "$reply"');

      // Emit ChatSuccess with 'reply'
      emit(ChatSuccess(reply));
      print('[ChatCubit] تم إرسال حالة ChatSuccess');

    } catch (e) {
      print('[ChatCubit] خطأ في sendMessage: ${e.toString()}');
      print('[ChatCubit] نوع الخطأ: ${e.runtimeType}');

      String errorMessage = 'Failed to get a response from Gemini AI.'; // رسالة خطأ بالإنجليزية

      if (e.toString().contains('API key')) {
        errorMessage = 'API key error - please check the key.';
      } else if (e.toString().contains('quota')) {
        errorMessage = 'Usage quota exceeded.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network connection error.';
      } else if (e.toString().contains('not found')) {
        errorMessage = 'Model not found or unsupported.';
      } else if (e.toString().contains('unsupported')) {
        errorMessage = 'File type not supported.';
      }

      // Emit ChatError with 'error'
      emit(ChatError('$errorMessage: ${e.toString()}'));
    }
  }

  // التحقق من أن الملف صورة
  bool _isImageFile(String extension) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension);
  }

  // التحقق من أن الملف نص
  bool _isTextFile(String extension) {
    final textExtensions = ['txt', 'md', 'json', 'xml', 'csv'];
    return textExtensions.contains(extension);
  }

  // الحصول على نوع MIME للملف
  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt':
        return 'text/plain';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'xls':
        return 'application/vnd.ms-excel';
      default:
        return 'application/octet-stream';
    }
  }

  // استعلام عن النماذج المتاحة (للاختبار)
  Future<void> listAvailableModels() async {
    try {
      print('[ChatCubit] جاري استعلام النماذج المتاحة...');

      // هذا مثال لكيفية استعلام النماذج المتاحة
      // يمكنك استخدامه للتحقق من النماذج المدعومة
      final response = await _model.generateContent([
        Content.text('Hello, can you respond?')
      ]);

      print('[ChatCubit] النموذج يعمل بشكل صحيح: ${response.text}');
    } catch (e) {
      print('[ChatCubit] خطأ في اختبار النموذج: ${e.toString()}');
    }
  }
}