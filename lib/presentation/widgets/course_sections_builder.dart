import 'package:flutter/material.dart';
import 'package:tadrib_hub/presentation/widgets/course_section.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/models/Courses_Model.dart'; // استيراد نموذج الكورسات من الـ API

// تم تعديل هذه الدالة لتستقبل courseImageUrl و coursePrice
typedef NavigateToCourseCallback = void Function(BuildContext context, String courseName, String courseType, String? courseImageUrl, int coursePrice);

class CourseSectionsBuilder {
  final NavigateToCourseCallback navigateToCourse;
  final List<Courses> allCourses; // <--- إضافة قائمة الكورسات من الـ API

  const CourseSectionsBuilder({required this.navigateToCourse, required this.allCourses});

  // دوال مساعدة لتصفية الكورسات من قائمة allCourses
  List<Courses> getProgrammingCourses() =>
      allCourses.where((course) => course.category?.toLowerCase() == 'programming').toList();

  List<Courses> getDesignCourses() =>
      allCourses.where((course) => course.category?.toLowerCase() == 'design').toList();

  List<Courses> getDevelopmentCourses() =>
      allCourses.where((course) => course.category?.toLowerCase() == 'development').toList();

  List<Courses> getBusinessCourses() =>
      allCourses.where((course) => course.category?.toLowerCase() == 'business').toList();

  List<Courses> getMarketingCourses() =>
      allCourses.where((course) => course.category?.toLowerCase() == 'marketing').toList();

  // يمكن إضافة منطق للكورسات الموصى بها بناءً على allCourses
  List<Courses> getRecommendedCourses() {
    // مثال: إرجاع أول 4 كورسات ككورسات موصى بها
    return allCourses.take(4).toList();
  }


  Widget buildRecommendedSection(BuildContext context, double basePadding, double sectionTitleFontSize) {
    final recommendedCourses = getRecommendedCourses(); // استخدام الكورسات من الـ API

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(basePadding),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background2.png"), // <--- صورة الخلفية الثابتة
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.recommendedForYou(context),
            style: TextStyle(
              fontSize: sectionTitleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: basePadding),
          Container(
            height: 160,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: recommendedCourses.map((course) { // <--- استخدام كورسات الـ API
                  return Padding(
                    padding: EdgeInsets.only(right: basePadding * 0.75),
                    child: CourseSection(
                      imagePath: course.courseImg?.url ?? 'assets/images/default_course.png', // <--- صورة من الـ API
                      title: course.title ?? 'بدون عنوان',
                      description: course.description ?? 'لا يوجد وصف',
                      instructor: course.instructor?.userName ?? 'غير محدد', // افتراضاً أن instructor لديه خاصية userName
                      price: '${course.price ?? 0}\$',
                      onTap: () => navigateToCourse(context, course.title ?? '', course.category ?? '', course.courseImg?.url, course.price?.toInt() ?? 0), // <--- تمرير imageUrl والسعر
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGenericCourseSection(
      BuildContext context,
      GlobalKey sectionKey,
      String title,
      List<Courses> coursesData, // <--- الآن تستقبل قائمة من كائنات Courses
      double basePadding,
      double sectionTitleFontSize, {
        bool hasBackground = false,
        bool addExtraSpace = false,
      }) {
    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: EdgeInsets.all(basePadding),
      decoration: hasBackground
          ? BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background1.png"), // <--- هذه الصورة ثابتة
          fit: BoxFit.cover,
        ),
      )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: sectionTitleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: basePadding),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: coursesData.map((course) { // <--- استخدام كائنات Courses
                return Padding(
                  padding: EdgeInsets.only(right: basePadding * 0.75),
                  child: CourseSection(
                    imagePath: course.courseImg?.url ?? 'assets/images/default_course.png', // <--- صورة من الـ API
                    title: course.title ?? 'بدون عنوان',
                    description: course.description ?? 'لا يوجد وصف',
                    instructor: course.instructor?.userName ?? 'غير محدد', // افتراضاً أن instructor لديه خاصية userName
                    price: '${course.price ?? 0}\$',
                    onTap: () => navigateToCourse(context, course.title ?? '', course.category ?? '', course.courseImg?.url, course.price?.toInt() ?? 0), // <--- تمرير imageUrl والسعر
                  ),
                );
              }).toList(),
            ),
          ),
          if (addExtraSpace)
            SizedBox(height: basePadding * 0.5),
        ],
      ),
    );
  }
}
