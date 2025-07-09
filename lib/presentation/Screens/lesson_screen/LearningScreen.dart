import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tadrib_hub/api/services/local_storage_service.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';
import 'package:tadrib_hub/presentation/Screens/lesson_screen/quiz_question/QuizQuestions_Screen.dart';
import 'package:video_player/video_player.dart';
import 'video_player/video_player_widget.dart';
import 'lesson_card_widget.dart';

class LearningScreen extends StatefulWidget {
  final String courseId;

  const LearningScreen({super.key, required this.courseId});

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with TickerProviderStateMixin {
  bool isLoading = true;
  List<dynamic> lessons = [];
  List<dynamic> quizzes = [];
  String? errorMessage;
  String? currentLessonId;
  Map<String, dynamic>? currentLessonData;
  VideoPlayerController? _videoController;
  bool isVideoInitialized = false;
  bool isVideoLoading = false;

  late AnimationController _playButtonController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    fetchLessons();
    fetchQuizzes();
  }

  Future<void> fetchLessons() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await LocalStorageService.getToken();

      if (token == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'Authentication required';
        });
        return;
      }

      final url =
          'https://elearnbackend-production.up.railway.app/api/lessons/courses/${widget.courseId}/lessons';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          lessons = data['lessons'] ?? [];
          isLoading = false;
          if (lessons.isNotEmpty) {
            selectLesson(lessons[0]);
          }
        });
      } else if (response.statusCode == 401) {
        setState(() {
          isLoading = false;
          errorMessage = 'Authentication failed. Please login again.';
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load lessons. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Network error: $e';
      });
    }
  }

  Future<void> fetchQuizzes() async {
    try {
      final token = await LocalStorageService.getToken();

      if (token == null) {
        return;
      }

      final url =
          'https://elearnbackend-production.up.railway.app/api/quizzes/courses/${widget.courseId}/quizzes';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          quizzes = data['quizzes'] ?? [];
        });
      }
    } catch (e) {
      print('Error fetching quizzes: $e');
    }
  }

  Future<void> selectLesson(Map<String, dynamic> lesson) async {
    setState(() {
      currentLessonId = lesson['_id'];
      currentLessonData = lesson;
      isVideoLoading = true;
    });

    if (_videoController != null) {
      await _videoController!.dispose();
      _videoController = null;
      isVideoInitialized = false;
    }

    if (lesson['videoUrl']?['url'] != null) {
      try {
        _videoController = VideoPlayerController.network(
          lesson['videoUrl']['url'],
        );

        await _videoController!.initialize();

        setState(() {
          isVideoInitialized = true;
          isVideoLoading = false;
        });

        _videoController!.addListener(() {
          if (mounted) {
            setState(() {});
          }
        });

      } catch (e) {
        print('Error initializing video: $e');
        setState(() {
          isVideoLoading = false;
          isVideoInitialized = false;
        });
      }
    } else {
      setState(() {
        isVideoLoading = false;
        isVideoInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _playButtonController.dispose();
    _progressController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
          _playButtonController.reverse();
        } else {
          _videoController!.play();
          _playButtonController.forward();
        }
      });
    }
    HapticFeedback.lightImpact();
  }

  Widget _buildQuizCard(Map<String, dynamic> quiz, LanguageProvider language) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Navigate to quiz screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizQuestionsScreen(
                  quizId: quiz['_id'],
                  quizTitle: quiz['title'] ?? 'Quiz',
                  duration: quiz['duration'],
                  courseId: widget.courseId,
                ),

              ),

            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Quiz Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5EAAA8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.quiz,
                    color: Color(0xFF5EAAA8),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Quiz Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz['title'] ?? 'Quiz',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quiz['description'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${quiz['questions']?.length ?? 0} ${language.isArabic ? 'سؤال' : 'questions'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${quiz['duration'] ?? 0} ${language.isArabic ? 'دقيقة' : 'min'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  language.isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Course Title Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5EAAA8), Color(0xFF4A9B98)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          language.isArabic ? 'دروس الدورة' : 'Course Lessons',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (currentLessonData != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Text(
                        currentLessonData!['title'] ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: fetchLessons,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5EAAA8),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        language.isArabic ? 'إعادة المحاولة' : 'Retry',
                      ),
                    ),
                  ],
                ),
              )
                  : lessons.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      language.isArabic
                          ? 'لا توجد دروس متاحة بعد'
                          : 'No lessons available yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Player
                    if (currentLessonData != null)
                      VideoPlayerWidget(
                        videoController: _videoController,
                        isVideoInitialized: isVideoInitialized,
                        isVideoLoading: isVideoLoading,
                        playButtonController: _playButtonController,
                        onPlayPause: togglePlayPause,
                      ),

                    // Lessons Section
                    if (lessons.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        language.isArabic ? 'الدروس' : 'Lessons',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Lesson Cards
                      ...lessons.map((lesson) {
                        bool isCurrentLesson = lesson['_id'] == currentLessonId;
                        return LessonCardWidget(
                          lesson: lesson,
                          isCurrentLesson: isCurrentLesson,
                          onTap: () => selectLesson(lesson),
                        );
                      }).toList(),
                    ],

                    // Quizzes Section
                    if (quizzes.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Icon(
                            Icons.quiz,
                            color: const Color(0xFF5EAAA8),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            language.isArabic ? 'الاختبارات' : 'Quizzes',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5EAAA8).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${quizzes.length}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5EAAA8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Quiz Cards
                      ...quizzes.map((quiz) {
                        return _buildQuizCard(quiz, language);
                      }).toList(),
                    ],

                    const SizedBox(height: 20),

                    // Bottom Indicator
                    Center(
                      child: Container(
                        width: 120,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}