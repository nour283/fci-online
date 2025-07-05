import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/profile_page.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/settings_popup.dart';
import 'package:tadrib_hub/presentation/Screens/logIn_Screen.dart';

class AccountPopup extends StatelessWidget {
  final String userName;
  final String userEmail;
  final File? userImage;

  const AccountPopup({
    Key? key,
    required this.userName,
    required this.userEmail,
    this.userImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    final dialogWidth = screenSize.width * (isSmallScreen ? 0.85 : 0.7);
    final iconSize = isSmallScreen ? 20.0 : 22.0;
    final avatarRadius = isSmallScreen ? 25.0 : 30.0;

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
          color: Colors.white,
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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: userImage != null ? FileImage(userImage!) : null,
                    child: userImage == null
                        ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName.isNotEmpty ? userName : languageProvider.isArabic ? "اسمك" : "Your name",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        userEmail.isNotEmpty
                            ? userEmail
                            : languageProvider.isArabic ? "yourname@gmail.com" : "yourname@gmail.com",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),

            _buildMenuItem(
              context,
              Icons.settings_outlined,
              languageProvider.isArabic ? 'الإعدادات' : 'Settings',
              iconSize: iconSize,
              trailingIcon: Icons.chevron_right,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => const SettingsPopup(),
                );
              },
            ),

            _buildMenuItem(
              context,
              Icons.person_outline,
              languageProvider.isArabic ? 'مُحترفي' : 'My Profile',
              iconSize: iconSize,
              trailingIcon: Icons.chevron_right,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),

            _buildMenuItem(
              context,
              Icons.notifications_outlined,
              languageProvider.isArabic ? 'الإشعارات' : 'Notification',
              iconSize: iconSize,
              trailingWidget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  languageProvider.isArabic ? 'سماح' : 'Allow',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),

            _buildMenuItem(
              context,
              Icons.logout,
              languageProvider.isArabic ? 'تسجيل الخروج' : 'Log Out',
              iconSize: iconSize,
              iconColor: Colors.grey[700],
              textColor: Colors.grey[700],
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),

            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    required double iconSize,
    IconData? trailingIcon,
    Widget? trailingWidget,
    Color? iconColor,
    Color? textColor,
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
            color: iconColor,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
          trailing: trailingWidget ??
              (trailingIcon != null
                  ? Icon(trailingIcon, size: iconSize - 2)
                  : null),
          dense: true,
          visualDensity: VisualDensity.compact,
          horizontalTitleGap: 8,
        ),
      ),
    );
  }
}