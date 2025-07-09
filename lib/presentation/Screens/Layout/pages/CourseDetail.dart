import 'package:flutter/material.dart';
import 'package:tadrib_hub/models/Courses_Model.dart';
import 'package:tadrib_hub/presentation/widgets/course_details_header.dart';
import 'package:tadrib_hub/presentation/widgets/course_details_info.dart';
import 'package:tadrib_hub/presentation/widgets/course_details_study_button.dart';
import 'package:tadrib_hub/presentation/widgets/course_details_included_features.dart';
import 'package:tadrib_hub/presentation/widgets/course_details_recommended_section.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';

class CourseDetailsPage extends StatelessWidget {
  final Courses course; // ✅ استلام كائن كورس كامل

  const CourseDetailsPage({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double basePadding = screenWidth * 0.04;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final double infoTitleFontSize = 18 * textScaleFactor;
    final double infoDescriptionFontSize = 16 * textScaleFactor;
    final double buttonFontSize = 16 * textScaleFactor;
    final double featuresTitleFontSize = 18 * textScaleFactor;
    final double featureIconSize = 16 * textScaleFactor;
    final double featureTextSize = 12 * textScaleFactor;
    final double recommendedTitleFontSize = 18 * textScaleFactor;

    double studyButtonWidth = screenWidth * 0.6;
    if (studyButtonWidth > 230) {
      studyButtonWidth = 230;
    }

    // ✅ استخراج البيانات من كائن الكورس
    final String courseName = course.title ?? "Course";
    final String courseType = course.category ?? "General";
    final String? courseImageUrl = course.courseImg?.url;

    return Directionality(
      textDirection: AppStrings.isArabic(context) ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Column(
          children: [
            const CourseDetailsHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: basePadding * 1.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CourseDetailsInfo(
                        courseName: courseName,
                        courseType: courseType,
                        basePadding: basePadding,
                        titleFontSize: infoTitleFontSize,
                        descriptionFontSize: infoDescriptionFontSize,
                        imageUrl: courseImageUrl,
                      ),
                      CourseDetailsStudyButton(
                        basePadding: basePadding,
                        buttonWidth: studyButtonWidth,
                        buttonFontSize: buttonFontSize,
                        course: course, // ✅ إرسال كائن الكورس
                      ),
                      CourseDetailsIncludedFeatures(
                        basePadding: basePadding,
                        titleFontSize: featuresTitleFontSize,
                        featureIconSize: featureIconSize,
                        featureTextSize: featureTextSize,
                      ),
                      CourseDetailsRecommendedSection(
                        currentCourseName: courseName,
                        basePadding: basePadding,
                        titleFontSize: recommendedTitleFontSize,
                      ),
                      SizedBox(height: basePadding * 6.25),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}