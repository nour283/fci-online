import 'package:flutter/material.dart';
import 'package:tadrib_hub/presentation/widgets/course_section.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/models/Courses_Model.dart';

// تم تعديل الـ typedef ليستقبل كائن Courses كامل
typedef NavigateToCourseCallback = void Function(BuildContext context, Courses course);

class CourseSectionsBuilder {
  final NavigateToCourseCallback navigateToCourse;
  final List<Courses> allCourses;

  const CourseSectionsBuilder({
    required this.navigateToCourse,
    required this.allCourses,
  });

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

  List<Courses> getRecommendedCourses() => allCourses.take(4).toList();

  Widget buildRecommendedSection(BuildContext context, double basePadding, double sectionTitleFontSize) {
    final recommendedCourses = getRecommendedCourses();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(basePadding),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background2.png"),
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
          SizedBox(
            height: 160,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: recommendedCourses.map((course) {
                  return Padding(
                    padding: EdgeInsets.only(right: basePadding * 0.75),
                    child: CourseSection(
                      imagePath: course.courseImg?.url ?? 'assets/images/default_course.png',
                      title: course.title ?? 'بدون عنوان',
                      description: course.description ?? 'لا يوجد وصف',
                      instructor: course.instructor?.userName ?? 'غير محدد',
                      price: '${course.price ?? 0}\$',
                      onTap: () => navigateToCourse(context, course),
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
      List<Courses> coursesData,
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
          image: AssetImage("assets/images/background1.png"),
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
              children: coursesData.map((course) {
                return Padding(
                  padding: EdgeInsets.only(right: basePadding * 0.75),
                  child: CourseSection(
                    imagePath: course.courseImg?.url ?? 'assets/images/default_course.png',
                    title: course.title ?? 'بدون عنوان',
                    description: course.description ?? 'لا يوجد وصف',
                    instructor: course.instructor?.userName ?? 'غير محدد',
                    price: '${course.price ?? 0}\$',
                    onTap: () => navigateToCourse(context, course),
                  ),
                );
              }).toList(),
            ),
          ),
          if (addExtraSpace) SizedBox(height: basePadding * 0.5),
        ],
      ),
    );
  }
}