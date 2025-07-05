import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/widgets/Courses_HeaderSection.dart';
import 'package:tadrib_hub/presentation/widgets/Courses_sectionContainer.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/layout_manager/layout_provider.dart';


class CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'programming': GlobalKey(),
    'design': GlobalKey(),
    'development': GlobalKey(),
    'business': GlobalKey(),
    'marketing': GlobalKey(),
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProvider>(
      builder: (context, layoutProvider, child) {
        if (layoutProvider.shouldNavigateToCourseDetail) {
          return WillPopScope(
            onWillPop: () async {
              layoutProvider.resetCourseNavigation();
              return false;
            },
            child: Scaffold(
              body: layoutProvider.getCourseDetailPage(),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              controller: _scrollController,
              children: [
                HeaderSection(
                  sectionKeys: _sectionKeys,
                  scrollController: _scrollController,
                ),
                SectionContainer(
                  sectionKeys: _sectionKeys,
                  scrollController: _scrollController,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
