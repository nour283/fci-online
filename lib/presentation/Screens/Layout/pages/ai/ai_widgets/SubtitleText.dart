import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart'; 

class SubtitleText extends StatelessWidget {
  const SubtitleText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return Text(
      languageProvider.isArabic ? 'كيف يمكنني مساعدتك اليوم؟' : 'How can I help you today?',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: Color(0xFFD7D7D7),
      ),
    );
  }
}