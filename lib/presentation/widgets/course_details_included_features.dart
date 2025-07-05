import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/strings_manager.dart'; 

class CourseDetailsIncludedFeatures extends StatelessWidget {
  final double basePadding;
  final double titleFontSize;
  final double featureIconSize;
  final double featureTextSize;

  const CourseDetailsIncludedFeatures({
    Key? key,
    required this.basePadding,
    required this.titleFontSize,
    required this.featureIconSize,
    required this.featureTextSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {"icon": Icons.verified, "text": AppStrings.bestQuality(context), "color":  Color(0xFF49BBBD),}, 
      {"icon": Icons.devices, "text": AppStrings.accessAllDevices(context), "color": Color(0xFF49BBBD),}, 
      {"icon": Icons.card_membership, "text": AppStrings.certificationCompletion(context), "color":  Color(0xFF49BBBD),}, 
      {"icon": Icons.video_library, "text": AppStrings.modulesCount(context, 32), "color": Color(0xFF49BBBD),}, 
    ];

    return Padding(
      padding: EdgeInsets.only(bottom: basePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.courseIncluded(context), 
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          ...features.map((feature) => Padding(
                padding: EdgeInsets.only(top: basePadding * 0.5),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(basePadding * 0.5),
                      decoration: BoxDecoration(
                        color: feature["color"].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(basePadding * 0.5),
                      ),
                      child: Icon(
                        feature["icon"],
                        color: feature["color"],
                        size: featureIconSize,
                      ),
                    ),
                    SizedBox(width: basePadding * 0.375),
                    Text(
                      feature["text"],
                      style: TextStyle(
                        fontSize: featureTextSize,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
