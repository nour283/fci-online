import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:tadrib_hub/models/book_model.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/layout_manager/books_layout.dart';
import 'package:tadrib_hub/presentation/widgets/search_bar.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';

class BooksHomePage extends StatefulWidget {
  const BooksHomePage({Key? key}) : super(key: key);

  @override
  State<BooksHomePage> createState() => _BooksHomePageState();
}

class _BooksHomePageState extends State<BooksHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<BookItem> _allBooks = [];
  List<BookItem> _filteredBooks = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isSpeechInitialized = false;
  bool _isManualSearchClear = false;

  List<BookItem> _createAllBooks(BuildContext context) => [
    BookItem(
      title: AppStrings.pythonBookTitle(context),
      imagePath: 'assets/images/python_p1.png',
    ),
    BookItem(
      title: AppStrings.gameDevBookTitle(context),
      imagePath: 'assets/images/game_dev.png',
    ),
    BookItem(
      title: AppStrings.psychologyBookTitle(context),
      imagePath: 'assets/images/psychology.png',
    ),
    BookItem(
      title: AppStrings.autocadBookTitle(context),
      imagePath: 'assets/images/autocad.png',
    ),
    BookItem(
      title: AppStrings.aiBookTitle(context),
      imagePath: 'assets/images/ai.png',
    ),
    BookItem(
      title: AppStrings.marketingBookTitle(context),
      imagePath: 'assets/images/marketing.png',
    ),
    BookItem(
      title: AppStrings.excelBookTitle(context),
      imagePath: 'assets/images/excel.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final newBooks = _createAllBooks(context);
    if (_allBooks.isEmpty || _allBooks.length != newBooks.length) {
      _allBooks = newBooks;
      _filterBooks();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _cleanupSpeech();
    super.dispose();
  }

  Future<void> _initializeSpeech() async {
    _speech = stt.SpeechToText();
    try {
      _isSpeechInitialized = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
        debugLogging: false, 
      );
    } catch (e) {
      print('Speech initialization error: $e');
      _isSpeechInitialized = false;
    }
  }

  void _cleanupSpeech() {
    if (_isListening) {
      _speech.stop();
    }
    _speech.cancel();
  }

  void _onSearchChanged() {
    if (!mounted) return;
    print('Search changed: ${_searchController.text}'); 
    _filterBooks();
  }

  void _filterBooks() {
    if (!mounted) return;

    final query = _searchController.text.toLowerCase().trim();
    
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = List.from(_allBooks);
      } else {
        _filteredBooks = _allBooks.where((book) {
          final bookTitle = book.title.toLowerCase();
          return _matchesQuery(bookTitle, query);
        }).toList();
      }
    });
  }

  bool _matchesQuery(String title, String query) {
    
    if (title.contains(query)) return true;
    
  
    final normalizedTitle = title.replaceAll('ة', 'ه');
    final normalizedQuery = query.replaceAll('ة', 'ه');
    
    return normalizedTitle.contains(normalizedQuery) || 
           title.contains(normalizedQuery);
  }

  Future<void> _toggleListening() async {
    if (!_isSpeechInitialized) {
      _showMessage(AppStrings.speechNotAvailable(context));
      return;
    }

    if (_isListening) {
      _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      _showMessage(AppStrings.microphonePermissionDenied(context));
      return;
    }


    _isManualSearchClear = false;
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
    }

    if (!mounted) return;

    setState(() => _isListening = true);
    
    try {
      await _speech.listen(
        onResult: _onSpeechResult,
        localeId: isArabic(context) ? 'ar-SA' : 'en-US',
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true, 
        listenMode: stt.ListenMode.confirmation, 
      );
    } catch (e) {
      print('Speech listening error: $e');
      if (mounted) {
        setState(() => _isListening = false);
        _showMessage(AppStrings.speechNotAvailable(context));
      }
    }
  }

  void _stopListening() {
    if (!_isListening) return;
    
    _speech.stop();
    if (mounted) {
      setState(() => _isListening = false);
    }
  }

  void _onSpeechStatus(String status) {
    if (!mounted) return;
    
    print('Speech status: $status');
    
    switch (status) {
      case 'done':
      case 'notListening':
        if (_isListening) {
          setState(() => _isListening = false);
        }
        break;
      case 'listening':
        if (!_isListening) {
          setState(() => _isListening = true);
        }
        break;
    }
  }

  void _onSpeechError(dynamic error) {
    if (!mounted) return;
    
    print('Speech error: $error');
    
    if (_isListening) {
      setState(() => _isListening = false);
    }
    
    
    final errorMessage = error.toString().toLowerCase();
    if (errorMessage.contains('network')) {
      _showMessage('خطأ في الاتصال بالإنترنت');
    } else if (errorMessage.contains('permission')) {
      _showMessage(AppStrings.microphonePermissionDenied(context));
    } else {
      _showMessage(AppStrings.speechNotAvailable(context));
    }
  }

  void _onSpeechResult(stt.SpeechRecognitionResult result) {
    if (!mounted || _isManualSearchClear) return;
    
    setState(() {
      _searchController.text = result.recognizedWords;
    });
  }

  void _clearSearch() {
    print('Clear search called'); 
    
    _isManualSearchClear = true;
    
    
    if (_isListening) {
      _stopListening();
    }
    
    
    _searchController.clear();
    
    
    _filterBooks();
    
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _isManualSearchClear = false;
      }
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool isArabic(BuildContext context) => AppStrings.isArabic(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppValues.largePadding),
            
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppValues.mediumPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.greeting(context),
                    style: TextStyle(
                      fontSize: AppValues.mediumPadding,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppValues.mediumPadding),
            
            
            Center(
              child: Image.asset(
                'assets/images/book_banner.jpg',
                width: MediaQuery.of(context).size.width * AppValues.bannerWidthFactor,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppValues.largePadding),
            
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppValues.mediumPadding),
              child: BookSearchBar(
                controller: _searchController,
                isListening: _isListening,
                onClear: _clearSearch,
                onMicPressed: _toggleListening,
              ),
            ),
            
            const SizedBox(height: AppValues.largePadding),
            
        
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.mediumPadding),
                child: _filteredBooks.isEmpty && _searchController.text.isNotEmpty
                    ? _buildEmptyState()
                    : CustomBooksLayout(books: _filteredBooks),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد كتب تطابق البحث',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.primary.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب كلمات بحث مختلفة',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}