import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/payment/Payment_Page.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';
import 'package:tadrib_hub/presentation/Screens/lesson_screen/LearningScreen.dart';
import '../../../models/Courses_Model.dart';
import '../../api/services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseDetailsStudyButton extends StatefulWidget {
  final double basePadding;
  final double buttonWidth;
  final double buttonFontSize;
  final Courses course;

  const CourseDetailsStudyButton({
    Key? key,
    required this.basePadding,
    required this.buttonWidth,
    required this.buttonFontSize,
    required this.course,
  }) : super(key: key);

  @override
  State<CourseDetailsStudyButton> createState() => _CourseDetailsStudyButtonState();
}

class _CourseDetailsStudyButtonState extends State<CourseDetailsStudyButton> {
  bool isEnrolled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkEnrollmentStatus();
  }

  Future<void> checkEnrollmentStatus() async {
    setState(() => isLoading = true);

    try {
      final token = await LocalStorageService.getToken();
      if (token != null) {
        final enrolled = await isUserEnrolled(token, widget.course.id!);
        setState(() => isEnrolled = enrolled);
      }
    } catch (e) {
      debugPrint('Error checking enrollment: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<bool> isUserEnrolled(String token, String courseId) async {
    try {
      final response = await http.get(
        Uri.parse('https://elearnbackend-production.up.railway.app/api/payments/check/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] ?? false;
      }
    } catch (e) {
      debugPrint('Error checking enrollment: $e');
    }
    return false;
  }

  Future<void> navigateToPayment(BuildContext context) async {
    final token = await LocalStorageService.getToken();
    final isArabic = Provider.of<LanguageProvider>(context, listen: false).isArabic;

    if (token != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            courseId: widget.course.id!,
            token: token,
          ),
        ),
      );

      if (result == true) {
        setState(() => isEnrolled = true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? "يجب تسجيل الدخول أولًا" : "You must log in first")),
      );
    }
  }

  void startStudying(BuildContext context) {
    print('Starting study with course ID: ${widget.course.id}'); // للتأكد من الـ courseId

    if (widget.course.id == null || widget.course.id!.isEmpty) {
      print('Error: Course ID is null or empty');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: معرف الكورس غير صحيح')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningScreen(courseId: widget.course.id!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LanguageProvider>(context).isArabic;

    return Padding(
      padding: EdgeInsets.only(top: widget.basePadding * 0.625, bottom: widget.basePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: widget.buttonWidth,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : isEnrolled
                  ? () => startStudying(context)
                  : () => navigateToPayment(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnrolled ? const Color(0xFF4CAF50) : const Color(0xFF49BBBD),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: widget.basePadding * 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.basePadding * 1.75),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text(
                isEnrolled
                    ? (isArabic ? "ابدأ الدراسة" : "Study Now")
                    : (isArabic ? "ادفع الآن" : "Buy Now"),
                style: TextStyle(
                  fontSize: widget.buttonFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: widget.basePadding * 0.5),
          Container(
            width: widget.buttonWidth,
            height: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}