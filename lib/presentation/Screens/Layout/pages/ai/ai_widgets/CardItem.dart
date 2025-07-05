import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String title;
  final VoidCallback onLanguagePressed;

  const CardItem({
    Key? key,
    required this.title,
    required this.onLanguagePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    
    double cardWidth = screenWidth * 0.6;
    double cardHeight = screenHeight * 0.23;

    return Center(
      child: Container(
        width: cardWidth, 
        height: cardHeight, 
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE6E0E9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: onLanguagePressed,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.language,
                    size: 22,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}