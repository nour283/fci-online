import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/strings_manager.dart'; 

class CourseDetailsStudyButton extends StatelessWidget {
  final double basePadding;
  final double buttonWidth;
  final double buttonFontSize;

  const CourseDetailsStudyButton({
    Key? key,
    required this.basePadding,
    required this.buttonWidth,
    required this.buttonFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: basePadding * 0.625, bottom: basePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: buttonWidth,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF49BBBD),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: basePadding * 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(basePadding * 1.75),
                ),
              ),
              child: Text(
                AppStrings.studyNow(context), 
                style: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: basePadding * 0.5),
          Container(
            width: buttonWidth,
            height: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
