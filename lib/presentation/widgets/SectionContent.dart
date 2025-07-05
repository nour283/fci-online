import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart'; 

class SectionContent extends StatelessWidget {
  final String? title;
  final String? description;

  SectionContent({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!, 
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        if (description != null) Text(description!),
        
        SizedBox(height: 8),
        
        Text(
          languageProvider.isArabic ? "محدد" : "Specific",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          languageProvider.isArabic
              ? "تُركّز خبرتنا الأساسية على مساعدة عملائنا على فهم الأسواق وتحليلها وتنفيذ استراتيجيات تجارية واستثمارية في أسواق محددة."
              : "ConsultUs’ core expertise lies in the ability to support our clients in understanding, analysing and executing commercial and investment strategies in specific markets.",
        ),

        SizedBox(height: 8),

        Text(
          languageProvider.isArabic ? "الخبرة" : "Experience",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          languageProvider.isArabic
              ? "لدينا خبرة في العمل مع مجموعة واسعة من العملاء من الشركات متعددة الجنسيات إلى الشركات الصغيرة والمتوسطة، ومن مزوّدَي القروض الكبار إلى مستثمري الأسهم الخاصة في السوق المتوسط."
              : "Experience in working with and assisting a wide range of clients from international corporations to small/medium-sized businesses, from large corporate debt providers to mid-market private equity investors.",
        ),

        SizedBox(height: 8),

        Text(
          languageProvider.isArabic ? "التكنولوجيا" : "Technology",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          languageProvider.isArabic
              ? "أفضل دمج بين التكنولوجيا والكوادر البشرية."
              : "The best combination of technology and people.",
        ),
      ],
    );
  }
}