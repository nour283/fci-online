import 'package:flutter/material.dart';
import 'package:tadrib_hub/presentation/Screens/logIn_Screen.dart';
import 'package:tadrib_hub/utils/color_manager.dart';


class CloseIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Icon(Icons.cancel, color: AppColors.primaryBlue, size: 25),
    );
  }
}
