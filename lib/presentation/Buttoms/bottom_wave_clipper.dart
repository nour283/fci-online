import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';
class BottomWave extends StatelessWidget {
  final Widget child;
  const BottomWave({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomWaveClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * AppValues.waveHeightFactor,
        width: double.infinity,
        color: AppColors.primaryBlue,
        child: child,
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * AppValues.waveCurveFactor,
      size.width,
      0,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
