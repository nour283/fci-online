import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tadrib_hub/presentation/Buttoms/custom_button.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';

class ContactFormScreen extends StatelessWidget {
  const ContactFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection:
          AppStrings.isArabic(context) ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                  vertical: size.height * 0.05,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.getTouch(context),
                        style: TextStyle(
                          fontSize: size.width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        AppStrings.fill(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      CustomTextField(hint: AppStrings.name(context)),
                      CustomTextField(hint: AppStrings.companyEmail(context)),
                      CustomTextField(hint: AppStrings.phoneNumber(context)),
                      CustomTextField(
                        hint: AppStrings.isArabic(context)
                            ? "المسمى الوظيفي"
                            : "Title/position",
                      ),
                      CustomTextField(
                        hint: AppStrings.isArabic(context)
                            ? "الموضوع"
                            : "Subject",
                      ),
                      SizedBox(height: size.height * 0.04),
                      CustomButton(
                        text: AppStrings.isArabic(context)
                            ? "تواصل معنا"
                            : "Connect with us",
                        onPressed: () {},
                        width: double.infinity,
                        height: size.height * 0.07,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.hint,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.isPassword = false,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.spacingMedium),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters ?? [],
        decoration: InputDecoration(
          hintText: widget.hint,
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
