import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tadrib_hub/api/services/local_storage_service.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';

class QuizQuestionsScreen extends StatefulWidget {
  final String quizId;
  final String quizTitle;
  final int? duration;
  final String courseId;

  const QuizQuestionsScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
    this.duration,
    required this.courseId,
  });

  @override
  _QuizQuestionsScreenState createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen>
    with TickerProviderStateMixin {
  bool isLoading = true;
  List<dynamic> questions = [];
  String? errorMessage;
  int currentQuestionIndex = 0;
  Map<int, String> selectedAnswers = {};
  Timer? _timer;
  int remainingTime = 0;
  int totalTime = 0;
  bool isQuizCompleted = false;
  String? enrollmentId;
  bool isSubmittingScore = false;
  String? submissionError;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    fetchEnrollmentId();
    fetchQuestions();
  }

  Future<void> fetchEnrollmentId() async {
    try {
      final token = await LocalStorageService.getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('https://elearnbackend-production.up.railway.app/api/enrollments/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final enrollments = data['enrollments'] as List;

        final enrollment = enrollments.firstWhere(
              (e) => e['course']['_id'] == widget.courseId,
          orElse: () => null,
        );

        if (enrollment != null) {
          setState(() {
            enrollmentId = enrollment['_id'];
          });
        } else {
          print('No enrollment found for course ${widget.courseId}');
        }
      } else {
        print('Failed to fetch enrollments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching enrollment ID: $e');
    }
  }

  void startTimer() {
    if (widget.duration != null && widget.duration! > 0) {
      remainingTime = widget.duration! * 60;
      totalTime = widget.duration! * 60;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          setState(() {
            remainingTime--;
          });
        } else {
          _timer?.cancel();
          _completeQuiz();
        }
      });
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> fetchQuestions() async {
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

      final response = await http.get(
        Uri.parse('https://elearnbackend-production.up.railway.app/api/questions/quizzes/${widget.quizId}/questions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rawQuestions = data['questions'] ?? [];

        List<Map<String, dynamic>> formattedQuestions = [];
        for (var q in rawQuestions) {
          formattedQuestions.add({
            'questionText': q['name'] ?? 'No question text',
            'options': List<String>.from(q['options'] ?? []),
            'correctAnswer': q['options'][q['correctAnswer']],
            'originalData': q
          });
        }

        setState(() {
          questions = formattedQuestions;
          isLoading = false;
        });

        if (questions.isNotEmpty) {
          _fadeController.forward();
          _slideController.forward();
          startTimer();
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load questions. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Network error: $e';
      });
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = answer;
    });
    HapticFeedback.lightImpact();
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      _slideController.reset();
      setState(() {
        currentQuestionIndex++;
      });
      _slideController.forward();
    } else {
      _completeQuiz();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      _slideController.reset();
      setState(() {
        currentQuestionIndex--;
      });
      _slideController.forward();
    }
  }
  Future<void> submitQuizScore(int score, int timeUsed) async {
    // Validate required data
    if (enrollmentId == null || enrollmentId!.isEmpty) {
      setState(() {
        submissionError = 'No valid enrollment found for this course';
      });
      return;
    }

    if (widget.quizId.isEmpty) {
      setState(() {
        submissionError = 'Invalid quiz identifier';
      });
      return;
    }

    setState(() {
      isSubmittingScore = true;
      submissionError = null;
    });

    try {
      final token = await LocalStorageService.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          submissionError = 'Authentication required. Please login again.';
        });
        return;
      }

      // Construct the endpoint URL
      final endpointUrl = Uri.parse(
          'https://elearnbackend-production.up.railway.app/api/enrollments/$enrollmentId/quizzes/${widget.quizId}/quiz-score'
      );

      // Debug print the exact URL being called
      debugPrint('Attempting to submit score to: $endpointUrl');
      debugPrint('With payload: ${jsonEncode({
        'score': score,
        'timeUsed': timeUsed,
        'submittedAt': DateTime.now().toIso8601String(),
      })}');

      final response = await http.post(
        endpointUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'score': score,
          'timeUsed': timeUsed,
        }),
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Score submitted successfully!');
        setState(() {
          submissionError = null;
        });
      } else {
        final errorResponse = jsonDecode(response.body);
        final errorMsg = errorResponse['message'] ?? 'Unknown error occurred';

        setState(() {
          submissionError = 'Failed to save score: $errorMsg (${response.statusCode})';
        });

        debugPrint('Error Details:');
        debugPrint('Status: ${response.statusCode}');
        debugPrint('Body: ${response.body}');
        debugPrint('Headers: ${response.headers}');
      }
    } on http.ClientException catch (e) {
      setState(() {
        submissionError = 'Network error: ${e.message}';
      });
      debugPrint('Network Exception: $e');
    } on FormatException catch (e) {
      setState(() {
        submissionError = 'Data format error: ${e.message}';
      });
      debugPrint('Format Exception: $e');
    } catch (e) {
      setState(() {
        submissionError = 'Unexpected error: ${e.toString()}';
      });
      debugPrint('Unexpected Error: $e');
    } finally {
      setState(() {
        isSubmittingScore = false;
      });
    }
  }

  void _completeQuiz() {
    _timer?.cancel();
    setState(() {
      isQuizCompleted = true;
    });

    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]['correctAnswer']) {
        correctAnswers++;
      }
    }

    int finalScore = correctAnswers;
    int timeUsed = totalTime - remainingTime;

    submitQuizScore(finalScore, timeUsed);
    _showResultsDialog();
  }

  void _showResultsDialog() {
    final language = Provider.of<LanguageProvider>(context, listen: false);
    int correctAnswers = 0;
    List<Map<String, dynamic>> results = [];

    for (int i = 0; i < questions.length; i++) {
      bool isCorrect = selectedAnswers[i] == questions[i]['correctAnswer'];
      if (isCorrect) {
        correctAnswers++;
      }

      results.add({
        'question': questions[i]['questionText'],
        'selectedAnswer': selectedAnswers[i] ?? 'Not answered',
        'correctAnswer': questions[i]['correctAnswer'],
        'isCorrect': isCorrect,
        'options': questions[i]['options'],
      });
    }

    int timeUsed = totalTime - remainingTime;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: Text(language.isArabic ? 'نتائج الاختبار' : 'Quiz Results'),
            backgroundColor: const Color(0xFF5EAAA8),
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          language.isArabic ? 'النتيجة النهائية' : 'Final Score',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$correctAnswers/${questions.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5EAAA8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          language.isArabic ? 'الوقت المستخدم' : 'Time Used',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          formatTime(timeUsed),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5EAAA8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: correctAnswers / questions.length,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5EAAA8)),
                    ),
                    if (isSubmittingScore)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              language.isArabic ? 'جاري حفظ النتيجة...' : 'Saving score...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (submissionError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          submissionError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '${index + 1}. ${result['question']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: result['isCorrect']
                                  ? const Color(0xFF5EAAA8).withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              border: Border.all(
                                color: result['isCorrect']
                                    ? const Color(0xFF5EAAA8)
                                    : Colors.red,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: result['isCorrect']
                                        ? const Color(0xFF5EAAA8)
                                        : Colors.red,
                                    border: Border.all(
                                      color: result['isCorrect']
                                          ? const Color(0xFF5EAAA8)
                                          : Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  child: result['isCorrect']
                                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                                      : const Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${language.isArabic ? 'إجابتك' : 'Your answer'}: ${result['selectedAnswer']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: result['isCorrect']
                                          ? const Color(0xFF5EAAA8)
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!result['isCorrect'])
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${language.isArabic ? 'الإجابة الصحيحة' : 'Correct answer'}: ${result['correctAnswer']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5EAAA8),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    language.isArabic ? 'إنهاء' : 'Finish',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerOption(String option, int index, LanguageProvider language) {
    bool isSelected = selectedAnswers[currentQuestionIndex] == option;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _selectAnswer(option),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF5EAAA8).withOpacity(0.1) : Colors.white,
              border: Border.all(
                color: isSelected ? const Color(0xFF5EAAA8) : Colors.grey.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFF5EAAA8) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF5EAAA8) : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? const Color(0xFF5EAAA8) : Colors.black87,
                    ),
                  ),
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5EAAA8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (!isQuizCompleted) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(language.isArabic ? 'إنهاء الاختبار؟' : 'Exit Quiz?'),
                  content: Text(
                    language.isArabic
                        ? 'هل أنت متأكد من إنهاء الاختبار؟ سيتم فقدان تقدمك.'
                        : 'Are you sure you want to exit? Your progress will be lost.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(language.isArabic ? 'إلغاء' : 'Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        language.isArabic ? 'إنهاء' : 'Exit',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          widget.quizTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (widget.duration != null && remainingTime > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    color: remainingTime < 300 ? Colors.red[300] : Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatTime(remainingTime),
                    style: TextStyle(
                      color: remainingTime < 300 ? Colors.red[300] : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: isLoading
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
              onPressed: fetchQuestions,
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
          : questions.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              language.isArabic
                  ? 'لا توجد أسئلة متاحة'
                  : 'No questions available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      language.isArabic
                          ? 'السؤال ${currentQuestionIndex + 1} من ${questions.length}'
                          : 'Question ${currentQuestionIndex + 1} of ${questions.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${((currentQuestionIndex + 1) / questions.length * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5EAAA8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5EAAA8)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          questions[currentQuestionIndex]['questionText'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        language.isArabic ? 'الخيارات:' : 'Options:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        questions[currentQuestionIndex]['options'].length,
                            (index) => _buildAnswerOption(
                          questions[currentQuestionIndex]['options'][index],
                          index,
                          language,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _previousQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        language.isArabic ? 'السابق' : 'Previous',
                      ),
                    ),
                  ),
                if (currentQuestionIndex > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedAnswers.containsKey(currentQuestionIndex)
                        ? (currentQuestionIndex == questions.length - 1
                        ? _completeQuiz
                        : _nextQuestion)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5EAAA8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      currentQuestionIndex == questions.length - 1
                          ? (language.isArabic ? 'إنهاء الاختبار' : 'Finish Quiz')
                          : (language.isArabic ? 'التالي' : 'Next'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}