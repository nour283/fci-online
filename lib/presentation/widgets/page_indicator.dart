import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;
  final bool isLargeScreen;

  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.total,
    this.isLargeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    
    final double activeWidth = isLargeScreen 
        ? AppValues.indicatorActiveWidth * 1.5 
        : AppValues.indicatorActiveWidth;
    final double inactiveWidth = isLargeScreen 
        ? AppValues.indicatorInactiveWidth * 1.3 
        : AppValues.indicatorInactiveWidth;
    final double height = isLargeScreen 
        ? AppValues.indicatorHeight * 1.2 
        : AppValues.indicatorHeight;
    final double spacing = isLargeScreen 
        ? AppValues.spacingSmall * 1.5 
        : AppValues.spacingSmall;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
        (index) => AnimatedContainer(
          duration: Duration(milliseconds: AppValues.animationDuration),
          margin: EdgeInsets.symmetric(horizontal: spacing),
          width: currentIndex == index ? activeWidth : inactiveWidth,
          height: height,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.primaryBlue
                : AppColors.inactiveGrey,
            borderRadius: BorderRadius.circular(
              isLargeScreen 
                  ? AppValues.borderRadiusSmall * 1.5 
                  : AppValues.borderRadiusSmall,
            ),
          ),
        ),
      ),
    );
  }
}