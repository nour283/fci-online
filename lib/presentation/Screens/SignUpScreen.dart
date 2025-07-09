import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tadrib_hub/api/providers/auth_provider.dart';
import 'package:tadrib_hub/utils/app_router.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';
import 'package:tadrib_hub/utils/assets_manager.dart';
import 'package:tadrib_hub/presentation/Buttoms/custom_button.dart';
import 'package:tadrib_hub/presentation/widgets/custom_text_field.dart';
import 'package:tadrib_hub/presentation/Buttoms/bottom_wave_clipper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final navigator = GoRouter.of(context);

    final success = await authProvider.register(
      userName: _userNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      context: context,
    );

    if (success) {
      navigator.go(AppRoutes.layout);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    final isArabic = AppStrings.isArabic(context);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.22,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageAssets.signup),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppValues.paddingMedium),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _userNameController,
                            label: AppStrings.fullName(context),
                            hint: AppStrings.nameHint(context),
                            icon: Icons.person,
                            validator: (value) => value!.isEmpty
                                ? AppStrings.nameError(context)
                                : null,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _emailController,
                            label: AppStrings.yourEmail(context),
                            hint: AppStrings.emailHint(context),
                            icon: Icons.email,
                            validator: (value) => value!.isEmpty
                                ? AppStrings.emailError(context)
                                : null,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _passwordController,
                            label: AppStrings.password(context),
                            hint: AppStrings.passwordHint(context),
                            icon: Icons.lock,
                            isPassword: true,
                            validator: (value) => value!.length < 6
                                ? AppStrings.passwordError(context)
                                : null,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: authProvider.isLoading
                                ? AppStrings.loading(context)
                                : AppStrings.createAccount(context),
                            onPressed: authProvider.isLoading ? null : _submit,
                          ),
                          const SizedBox(height: 16),
                          buildLoginText(context),
                        ],
                      ),
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

  Widget buildLoginText(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppStrings.alreadyHaveAccount(context)),
          TextButton(
            onPressed: () {
              context.go(AppRoutes.login);
            },
            child: Text(
              AppStrings.logIn(context),
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}