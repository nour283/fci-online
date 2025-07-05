import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadrib_hub/cubit/courses_cubit.dart';
import 'package:tadrib_hub/cubit/courses_state.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/CourseDetail.dart';
import 'package:tadrib_hub/presentation/widgets/course_section.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/models/Courses_Model.dart';


class CourseDetailsRecommendedSection extends StatelessWidget {
  final String currentCourseName;
  final double basePadding;
  final double titleFontSize;

  const CourseDetailsRecommendedSection({
    Key? key,
    required this.currentCourseName,
    required this.basePadding,
    required this.titleFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesCubit, CoursesState>(
      builder: (context, state) {
        // إذا لم يتم تحميل الكورسات بعد، قم بتحميلها
        if (state is InitialState) {
          context.read<CoursesCubit>().getCourses();
          return _buildLoadingWidget();
        }

        // حالة التحميل
        if (state is LoadingCourses) {
          return _buildLoadingWidget();
        }

        // حالة الخطأ
        if (state is ErrorCourses) {
          return _buildErrorWidget(context, state.error);
        }

        // حالة النجاح
        if (state is SuccessCourses) {
          final List<Courses> recommendedCourses = state.allCourses
              .where((course) => course.title != currentCourseName)
              .take(3)
              .toList();

          return _buildRecommendedSection(context, recommendedCourses);
        }

        return Container(); // حالة افتراضية
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: basePadding),
      padding: EdgeInsets.all(basePadding * 1.25),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background1.png"),
          fit: BoxFit.cover,
        ),
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(basePadding),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الكورسات المقترحة",
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: basePadding),
          Container(
            height: basePadding * 8,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Container(
      margin: EdgeInsets.only(bottom: basePadding),
      padding: EdgeInsets.all(basePadding * 1.25),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background1.png"),
          fit: BoxFit.cover,
        ),
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(basePadding),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الكورسات المقترحة",
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: basePadding),
          Container(
            height: basePadding * 8,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoursesCubit>().retryCourses();
                    },
                    child: Text("إعادة المحاولة"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context, List<Courses> recommendedCourses) {
    return Container(
      margin: EdgeInsets.only(bottom: basePadding),
      padding: EdgeInsets.all(basePadding * 1.25),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background1.png"),
          fit: BoxFit.cover,
        ),
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(basePadding),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.recommendedForYou(context),
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: basePadding),
          recommendedCourses.isEmpty
              ? Container(
            height: basePadding * 8,
            child: Center(
              child: Text(
                "لا توجد كورسات مقترحة متاحة حالياً",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          )
              : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: recommendedCourses.map((course) {
                return Container(
                  width: basePadding * 6.25,
                  margin: EdgeInsets.only(right: basePadding * 0.75),
                  child: CourseSection(
                    imagePath: course.courseImg?.url ?? 'assets/images/default_course.png',
                    title: course.title ?? '',
                    instructor: course.instructor?.userName ?? 'غير محدد',
                    description: course.description ?? '',
                    price: '${course.price ?? 0}\$',
                    onTap: () {
                      // <--- التعديل هنا: استخدام Navigator.push للانتقال لصفحة التفاصيل
                      _navigateToCourseDetails(context, course);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCourseDetails(BuildContext context, Courses course) {
    // <--- التعديل هنا: استخدام Navigator.push
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsPage(
          courseName: course.title ?? 'بدون عنوان',
          courseType: course.category ?? 'غير محدد',
          courseImageUrl: course.courseImg?.url,

        ),
      ),
    );
  }
}
