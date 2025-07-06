import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:tadrib_hub/cubit/courses_cubit.dart';
import 'package:tadrib_hub/generated/S.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/layout_manager/layout_provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/theme_provider.dart';
import 'package:tadrib_hub/api/providers/auth_provider.dart';
import 'package:tadrib_hub/api/providers/user_info_provider.dart';  // اضف UserInfoProvider
import 'package:tadrib_hub/utils/app_router.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CoursesCubit()),
        // BlocProviders إضافية لو هتضيف Cubits تانية
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => LayoutProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()), // Provider لـ Login/Signup/Profile
          ChangeNotifierProvider(create: (_) => UserInfoProvider()), // اضف UserInfoProvider
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        // تحديث الترجمة حسب اللغة
        S.setLocale(Locale(languageProvider.isArabic ? 'ar' : 'en'));

        return MaterialApp.router(
          key: ValueKey('${themeProvider.isDarkMode}_${languageProvider.isArabic}'),
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.system,
          locale: languageProvider.isArabic ? const Locale('ar') : const Locale('en'),
          builder: (context, child) {
            return Directionality(
              textDirection: languageProvider.isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child ?? Container(),
            );
          },
        );
      },
    );
  }
}
