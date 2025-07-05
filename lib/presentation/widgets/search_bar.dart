import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';
import 'package:tadrib_hub/utils/values_manager.dart';

class BookSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final bool isListening;
  final VoidCallback onClear;
  final VoidCallback onMicPressed;

  const BookSearchBar({
    Key? key,
    required this.controller,
    required this.isListening,
    required this.onClear,
    required this.onMicPressed,
  }) : super(key: key);

  @override
  State<BookSearchBar> createState() => _BookSearchBarState();
}

class _BookSearchBarState extends State<BookSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppValues.searchBarBorderRadius),
        border: Border.all(color: AppColors.grey),
      ),
      child: Row(
        children: [
          const SizedBox(width: AppValues.mediumPadding),
          Icon(Icons.search, color: AppColors.grey),
          const SizedBox(width: AppValues.smallPadding),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint(context),
                hintStyle: TextStyle(color: AppColors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          if (widget.controller.text.isNotEmpty)
            Tooltip(
              message: AppStrings.clearSearch(context),
              child: IconButton(
                icon: Icon(Icons.clear, color: AppColors.grey),
                onPressed: widget.onClear,
              ),
            ),
          Tooltip(
            message: widget.isListening 
                ? AppStrings.listening(context)
                : AppStrings.searchHint(context),
            child: IconButton(
              icon: Icon(
                widget.isListening ? Icons.mic_off : Icons.mic,
                color: widget.isListening ? AppColors.error : AppColors.primary,
              ),
              onPressed: widget.onMicPressed,
            ),
          ),
        ],
      ),
    );
  }
}