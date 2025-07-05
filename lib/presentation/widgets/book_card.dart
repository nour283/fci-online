import 'package:flutter/material.dart';
import 'package:tadrib_hub/models/book_model.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';

class BookCard extends StatelessWidget {
  final BookItem book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppValues.cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppValues.cardBorderRadius),
              child: Container(
                width: double.infinity,
                child: Image.asset(
                  book.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.smallPadding,
                vertical: 6,
              ),
              child: Text(
                book.title.replaceAll('\n', ' '),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppValues.bookTitleFontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}