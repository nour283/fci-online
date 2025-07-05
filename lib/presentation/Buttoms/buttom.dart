import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/color_manager.dart';


class NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  const NavigationButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24.0), 
        child: Container(
          width: 48.0, 
          height: 48.0, 
          decoration: BoxDecoration(
            shape: BoxShape.circle, 
            color: Colors.white, 
            border: Border.all(
              color: AppColors.primaryBlue, 
              width: 2.0, 
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: AppColors.primaryBlue, 
              size: 24.0, 
            ),
          ),
        ),
      ),
    );
  }
}