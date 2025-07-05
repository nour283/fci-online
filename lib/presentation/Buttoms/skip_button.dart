import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';

class SkipButton extends StatelessWidget {
  final int currentIndex;
  final VoidCallback? onSkip;

  const SkipButton({
    Key? key,
    required this.currentIndex,
    this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    if (currentIndex == 2) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 10),
        child: TextButton(
          onPressed: onSkip,
          child: Text(
            AppStrings.skip(context),  
            style: const TextStyle(
              color: Color(0xFF858597),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
