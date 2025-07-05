import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/layout_manager/layout_provider.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/CourseDetail.dart';
import 'package:tadrib_hub/presentation/widgets/course_sections_builder.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/cubit/courses_cubit.dart';
import 'package:tadrib_hub/cubit/courses_state.dart';
import 'package:tadrib_hub/models/Courses_Model.dart';

import 'course_section.dart' show CourseSection;


class SectionContainer extends StatelessWidget {
  final Map<String, GlobalKey> sectionKeys;
  final ScrollController scrollController;

  const SectionContainer({
    Key? key,
    required this.sectionKeys,
    required this.scrollController,
  }) : super(key: key);

  // تم تعديل هذه الدالة لتستقبل courseImageUrl و coursePrice
  void _navigateToCourse(BuildContext context, String courseName, String courseType, String? courseImageUrl, int coursePrice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsPage(
          courseName: courseName,
          courseType: courseType,
          courseImageUrl: courseImageUrl,

        ),
      ),
    );
  }

  // البيانات الثابتة لقسم التسويق (تم تحويلها إلى كائنات Courses بسيطة)
  List<Courses> _getStaticMarketingCoursesAsCourses() {
    return [
      Courses(
        title: ' Marketing ',
        description: 'Learn the basics of digital marketing including SEO, social media, and content marketing',
        instructor: Instructor(userName: 'Ahmed Hassan'), // إنشاء كائن Instructor بسيط
        price: 300,
        courseImg: CourseImg(url: 'assets/images/Marketing2.png'), // استخدام مسار الصورة المحلية
        category: 'marketing',
      ),
    ];
  }

  // البيانات الثابتة لقسم التطوير (تم تحويلها إلى كائنات Courses بسيطة)
  List<Courses> _getStaticDevelopmentCoursesAsCourses() {
    return [
      Courses(
        title: ' Development',
        description: 'Software development courses to learn how to create their own software programs .',
        instructor: Instructor(userName: 'Mohamed Salah'), // إنشاء كائن Instructor بسيط
        price: 199,
        courseImg: CourseImg(url: 'assets/images/devolp.png'), // استخدام مسار الصورة المحلية
        category: 'development',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double basePadding = screenWidth * 0.04;
    final double sectionTitleFontSize = screenWidth * 0.05;

    return BlocProvider(
      create: (context) => CoursesCubit()..getCourses(),
      child: Directionality(
        textDirection: AppStrings.isArabic(context) ? TextDirection.rtl : TextDirection.ltr,
        child: BlocBuilder<CoursesCubit, CoursesState>(
          builder: (context, state) {
            if (state is LoadingCourses) {
              return _buildLoadingSection(context, basePadding, sectionTitleFontSize);
            } else if (state is ErrorCourses) {
              return _buildErrorSection(context, state.error, basePadding, sectionTitleFontSize);
            } else if (state is SuccessCourses) {
              // هنا يتم إنشاء CourseSectionsBuilder وتمرير allCourses
              final sectionsBuilder = CourseSectionsBuilder(
                navigateToCourse: _navigateToCourse, // استخدام الدالة المعدلة
                allCourses: state.allCourses, // <--- تمرير allCourses هنا
              );

              return Column(
                children: [
                  // قسم الكورسات المُوصى بها (تم لفه في background1.png مع النص)
                  Container( // <--- Container الخارجي بخلفية background1.png
                    width: double.infinity,
                    padding: EdgeInsets.all(basePadding),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background1.png"), // <--- صورة الخلفية الثابتة
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column( // <--- Column لوضع النص ثم الكورسات
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( // <--- نص "Recommended for you"
                          AppStrings.recommendedForYou(context),
                          style: TextStyle(
                            fontSize: sectionTitleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: basePadding),
                        // Container الداخلي بخلفية background2.png للكورسات نفسها
                        Container(
                          height: 160, // ارتفاع ثابت للكورسات
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/background2.png"), // <--- صورة الخلفية الثابتة
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(6), // إضافة حواف مستديرة
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: sectionsBuilder.getRecommendedCourses().map((course) {
                                return Padding(
                                  padding: EdgeInsets.only(right: basePadding * 0.75),
                                  child: CourseSection(
                                    imagePath: course.courseImg?.url ?? 'assets/images/default_course.png',
                                    title: course.title ?? 'بدون عنوان',
                                    description: course.description ?? 'لا يوجد وصف',
                                    instructor: course.instructor?.userName ?? 'غير محدد',
                                    price: '${course.price ?? 0}\$',
                                    onTap: () => _navigateToCourse(context, course.title ?? '', course.category ?? '', course.courseImg?.url, course.price?.toInt() ?? 0),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // قسم البرمجة
                  sectionsBuilder.buildGenericCourseSection(
                    context,
                    sectionKeys['programming']!,
                    AppStrings.programming(context),
                    sectionsBuilder.getProgrammingCourses(), // استخدام دالة الفلترة الجديدة
                    basePadding,
                    sectionTitleFontSize,
                    hasBackground: false,
                  ),

                  // قسم التصميم
                  sectionsBuilder.buildGenericCourseSection(
                    context,
                    sectionKeys['design']!,
                    AppStrings.design(context),
                    sectionsBuilder.getDesignCourses(), // استخدام دالة الفلترة الجديدة
                    basePadding,
                    sectionTitleFontSize,
                    hasBackground: true,
                    addExtraSpace: true,
                  ),

                  // قسم التطوير - الآن يستخدم buildGenericCourseSection
                  sectionsBuilder.buildGenericCourseSection(
                    context,
                    sectionKeys['development']!,
                    AppStrings.development(context),
                    _getStaticDevelopmentCoursesAsCourses(), // <--- استخدام البيانات الثابتة المحولة
                    basePadding,
                    sectionTitleFontSize,
                    hasBackground: false, // أو حسب التصميم
                  ),

                  // قسم الأعمال
                  sectionsBuilder.buildGenericCourseSection(
                    context,
                    sectionKeys['business']!,
                    AppStrings.business(context),
                    sectionsBuilder.getBusinessCourses(), // استخدام دالة الفلترة الجديدة
                    basePadding,
                    sectionTitleFontSize,
                    hasBackground: true,
                  ),

                  // قسم التسويق - الآن يستخدم buildGenericCourseSection
                  sectionsBuilder.buildGenericCourseSection(
                    context,
                    sectionKeys['marketing']!,
                    AppStrings.marketing(context),
                    _getStaticMarketingCoursesAsCourses(), // <--- استخدام البيانات الثابتة المحولة
                    basePadding,
                    sectionTitleFontSize,
                    hasBackground: false, // أو حسب التصميم
                  ),
                ],
              );
            }

            return _buildEmptySection(context, basePadding, sectionTitleFontSize);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingSection(BuildContext context, double basePadding, double sectionTitleFontSize) {
    return Column(
      children: [
        _buildSectionTitle(context, AppStrings.recommendedForYou(context), basePadding, sectionTitleFontSize),
        Container(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        SizedBox(height: 20),
        _buildLoadingSkeletonForSection(context, AppStrings.programming(context), basePadding, sectionTitleFontSize),
        _buildLoadingSkeletonForSection(context, AppStrings.design(context), basePadding, sectionTitleFontSize, hasBackground: true),
      ],
    );
  }

  Widget _buildErrorSection(BuildContext context, String errorMessage, double basePadding, double sectionTitleFontSize) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(basePadding),
          padding: EdgeInsets.all(basePadding * 2),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'errorLoadingCourses',
                style: TextStyle(
                  fontSize: sectionTitleFontSize * 0.8,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                errorMessage,
                style: TextStyle(
                  fontSize: sectionTitleFontSize * 0.6,
                  color: Colors.red.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<CoursesCubit>().retryCourses();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text("retry"),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEmptySection(BuildContext context, double basePadding, double sectionTitleFontSize) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(basePadding),
          padding: EdgeInsets.all(basePadding * 2),
          child: Column(
            children: [
              Icon(
                Icons.school_outlined,
                size: 48,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                "noCourses",
                style: TextStyle(
                  fontSize: sectionTitleFontSize * 0.8,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<CoursesCubit>().getCourses();
                },
                child: Text("loadCourses"),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, double basePadding, double sectionTitleFontSize) {
    return Padding(
      padding: EdgeInsets.all(basePadding),
      child: Text(
        title,
        style: TextStyle(
          fontSize: sectionTitleFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildLoadingSkeletonForSection(BuildContext context, String title, double basePadding, double sectionTitleFontSize, {bool hasBackground = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: basePadding / 2),
      decoration: hasBackground
          ? BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, title, basePadding, sectionTitleFontSize),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: basePadding),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: EdgeInsets.only(right: basePadding / 2),
                  child: _buildLoadingSkeleton(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 8,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 8,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Container(
                        height: 8,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Courses> _getRecommendedCourses(List<Courses> courses) {
    return courses.take(5).toList();
  }

  List<Courses> _getCoursesByCategory(List<Courses> courses, String category) {
    return courses
        .where((course) => course.category?.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
