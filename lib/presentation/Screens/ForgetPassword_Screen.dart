import 'package:flutter/material.dart';
import 'package:tadrib_hub/presentation/Buttoms/CloseIconButton.dart';
import 'package:tadrib_hub/presentation/Screens/VerifyPhone_Screen.dart';
import 'package:tadrib_hub/utils/assets_manager.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';
import 'package:tadrib_hub/presentation/Screens/logIn_Screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController _controller = TextEditingController();

    return Directionality(
      textDirection:
          AppStrings.isArabic(context) ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  AppStrings.forget(context),
                  style: TextStyle(color: AppColors.textBlack),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: CloseIconButton(),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: const Color(0xFFF0F0F2),
                padding: EdgeInsets.symmetric(vertical: size.height * 0.04),
                child: Column(
                  children: [
                    Image.asset(
                      ImageAssets.ForgetPassword,
                      height: size.height * AppValues.imageHeight,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * AppValues.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * AppValues.verticalPadding),
                    Text(
                      AppStrings.enterNumber(context),
                      style: TextStyle(
                        fontSize: size.width * AppValues.verticalPadding,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGray,
                      ),
                    ),
                    SizedBox(height: size.height * AppValues.verticalPadding),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          size.height * AppValues.radius_02,
                        ),
                        border: Border.all(color: AppColors.inactiveGrey),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                              ),
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.phone,
                                maxLength: AppValues.phoneNumberLength,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppStrings.number(context),
                                  hintStyle: TextStyle(
                                    color: AppColors.inactiveGrey,
                                  ),
                                  counterText: "",
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: size.height * AppValues.buttonheight,
                            width: size.height * AppValues.buttonWidth,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(
                                size.height * AppValues.radius_02,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_controller.text.length !=
                                    AppValues.phoneNumberLength) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppStrings.phoneNumberError(context),
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifyPhoneScreen(
                                        phoneNumber: _controller.text,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    size.height * AppValues.radius_02,
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Center(
                                child: Text(
                                  AppStrings.continueText(context),
                                  style: const TextStyle(
                                      color: AppColors.white),
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
