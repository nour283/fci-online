import 'package:flutter/material.dart';

void showLanguageSelector({
  required BuildContext context,
  required Function(Locale)? onLanguageSelected,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildLanguageOption(
              context: context,
              icon: Icons.language,
              title: 'Arabic',
              locale: const Locale('ar', 'EG'),
              onLanguageSelected: onLanguageSelected,
            ),
            _buildLanguageOption(
              context: context,
              icon: Icons.language,
              title: 'English',
              locale: const Locale('en', 'US'),
              onLanguageSelected: onLanguageSelected,
            ),
            _buildLanguageOption(
              context: context,
              icon: Icons.language,
              title: 'Français',
              locale: const Locale('fr', 'FR'),
              onLanguageSelected: onLanguageSelected,
            ),
            _buildLanguageOption(
              context: context,
              icon: Icons.language,
              title: 'Español',
              locale: const Locale('es', 'ES'),
              onLanguageSelected: onLanguageSelected,
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildLanguageOption({
  required BuildContext context,
  required IconData icon,
  required String title,
  required Locale locale,
  required Function(Locale)? onLanguageSelected,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      if (onLanguageSelected != null) {
        onLanguageSelected(locale);
      }
      Navigator.pop(context);
    },
  );
}