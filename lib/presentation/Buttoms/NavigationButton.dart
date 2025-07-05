import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  const NavigationButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: padding,
        child: Container(
          width: AppValues.buttonSize,
          height: AppValues.buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryBlue,
              width: AppValues.borderWidth,
            ),
            color: Colors.transparent,
          ),
          child: Icon(icon, color: AppColors.primaryBlue),
        ),
      ),
    );
  }
}
