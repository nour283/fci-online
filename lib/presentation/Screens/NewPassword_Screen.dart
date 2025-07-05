import 'package:flutter/material.dart';
import 'package:tadrib_hub/presentation/Buttoms/custom_button.dart';
import 'package:tadrib_hub/presentation/Screens/Success_Dialog.dart';
import 'package:tadrib_hub/utils/app_router.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';
import 'package:tadrib_hub/utils/assets_manager.dart';
import 'package:tadrib_hub/presentation/Buttoms/bottom_wave_clipper.dart';
import 'package:tadrib_hub/presentation/Widgets/custom_text_field.dart';
import 'package:tadrib_hub/presentation/Widgets/social_login.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 0.22,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageAssets.NewPassword),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.13,
                    left: 20,
                    child: Text(
                      AppStrings.newPassword(context),
                      style: TextStyle(
                        color: AppColors.primaryWhite,
                        fontSize: AppValues.fontSizeExtraLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppValues.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        label: AppStrings.password(context),
                        hint: AppStrings.passwordHint(context),
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      CustomTextField(
                        label: AppStrings.confirmPassword(context),
                        hint: AppStrings.passwordHint(context),
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: AppValues.spacingMedium),
                      CustomButton(
                        text: AppStrings.submit(context),
                        onPressed: () {
                          showSuccessDialog(context, AppRoutes.login);
                        },
                      ),
                      const SizedBox(height: AppValues.spacingLarge),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppValues.paddingSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.S80),
                      SocialLogin(),
                      const SizedBox(height: AppValues.spacingLarge),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomWave(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppValues.paddingSmall,
                ),
                color: AppColors.backgroundBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
