import 'package:flutter/material.dart';

class CourseDetailsHeader extends StatelessWidget {
  const CourseDetailsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/course_header_bg.png"),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {},
        ),
        color: Colors.grey[800],
      ),
    );
  }
}
