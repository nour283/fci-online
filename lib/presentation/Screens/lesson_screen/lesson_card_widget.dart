import 'package:flutter/material.dart';

class LessonCardWidget extends StatelessWidget {
  final Map<String, dynamic> lesson;
  final bool isCurrentLesson;
  final VoidCallback onTap;

  const LessonCardWidget({
    Key? key,
    required this.lesson,
    required this.isCurrentLesson,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isQuiz = lesson['type'] == 'quiz';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isQuiz
                    ? [const Color(0xFF4A9B98), const Color(0xFF3A8B88)]
                    : [const Color(0xFF5EAAA8), const Color(0xFF4E9A98)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isQuiz ? const Color(0xFF4A9B98) : const Color(0xFF5EAAA8))
                      .withOpacity(0.3),
                  blurRadius: isCurrentLesson ? 15 : 8,
                  offset: Offset(0, isCurrentLesson ? 6 : 3),
                ),
              ],
            ),
            transform: Matrix4.identity()
              ..scale(isCurrentLesson ? 1.02 : 1.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isQuiz ? Icons.quiz : Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    lesson['title'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.white.withOpacity(0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      lesson['duration'] ?? '0 min',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}