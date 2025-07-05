import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/course_data_helper.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';

class CourseDetailsInfo extends StatelessWidget {
  final String courseName;
  final String courseType;
  final double basePadding;
  final double titleFontSize;
  final double descriptionFontSize;
  final String? imageUrl; // <--- هذه الخاصية تستقبل رابط الصورة من الـ API

  const CourseDetailsInfo({
    Key? key,
    required this.courseName,
    required this.courseType,
    required this.basePadding,
    required this.titleFontSize,
    required this.descriptionFontSize,
    this.imageUrl, // <--- جعلها اختيارية
  }) : super(key: key);

  // دالة مساعدة للتحقق مما إذا كان المسار هو رابط شبكة
  bool _isNetworkImage(String? path) {
    return path != null && (path.startsWith('http://' ) || path.startsWith('https://' ));
  }

  @override
  Widget build(BuildContext context) {
    Widget courseImageWidget;

    // الأولوية لـ imageUrl القادم من الـ API
    if (_isNetworkImage(imageUrl)) {
      courseImageWidget = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // في حالة فشل تحميل الصورة من الشبكة، يمكن العودة إلى الصورة الافتراضية المحلية
          return Image.asset(
            CourseDataHelper.getCourseImagePath(courseName), // استخدام الصورة المحلية كاحتياطي
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // إذا فشلت الصورة المحلية أيضاً، عرض أيقونة خطأ
              return Container(
                color: CourseDataHelper.getCourseColor(courseType),
                child: Icon(
                  Icons.broken_image, // أيقونة للصور المكسورة
                  color: Colors.white,
                  size: basePadding * 2.5,
                ),
              );
            },
          );
        },
      );
    } else {
      // إذا لم يكن هناك imageUrl من الـ API، أو لم يكن رابط شبكة، استخدم الصورة المحلية
      courseImageWidget = Image.asset(
        CourseDataHelper.getCourseImagePath(courseName),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: CourseDataHelper.getCourseColor(courseType),
            child: Icon(
              CourseDataHelper.getCourseIcon(courseName),
              color: Colors.white,
              size: basePadding * 2.5,
            ),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: basePadding * 0.625),
        Column(
          children: [
            Container(
              width: basePadding * 11.25,
              height: basePadding * 6.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(basePadding * 0.625),
                child: courseImageWidget, // <--- هنا يتم عرض الصورة الديناميكية
              ),
            ),
            SizedBox(height: basePadding),
            Text(
              courseName,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),

        SizedBox(height: basePadding * 0.5),
        Text(
          AppStrings.hoursLeftPrice(context),
          style: TextStyle(
            fontSize: descriptionFontSize,
            color: Color(0xFF49BBBD),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
