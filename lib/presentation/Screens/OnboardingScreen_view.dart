import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tadrib_hub/presentation/Buttoms/bottom_wave_clipper.dart';
import 'package:tadrib_hub/presentation/Buttoms/buttom.dart';
import 'package:tadrib_hub/presentation/Buttoms/login_signup_button.dart';
import 'package:tadrib_hub/presentation/Buttoms/skip_button.dart';
import 'package:tadrib_hub/presentation/widgets/Onboarding_page.dart';
import 'package:tadrib_hub/presentation/widgets/page_indicator.dart';
import 'package:tadrib_hub/utils/app_router.dart';
import 'package:tadrib_hub/utils/assets_manager.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  final ValueNotifier<bool> _isLoginSelected = ValueNotifier(true);

  @override
  void dispose() {
    _controller.dispose();
    _currentIndex.dispose();
    _isLoginSelected.dispose();
    super.dispose();
  }

  void _navigateToSignUp(BuildContext context) {
    context.go(AppRoutes.signUp);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> _pages = [
      {
        'image': ImageAssets.logo1,
        'title': AppStrings.title1(context),
        'subtitle': AppStrings.subtitle1(context),
      },
      {
        'image': ImageAssets.logo2,
        'title': AppStrings.title2(context),
        'subtitle': AppStrings.subtitle2(context),
      },
      {
        'image': ImageAssets.logo3,
        'title': AppStrings.title3(context),
        'subtitle': AppStrings.subtitle3(context),
      },
    ];

    return Directionality(
      textDirection: AppStrings.isArabic(context)
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isSmallScreen = constraints.maxHeight < 600;
              final bool isLargeScreen = constraints.maxWidth > 600;
              final double horizontalPadding = isLargeScreen
                  ? constraints.maxWidth * 0.15
                  : constraints.maxWidth * 0.05;
              final double contentHeightFactor = isSmallScreen ? 0.6 : 0.5;
              final double buttonMinWidth = isLargeScreen ? 60 : 40;
              final double spacing = isSmallScreen
                  ? AppValues.spacingSmall / 2
                  : AppValues.spacingSmall;

              return Column(
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: _currentIndex,
                    builder: (_, index, __) => Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(spacing),
                        child: SkipButton(
                          currentIndex: index,
                          onSkip: () => _navigateToSignUp(context),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (contentHeightFactor * 100).toInt(),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: _pages.length,
                        onPageChanged: (index) => _currentIndex.value = index,
                        itemBuilder: (_, index) => OnboardingPage(
                          image: _pages[index]['image']!,
                          title: _pages[index]['title']!,
                          subtitle: _pages[index]['subtitle']!,
                          isLargeScreen: isLargeScreen,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: spacing / 2,
                    ),
                    child: ValueListenableBuilder<int>(
                      valueListenable: _currentIndex,
                      builder: (_, index, __) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: buttonMinWidth,
                              child: index > 0
                                  ? NavigationButton(
                                      icon: Icons.arrow_back_ios,
                                      onPressed: () {
                                        _controller.previousPage(
                                          duration: Duration(
                                              milliseconds:
                                                  AppValues.animationDuration2),
                                          curve: AppValues.animationCurve,
                                        );
                                      },
                                      padding: const EdgeInsets.only(left: 2),
                                    )
                                  : const SizedBox(),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: spacing),
                                child: PageIndicator(
                                  currentIndex: index,
                                  total: _pages.length,
                                  isLargeScreen: isLargeScreen,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: buttonMinWidth,
                              child: index < _pages.length - 1
                                  ? NavigationButton(
                                      icon: Icons.arrow_forward_ios,
                                      onPressed: () {
                                        _controller.nextPage(
                                          duration: Duration(
                                              milliseconds:
                                                  AppValues.animationDuration),
                                          curve: AppValues.animationCurve,
                                        );
                                      },
                                      padding: const EdgeInsets.only(right: 2),
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: spacing),
                  ValueListenableBuilder<int>(
                    valueListenable: _currentIndex,
                    builder: (_, index, __) => index == _pages.length - 1
                        ? _buildAuthButtons(
                            constraints, isSmallScreen, isLargeScreen)
                        : const SizedBox.shrink(),
                  ),
                  BottomWave(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen
                            ? AppValues.paddingSmall / 2
                            : AppValues.paddingSmall,
                      ),
                      color: AppColors.backgroundBlue,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButtons(BoxConstraints constraints, bool isSmallScreen,
      bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isLargeScreen
            ? constraints.maxWidth * 0.25
            : constraints.maxWidth * 0.08,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isLoginSelected,
        builder: (_, isLogin, __) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AuthButton(
                    text: AppStrings.logIn(context),
                    isSelected: isLogin,
                    onPressed: () {
                      _isLoginSelected.value = true;
                      context.push(AppRoutes.login);
                    },
                    isLargeScreen: isLargeScreen,
                  ),
                ),
                SizedBox(width: isLargeScreen ? 24 : 12),
                Expanded(
                  child: AuthButton(
                    text: AppStrings.signUp(context),
                    isSelected: !_isLoginSelected.value,
                    onPressed: () {
                      _isLoginSelected.value = false;
                      context.push(AppRoutes.signUp);
                    },
                    isLargeScreen: isLargeScreen,
                  ),
                ),
              ],
            ),
            SizedBox(
                height: isSmallScreen
                    ? AppValues.spacingSmall / 2
                    : AppValues.spacingSmall),
          ],
        ),
      ),
    );
  }
}
