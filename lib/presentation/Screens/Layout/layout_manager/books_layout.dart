import 'package:flutter/material.dart';
import 'package:tadrib_hub/models/book_model.dart';
import 'package:tadrib_hub/presentation/widgets/book_card.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';


class CustomBooksLayout extends StatelessWidget {
  final List<BookItem> books;

  const CustomBooksLayout({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noBooksAvailable(context),
          style: TextStyle(
            fontSize: AppValues.mediumPadding,
            color: AppColors.grey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (books.length >= 1) _buildRow(books.take(3).toList()),
          
          const SizedBox(height: AppValues.mediumPadding),
          
          if (books.length >= 4) _buildRow(books.skip(3).take(3).toList()),
          
          const SizedBox(height: AppValues.mediumPadding),
          
          if (books.length >= 7) _buildCenterRow(books.skip(6).take(1).toList()),
          
          const SizedBox(height: AppValues.mediumPadding),
          
          if (books.length > 7) ..._buildAdditionalRows(books.skip(7).toList()),
        ],
      ),
    );
  }

  Widget _buildRow(List<BookItem> rowBooks) {
    return Row(
      children: [
        for (int i = 0; i < 3; i++) ...[
          if (i < rowBooks.length)
            Expanded(child: BookCard(book: rowBooks[i]))
          else
            const Expanded(child: SizedBox()),
          if (i < 2) const SizedBox(width: AppValues.mediumPadding),
        ],
      ],
    );
  }

  Widget _buildCenterRow(List<BookItem> centerBooks) {
    if (centerBooks.isEmpty) return const SizedBox();
    
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(child: BookCard(book: centerBooks[0])),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  List<Widget> _buildAdditionalRows(List<BookItem> remainingBooks) {
    List<Widget> rows = [];
    
    for (int i = 0; i < remainingBooks.length; i += 3) {
      List<BookItem> rowBooks = remainingBooks.skip(i).take(3).toList();
      rows.add(_buildRow(rowBooks));
      if (i + 3 < remainingBooks.length) {
        rows.add(const SizedBox(height: AppValues.mediumPadding));
      }
    }
    
    return rows;
  }
}