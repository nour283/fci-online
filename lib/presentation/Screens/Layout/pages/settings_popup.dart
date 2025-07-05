import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/theme_provider.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        final screenSize = MediaQuery.of(context).size;
        final isSmallScreen = screenSize.width < 400;
        
        final dialogWidth = screenSize.width * (isSmallScreen ? 0.85 : 0.7);
        final iconSize = isSmallScreen ? 20.0 : 22.0;
        
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          alignment: Alignment.bottomRight,
          insetPadding: EdgeInsets.only(
            bottom: 100, 
            right: 20,
            left: screenSize.width * 0.2, 
          ),
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(
              maxWidth: 350,
              minWidth: 280,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    languageProvider.isArabic ? 'الإعدادات' : 'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                
                // Theme Selection
                _buildSettingItem(
                  context,
                  languageProvider.isArabic ? 'الوضع' : 'Theme',
                  languageProvider.isArabic ? 
                    (themeProvider.isDarkMode ? 'داكن' : 'فاتح') : 
                    (themeProvider.isDarkMode ? 'Dark' : 'Light'),
                  icon: Icons.color_lens_outlined,
                  iconSize: iconSize,
                  onTap: () {
                    themeProvider.toggleTheme(!themeProvider.isDarkMode);
                  },
                ),
                
                // Language Selection
                _buildSettingItem(
                  context,
                  languageProvider.isArabic ? 'اللغة' : 'Language',
                  languageProvider.isArabic ? 
                    (languageProvider.isArabic ? 'العربية' : 'الإنجليزية') : 
                    (languageProvider.isArabic ? 'Arabic' : 'English'),
                  icon: Icons.language_outlined,
                  iconSize: iconSize,
                  onTap: () {
                    languageProvider.toggleLanguage();
                  },
                ),
                
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String value, {
    required IconData icon,
    required double iconSize,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: Icon(
            icon,
            size: iconSize,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          trailing: Text(
            value,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
          ),
          dense: true,
          visualDensity: VisualDensity.compact,
          horizontalTitleGap: 8,
        ),
      ),
    );
  }
}