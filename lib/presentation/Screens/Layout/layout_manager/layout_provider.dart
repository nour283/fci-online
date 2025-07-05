import 'package:flutter/material.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/CourseDetail.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/account_popup.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/ai/ai_screen.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/books_home_page.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/contact_screen.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/course_screen.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/home_screen.dart';


class LayoutProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  
  String? _selectedCourseName;
  String? _selectedCourseType;
  bool _shouldNavigateToCourseDetail = false;
  
  int get selectedIndex => _selectedIndex;
  String? get selectedCourseName => _selectedCourseName;
  String? get selectedCourseType => _selectedCourseType;
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

  void navigateToCourse(String courseName, String courseType) {
    _selectedCourseName = courseName;
    _selectedCourseType = courseType;
    _shouldNavigateToCourseDetail = true;
    _selectedIndex = 1;
    notifyListeners();
  }

  void resetCourseNavigation() {
    _shouldNavigateToCourseDetail = false;
    _selectedCourseName = null;
    _selectedCourseType = null;
    notifyListeners();
  }

  Widget getCourseDetailPage() {
    if (_selectedCourseName != null && _selectedCourseType != null) {
      return CourseDetailsPage( 
        key: ValueKey('course_detail_${_selectedCourseName}_${_selectedCourseType}'),
        courseName: _selectedCourseName!,
        courseType: _selectedCourseType!,
      );
    }
    return CoursesScreen(); 
  }
}
