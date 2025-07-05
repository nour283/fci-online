import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/AboutUs_Screen.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/layout_manager/layout_provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/PartnersPage%20.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/account_popup.dart';
import 'package:tadrib_hub/presentation/Screens/logIn_Screen.dart';

import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';
import 'package:tadrib_hub/utils/assets_manager.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart'; 

class LayoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LayoutScreen({super.key});

  void _showAccountPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierDismissible: true,
      builder: (BuildContext context) => const AccountPopup(
        userName: "nour",
        userEmail: "ahmed@example.com",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final layoutProvider = Provider.of<LayoutProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Directionality(
      textDirection: languageProvider.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.inactiveGrey,
                  AppColors.textBlack,
                ],
              ),
            ),
          ),
          foregroundColor: AppColors.backgroundWhite,
          backgroundColor: Colors.black54,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: screenWidth * 0.05,
              backgroundImage: AssetImage(ImageAssets.logo2),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              icon: const Icon(Icons.list),
            )
          ],
        ),
        endDrawer: Drawer(
          width: screenWidth * (isPortrait ? 0.65 : 0.40),
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: isPortrait ? 120 : 80,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: ListView(
                          padding:
                              EdgeInsets.symmetric(vertical: isPortrait ? 20 : 10),
                          children: [
                            _buildDrawerButton(
                              context: context,
                              label: AppStrings.homeDrawerLabel(context), 
                              onPressed: () {
                                layoutProvider.changeBtnNav(0);
                                Navigator.pop(context);
                              },
                              screenWidth: screenWidth,
                              isPortrait: isPortrait,
                            ),
                            _buildDrawerButton(
                              context: context,
                              label: AppStrings.aiDrawerLabel(context), 
                              onPressed: () {
                                layoutProvider.changeBtnNav(2);
                                Navigator.pop(context);
                              },
                              screenWidth: screenWidth,
                              isPortrait: isPortrait,
                            ),
                            _buildDrawerButton(
                              context: context,
                              label: AppStrings.bookDrawerLabel(context), 
                              onPressed: () {
                                layoutProvider.changeBtnNav(5);
                                Navigator.pop(context);
                              },
                              screenWidth: screenWidth,
                              isPortrait: isPortrait,
                            ),
                            _buildDrawerButton(
                              context: context,
                              label: AppStrings.partnerDrawerLabel(context), 
                              onPressed: () {
                                Navigator.pop(context); 
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black.withOpacity(0.4),
                                  barrierDismissible: true,
                                  builder: (BuildContext context) =>
                                      const PartnersPopup(),
                                );
                              },
                              screenWidth: screenWidth,
                              isPortrait: isPortrait,
                            ),
                            _buildDrawerButton(
                              context: context,
                              label: AppStrings.programDrawerLabel(context), 
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              screenWidth: screenWidth,
                              isPortrait: isPortrait,
                            ),
                            _buildDrawerButton(
                              context: context,
                              label: AppStrings.aboutUsDrawerLabel(context), 
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutUsPage()),
                                );
                              },
                              screenWidth: screenWidth,
                              isPortrait: isPortrait,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: Padding(
                            padding:
                                EdgeInsets.all(isPortrait ? 15.0 : 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                minimumSize: Size(
                                  screenWidth * (isPortrait ? 0.3 : 0.2),
                                  isPortrait ? 50 : 30,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                AppStrings.logoutButtonLabel(context), 
                                style: TextStyle(
                                  fontSize: isPortrait ? 18 : 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isPortrait ? 10 : 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundWhite,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            layoutProvider.changeBtnNav(2);
          },
          backgroundColor: AppColors.backgroundGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(360),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Color(0xFF3D5CFF),
          ),
        ),
      bottomNavigationBar: Container(
  height: 100,
  child: BottomNavigationBar(
    onTap: (index) {
      if (index == 4) { 
        _showAccountPopup(context);
      } else {
        layoutProvider.changeBtnNav(index);
      }
    },
    selectedFontSize: 12,
    unselectedFontSize: 10,
    currentIndex: layoutProvider.selectedIndex.clamp(0, 4),
    showSelectedLabels: true,
    backgroundColor: AppColors.white,
    type: BottomNavigationBarType.fixed,
    fixedColor: const Color(0xFF3D5CFF),
    unselectedItemColor: AppColors.iconGray,
    items: [ 
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_filled),
        label: AppStrings.homeBottomNavLabel(context), 
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.menu_book),
        label: AppStrings.courseBottomNavLabel(context), 
      ),
      BottomNavigationBarItem(
        icon: const SizedBox(height: 0),
        label: AppStrings.aiAssistantBottomNavLabel(context), 
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.contact_mail),
        label: AppStrings.contactUsBottomNavLabel(context), 
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person),
        label: AppStrings.accountBottomNavLabel(context),
      ),
    ],
  ),
),
        body: layoutProvider.screens[layoutProvider.selectedIndex],
      ),
    );
  }

  Widget _buildDrawerButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    required double screenWidth,
    required bool isPortrait,
  }) {
    return ListTile(
      title: Center(
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(
              screenWidth * (isPortrait ? 0.5 : 0.4),
              isPortrait ? 60 : 50,
            ),
            side: const BorderSide(color: Colors.black, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(
              vertical: isPortrait ? 15 : 10,
              horizontal: isPortrait ? 40 : 20,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: isPortrait ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
