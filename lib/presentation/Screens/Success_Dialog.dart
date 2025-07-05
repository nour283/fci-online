import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart'; // ✅ تم الاستيراد
import 'package:tadrib_hub/presentation/Buttoms/custom_button.dart';

void showSuccessDialog(BuildContext context, String routeName) {
  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: screenWidth * 0.8,
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: screenWidth * 0.15,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                languageProvider.isArabic ? 'نجح' : 'Success',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomButton(
                text: languageProvider.isArabic ? 'تم' : "Done",
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(routeName);
                },
                width: screenWidth * 0.6,
                height: screenHeight * 0.06,
              ),
            ],
          ),
        ),
      );
    },
  );
}