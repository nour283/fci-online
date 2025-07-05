import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/assets_manager.dart';


class RotatingTeam extends StatefulWidget {
  @override
  _RotatingTeamState createState() => _RotatingTeamState();
}

class _RotatingTeamState extends State<RotatingTeam> {
  final List<Map<String, String>> teamMembers = [
    {"name": "Won Cee", "image": ImageAssets.Won_Cee},
    {"name": "Robert Fox", "image": ImageAssets.Robert_Fox},
    {"name": "Eleanor Pena", "image": ImageAssets.Eleanor_Pena},
    {"name": "Jenny Wilson", "image": ImageAssets.Jenny_Wilson},
  ];

  int currentIndex = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      setState(() {
        currentIndex = (currentIndex + 1) % teamMembers.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.4; 

    return Column(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: ClipRRect(
            key: ValueKey<String>(teamMembers[currentIndex]['image']!),
            borderRadius: BorderRadius.circular(10), 
            child: Container(
              width: imageSize,
              height: imageSize,
              child: Image.asset(
                teamMembers[currentIndex]['image']!,
                fit: BoxFit.cover, 
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Text(
            teamMembers[currentIndex]['name']!,
            key: ValueKey<String>(teamMembers[currentIndex]['name']!),
            style: TextStyle(
              fontSize: screenWidth * 0.05, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
