import 'package:flutter/material.dart';
import 'package:tadrib_hub/models/Courses_Model.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/CourseDetail.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/account_popup.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/ai/ai_screen.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/books_home_page.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/contact_screen.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/course_screen.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/home_screen.dart';

class LayoutProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  Courses? _selectedCourse; // ✅ الكورس اللي هنعرض تفاصيله
  bool _shouldNavigateToCourseDetail = false;

  int get selectedIndex => _selectedIndex;
  Courses? get selectedCourse => _selectedCourse;
  bool get shouldNavigateToCourseDetail => _shouldNavigateToCourseDetail;

  final List<Widget> screens = [
    HomeScreen(),
    CoursesScreen(),
    AiScreen(),
    ContactFormScreen(),
    const AccountPopup(
      userName: "nour mohamed",
      userEmail: "ahmed@example.com",
    ),
    BooksHomePage(),
  ];

  void changeBtnNav(int index) {
    if (index >= 0 && index < screens.length) {
      if (_selectedIndex == 1 && _shouldNavigateToCourseDetail && index != 1) {
        resetCourseNavigation();
      }
      _selectedIndex = index;
      notifyListeners();
    } else {
      debugPrint('Invalid index: $index - Max allowed: ${screens.length - 1}');
      _selectedIndex = 0;
      notifyListeners();
    }
  }

  /// ✅ لما المستخدم يضغط على كورس
  void navigateToCourse(Courses course) {
    _selectedCourse = course;
    _shouldNavigateToCourseDetail = true;
    _selectedIndex = 1;
    notifyListeners();
  }

  void resetCourseNavigation() {
    _shouldNavigateToCourseDetail = false;
    _selectedCourse = null;
    notifyListeners();
  }

  /// ✅ ترجّع صفحة تفاصيل الكورس
  Widget getCourseDetailPage() {
    if (_selectedCourse != null) {
      return CourseDetailsPage(
        key: ValueKey('course_detail_${_selectedCourse!.id}'),
        course: _selectedCourse!,
      );
    }
    return CoursesScreen();
  }
}
