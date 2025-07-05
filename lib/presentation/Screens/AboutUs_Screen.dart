import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart'; // ✅ تم الاستيراد
import 'package:tadrib_hub/presentation/widgets/RotatingTeam.dart';
import 'package:tadrib_hub/presentation/widgets/SectionContent.dart';
import 'package:tadrib_hub/presentation/widgets/SectionHeader.dart';
import 'package:tadrib_hub/utils/assets_manager.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';


class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    languageProvider.isArabic ? 'نحن هنا لنكون معك' : "We’re here to",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: AppValues.fontSizeLarge,
                    ),
                  ),
                  Text(
                    languageProvider.isArabic ? 'ونضمن نجاحك' : "guarantee your success",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: AppValues.fontSizeLarge,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 4,
                    color: AppColors.Divider,
                  ),
                ],
              ),

              SizedBox(height: 42),

              
              Image(image: AssetImage(ImageAssets.AboutUs)),

              SizedBox(height: 16),

              
              Text(
                languageProvider.isArabic ? 'نحن معك في رحلتك' : "We’re here for you",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: AppValues.fontSizeLarge,
                ),
              ),
              Text(
                languageProvider.isArabic ? 'مهما كانت مكانتك' : "no matter where you are",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: AppValues.fontSizeLarge,
                ),
              ),
              SizedBox(height: 4),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 5,
                color: AppColors.Divider,
              ),

              SizedBox(height: 16),

              
              Image(image: AssetImage(ImageAssets.Map)),

              
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SectionHeader(
                  title: languageProvider.isArabic ? 'مهمتنا' : "Our Mission",
                ),
              ),
              SizedBox(height: 7),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 5,
                color: AppColors.Divider,
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SectionContent(
                  title: languageProvider.isArabic ? 'خدمة لا تُضاهى' : "Unmatched service",
                  description: languageProvider.isArabic
                      ? 'ندعم العملاء والمستثمرين في تنمية أعمالهم وتطويرها عالمياً.'
                      : "Support corporate clients and financial investors with their growth strategy and international development.",
                ),
              ),

              
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SectionHeader(
                  title: languageProvider.isArabic ? 'التزامنا' : "Our Commitment",
                ),
              ),
              SizedBox(height: 7),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 5,
                color: AppColors.Divider,
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SectionContent(),
              ),

              SizedBox(height: 24),

              
              Center(
                child: Column(
                  children: [
                    Text(
                      languageProvider.isArabic ? 'فريق النجاح' : "Our Success Team",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    RotatingTeam(),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}