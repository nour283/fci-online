import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tadrib_hub/presentation/Buttoms/custom_button.dart';
import 'package:tadrib_hub/utils/app_router.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';
import 'package:tadrib_hub/utils/assets_manager.dart';
import 'package:tadrib_hub/presentation/Buttoms/bottom_wave_clipper.dart';
import 'package:tadrib_hub/presentation/Widgets/custom_text_field.dart';
import 'package:tadrib_hub/presentation/Widgets/social_login.dart';
import 'package:tadrib_hub/api/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      context: context,
    );

    if (success) {
      context.go(AppRoutes.layout);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);

    return Directionality(
      textDirection: AppStrings.isArabic(context) ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
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
                          image: AssetImage(ImageAssets.loginBackground),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.13,
                      left: 20,
                      child: Text(
                        AppStrings.logIn(context),
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
                          label: AppStrings.yourEmail(context),
                          hint: AppStrings.emailHint(context),
                          icon: Icons.email,
                          controller: _emailController,
                        ),
                        CustomTextField(
                          label: AppStrings.password(context),
                          hint: AppStrings.passwordHint(context),
                          icon: Icons.lock,
                          isPassword: true,
                          controller: _passwordController,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.push(AppRoutes.forgetPassword);
                            },
                            child: Text(
                              AppStrings.forgetPassword(context),
                              style: const TextStyle(
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                        authProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                          text: AppStrings.logIn(context),
                          onPressed: _onLoginPressed,
                        ),
                        const SizedBox(height: AppValues.S80),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppStrings.dontHaveAccount(context)),
                              TextButton(
                                onPressed: () {
                                  context.go(AppRoutes.signUp);
                                },
                                child: Text(
                                  AppStrings.signUp(context),
                                  style: const TextStyle(
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SocialLogin(),
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
      ),
    );
  }
}
