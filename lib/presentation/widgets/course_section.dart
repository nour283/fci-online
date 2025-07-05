import 'package:flutter/material.dart';

// تحديث CourseSection widget للعمل مع نموذج البيانات
class CourseSection extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String instructor;
  final String price;
  final VoidCallback? onTap;

  const CourseSection({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.instructor = 'Lina',
    this.price = '15\$',
    this.onTap,
  }) : super(key: key);

  // دالة مساعدة للتحقق مما إذا كان المسار هو رابط شبكة
  bool _isNetworkImage(String path) {
    return path.startsWith('http://' ) || path.startsWith('https://' );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isMobile = screenSize.width < 400;

    double containerWidth = isMobile ? screenSize.width * 0.22 :
    isTablet ? 140 : 100;
    double containerHeight = isMobile ? 150 :
    isTablet ? 200 : 160;
    double imageHeight = isMobile ? 50 :
    isTablet ? 80 : 65;
    double titleFontSize = isMobile ? 8 :
    isTablet ? 14 : 12;
    double descriptionFontSize = isMobile ? 6 :
    isTablet ? 10 : 8;
    double smallTextSize = isMobile ? 7 :
    isTablet ? 10 : 8;
    double padding = isMobile ? 6 :
    isTablet ? 12 : 8;

    Widget imageWidget;
    // التحقق مما إذا كان المسار هو رابط شبكة
    if (_isNetworkImage(imagePath)) {
      imageWidget = Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.broken_image, // أيقونة للصور المكسورة
              size: imageHeight * 0.4,
              color: Colors.grey[600],
            ),
          );
        },
      );
    } else {
      // إذا لم يكن رابط شبكة، فافترض أنه أصل محلي
      imageWidget = Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.image_not_supported, // أيقونة للأصول غير الموجودة
              size: imageHeight * 0.4,
              color: Colors.grey[600],
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: containerWidth,
        height: containerHeight,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageHeight,
              width: double.infinity,
              child: imageWidget, // استخدام ويدجت الصورة الشرطي
            ),
            SizedBox(height: isMobile ? 8 : 9),

            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize,
                color: Colors.black87,
              ),
              maxLines: isMobile ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: isMobile ? 2 : 4),

            Expanded(
              child: Text(
                description,
                maxLines: isMobile ? 2 : isTablet ? 3 : 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontSize: descriptionFontSize,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
            ),

            SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'By $instructor',
                    style: TextStyle(
                      fontSize: smallTextSize,
                      color: Colors.grey[500],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: smallTextSize + 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
