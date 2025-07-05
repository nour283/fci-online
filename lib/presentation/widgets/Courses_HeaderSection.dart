 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';

class HeaderSection extends StatelessWidget {
  final Map<String, GlobalKey> sectionKeys;
  final ScrollController scrollController;

  const HeaderSection({
    required this.sectionKeys,
    required this.scrollController,
  });

  void _scrollToSection(String section, BuildContext context) {
    final key = sectionKeys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          
          Container(
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background3.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Color(0xFF3700FF), Color(0xFF210099)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        languageProvider.isArabic ? 'اختر' : 'Choice',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color(0x40000000),
                              offset: Offset(3, 3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        languageProvider.isArabic
                            ? 'الدورة المفضلة'
                            : 'favorite course',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color(0x40000000),
                              offset: Offset(3, 3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          
          Transform.translate(
            offset: const Offset(0, -50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryButton(
                        context,
                        'design',
                        Icons.palette,
                        const Color(0xFF4DB6AC),
                        AppStrings.design(context),
                      ),
                      _buildCategoryButton(
                        context,
                        'development',
                        Icons.code,
                        const Color(0x4DB72EE7),

                        AppStrings.development(context),
                      ),
                      _buildCategoryButton(
                        context,
                        'programming',
                        Icons.terminal,
                        const Color(0xFF42A5F5),
                        AppStrings.programming(context),
                      ),
                      _buildCategoryButton(
                        context,
                        'business',
                        Icons.business_center,
                        const Color(0xFF26C6DA),
                        AppStrings.business(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCategoryButton(
                        context,
                        'marketing',
                        Icons.campaign,
                        Colors.orange,
                        AppStrings.marketing(context),
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

  Widget _buildCategoryButton(
    BuildContext context,
    String section,
    IconData icon,
    Color iconColor,
    String title,
  ) {
    return GestureDetector(
      onTap: () => _scrollToSection(section, context),
      child: Container(
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
           boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(0, 4), 
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              _getDescription(section, context),

              style: TextStyle(
                fontSize: 8,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
         
          ],
        ),
      ),
    );
  }

  String _getDescription(String section, BuildContext context) {
  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
  final isArabic = languageProvider.isArabic;

  switch (section) {
    case 'design':
      return isArabic
          ? 'تعلم مهارات التصميم لإنشاء واجهات جميلة'
          : 'Learn design skills to create beautiful interfaces';
    case 'development':
      return isArabic
          ? 'تعلم مهارات تطوير الويب'
          : 'Learn web development skills';
    case 'programming':
      return isArabic
          ? 'تعلم لغات البرمجة'
          : 'Learn programming languages';
    case 'business':
      return isArabic
          ? 'تعلم مهارات الأعمال وريادة الأعمال'
          : 'Learn business and entrepreneurship skills';
    case 'marketing':
      return isArabic
          ? 'تعلم التسويق ومهارات السوشيال ميديا'
          : 'Learn marketing and social media skills';
    default:
      return '';
  }
}

}