import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final double topPadding;
  final bool isLargeScreen;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.topPadding = 50,
    this.isLargeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;

    
    final double imageHeight = isLargeScreen
        ? height * 0.35
        : height < 600 
            ? height * 0.25 
            : height * 0.30;
    
    final double titleFontSize = isLargeScreen
        ? width * 0.045
        : width * (height < 600 ? 0.05 : 0.06);
    
    final double subtitleFontSize = isLargeScreen
        ? width * 0.035
        : width * (height < 600 ? 0.04 : 0.045);

    final double horizontalPadding = isLargeScreen
        ? width * 0.15
        : width * 0.05;
    
    final double verticalSpacing = isLargeScreen
        ? height * 0.04
        : height < 600
            ? height * 0.02
            : height * 0.03;

    return SingleChildScrollView( 
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: topPadding),
            
            AspectRatio(
              aspectRatio: isLargeScreen ? 1.5 : 1.2,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                height: imageHeight,
              ),
            ),
            
            SizedBox(height: verticalSpacing * 1.5),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: isLargeScreen ? FontWeight.w600 : FontWeight.bold,
                color: Colors.black,
                height: 1.3,
              ),
            ),
            
            SizedBox(height: verticalSpacing),
            
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: isLargeScreen ? 3 : 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: subtitleFontSize,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
