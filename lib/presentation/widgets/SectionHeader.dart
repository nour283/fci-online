import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart'; // ✅ تم الاستيراد

class SectionHeader extends StatelessWidget {
  final String title;
  final Color? titleColor;

  SectionHeader({required this.title, this.titleColor});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    
    String translatedTitle = _getTranslatedTitle(title, languageProvider.isArabic);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: languageProvider.isArabic ? "منصتنا " : "Our ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: translatedTitle.replaceFirst(languageProvider.isArabic ? "منصتنا " : "Our ", ""),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  String _getTranslatedTitle(String original, bool isArabic) {
    if (!isArabic) return original;

    switch (original) {
      case "Our Mission":
        return "منصتنا مهمة";
      case "Our Commitment":
        return "منصتنا التزام";
      case "Our Success Team":
        return "فريق نجاحنا";
      default:
        return original; 
    }
  }
}