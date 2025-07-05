import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';


class AuthButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final bool isLargeScreen;

  const AuthButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
    this.isLargeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive values
    final double buttonWidth = isLargeScreen 
        ? MediaQuery.of(context).size.width * 0.3 
        : MediaQuery.of(context).size.width * 0.4;
    
    final double buttonHeight = isLargeScreen
        ? AppValues.buttonHeight * 1.2
        : AppValues.buttonHeight;
    
    final double fontSize = isLargeScreen
        ? AppValues.fontSizeLarge * 1.2
        : AppValues.fontSizeLarge;
    
    final double borderRadius = isLargeScreen
        ? AppValues.borderRadiusMedium * 1.5
        : AppValues.borderRadiusMedium;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: AppColors.primaryBlue,
            width: isLargeScreen ? 2.0 : 1.5,
          ),
          boxShadow: [
            if (isLargeScreen)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onPressed,
            splashColor: isSelected 
                ? Colors.white.withOpacity(0.2)
                : AppColors.primaryBlue.withOpacity(0.2),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primaryBlue,
                  fontSize: fontSize,
                  fontWeight: isLargeScreen ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: isLargeScreen ? 0.5 : 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}