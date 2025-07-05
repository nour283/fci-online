import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';

class CourseDataHelper {
  static String getCourseImagePath(String courseName) {
    switch (courseName.toLowerCase()) {
      case 'ui/ux design':
        return 'assets/images/UI_UX.png';
      case 'python':
        return 'assets/images/PYTHION.png';
      case 'java':
        return 'assets/images/JAVE2.png';
      case 'c++':
        return 'assets/images/c++.png';
      case 'adobe photoshop':
        return 'assets/images/adobe.png';
      case 'adobe illustrator':
        return 'assets/images/adobe2.png';
      case 'adobe xd':
        return 'assets/images/adxd.png';
      case 'e-commerce':
        return 'assets/images/E_commerce.png';
      case 'e-business':
        return 'assets/images/E_BUSINESS.png';
      case 'marketing':
        return 'assets/images/Marketing2.png';
      case 'development':
        return 'assets/images/devolp.png';
      default:
        return 'assets/images/UI.png';
    }
  }

  static Color getCourseColor(String courseType) {
    switch (courseType) {
      case 'programming':
        return Colors.blue;
      case 'design':
        return Colors.purple;
      case 'business':
        return Colors.green;
      case 'marketing':
        return Colors.orange;
      case 'development':
        return Colors.teal;
      default:
        return Colors.teal;
    }
  }

  static IconData getCourseIcon(String courseName) {
    switch (courseName.toLowerCase()) {
      case 'adobe xd':
        return Icons.design_services;
      case 'python':
        return Icons.code;
      case 'java':
        return Icons.coffee;
      case 'ui/ux design':
        return Icons.brush;
      case 'c++':
        return Icons.code;
        break; 
      case 'adobe photoshop':
        return Icons.photo;
      case 'adobe illustrator':
        return Icons.create;
      case 'e-commerce':
      case 'e-business':
        return Icons.business;
      case 'marketing':
        return Icons.campaign;
      case 'development':
        return Icons.web;
      default:
        return Icons.school;
    }
  }

  static List<Map<String, dynamic>> getAllCourses(BuildContext context) {
    return [
      {
        'name': 'C++',
        'description': AppStrings.cppDescription(context),
        'imagePath': 'assets/images/c++.png',
        'type': 'programming',
      },
      {
        'name': AppStrings.python(context), 
        'description': AppStrings.pythonDescription(context),
        'imagePath': 'assets/images/PYTHION.png',
        'type': 'programming',
      },
      {
        'name': AppStrings.java(context), 
        'description': AppStrings.javaDescription(context),
        'imagePath': 'assets/images/JAVE2.png',
        'type': 'programming',
      },
      {
        'name': AppStrings.uiUxDesign(context), 
        'description': AppStrings.uiUxDesignDescription(context),
        'imagePath': 'assets/images/UI_UX.png',
        'type': 'design',
      },
      {
        'name': AppStrings.adobePhotoshop(context), 
        'description': AppStrings.designDescription(context),
        'imagePath': 'assets/images/adobe.png',
        'type': 'design',
      },
      {
        'name': AppStrings.adobeIllustrator(context), 
        'description': AppStrings.designDescription(context),
        'imagePath': 'assets/images/adobe2.png',
        'type': 'design',
      },
      {
        'name': AppStrings.adobeXd(context), 
        'description': AppStrings.designDescription(context),
        'imagePath': 'assets/images/adxd.png',
        'type': 'design',
      },
      {
        'name': AppStrings.eBusiness(context), 
        'description': AppStrings.businessDescription(context),
        'imagePath': 'assets/images/E_BUSINESS.png',
        'type': 'business',
      },
      {
        'name': AppStrings.eCommerce(context), 
        'description': AppStrings.eCommerceDescription(context),
        'imagePath': 'assets/images/E_commerce.png',
        'type': 'business',
      },
      {
        'name': AppStrings.marketing(context), 
        'description': AppStrings.marketingDescription(context),
        'imagePath': 'assets/images/Marketing2.png',
        'type': 'marketing',
      },
      {
        'name': AppStrings.development(context), 
        'description': AppStrings.developmentDescription(context),
        'imagePath': 'assets/images/devolp.png',
        'type': 'development',
      },
    ];
  }
}
