import 'package:go_router/go_router.dart';
import 'package:tadrib_hub/presentation/Screens/ForgetPassword_Screen.dart';
import 'package:tadrib_hub/presentation/Screens/NewPassword_Screen.dart';
import 'package:tadrib_hub/presentation/Screens/SignUpScreen.dart';
import 'package:tadrib_hub/presentation/Screens/VerifyPhone_Screen.dart';
import 'package:tadrib_hub/presentation/Screens/layout_screen.dart';
import 'package:tadrib_hub/presentation/Screens/logIn_Screen.dart';
import 'package:tadrib_hub/presentation/Screens/OnboardingScreen_view.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgetPassword = '/forget-password';
  static const String newPassword = '/new-password';
  static const String verifyPhone = '/verify-phone';
  static const String layout = '/layout';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgetPassword,
      builder: (context, state) => ForgetPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.newPassword,
      builder: (context, state) => NewPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.verifyPhone,
      builder: (context, state) {
        final phoneNumber = state.extra as String? ?? "";
        return VerifyPhoneScreen(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(path: AppRoutes.layout, builder: (context, state) => LayoutScreen()),
  ],
);
