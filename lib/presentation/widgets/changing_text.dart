import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';

class ChangingTextSection extends StatefulWidget {
  @override
  _ChangingTextSectionState createState() => _ChangingTextSectionState();
}

class _ChangingTextSectionState extends State<ChangingTextSection> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  late List<Map<String, Map<String, String>>> _texts;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _texts.length;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isArabic = languageProvider.isArabic;
    final lang = isArabic ? "ar" : "en";

    _texts = [
      {
        "title": {
          "en": "Explore your Passion",
          "ar": "استكشف شغفك",
        },
        "description": {
          "en":
              "Explore and better understand the various job\n profiles and career roadmaps by watching career\n Tech-talks delivered by field experts.",
          "ar":
              "استكشف وتعرّف أكثر على الوظائف ومساراتها المهنية\n من خلال فيديوهات حوارية يقدمها خبراء في المجال.",
        },
        "icon": {
          "en": "assets/images/iconhome_1.jpg",
          "ar": "assets/images/iconhome_1.jpg",
        },
      },
      {
        "title": {
          "en": "Earn a certificate/badge",
          "ar": "احصل على شهادة أو شارة",
        },
        "description": {
          "en": "Finish your course and receive an\n e-certificate or badge",
          "ar": "أكمل دورتك التدريبية واحصل على شهادة إلكترونية أو شارة",
        },
        "icon": {
          "en": "assets/images/iconhome_2.jpg",
          "ar": "assets/images/iconhome_2.jpg",
        },
      },
      {
        "title": {
          "en": "Get ready for freelancing Market",
          "ar": "استعد لسوق العمل الحر",
        },
        "description": {
          "en":
              "Discover the freelancing world, career talks\n and mentorship support with\n a rich Arabic content.",
          "ar":
              "اكتشف عالم العمل الحر والدعم من المرشدين\n من خلال محتوى عربي غني.",
        },
        "icon": {
          "en": "assets/images/iconhome_3.jpg",
          "ar": "assets/images/iconhome_3.jpg",
        },
      },
      {
        "title": {
          "en": "Learn Job-Related Skills",
          "ar": "تعلم المهارات المطلوبة",
        },
        "description": {
          "en":
              "Decide on your career-oriented learning path\n and start learning\n at the comfort of your pace.",
          "ar":
              "اختر المسار المهني المناسب ليك وابدأ في التعلم\n بالسرعة اللي تريحك.",
        },
        "icon": {
          "en": "assets/images/iconhome_4.jpg",
          "ar": "assets/images/iconhome_4.jpg",
        },
      },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _texts.length,
            itemBuilder: (context, index) {
              final textData = _texts[index];

              return Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/images/home_1.PNG",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (textData["icon"]?[lang] != null)
                        Image.asset(textData["icon"]![lang]!, width: 50, height: 50),
                      SizedBox(height: 6),
                      Text(
                        textData["title"]?[lang] ?? "No Title",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        textData["description"]?[lang] ?? "No Description",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
