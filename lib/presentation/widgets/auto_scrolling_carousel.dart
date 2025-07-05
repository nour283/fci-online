import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollingCarousel extends StatefulWidget {
  @override
  _AutoScrollingCarouselState createState() => _AutoScrollingCarouselState();
}

class _AutoScrollingCarouselState extends State<AutoScrollingCarousel> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final List<String> images = [
    "assets/images/python.png",
    "assets/images/E_commerce.png",
    "assets/images/jave.png",
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAutoScroll();
    });
  }

  void startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          );
        },
      ),
    );
  }
}
