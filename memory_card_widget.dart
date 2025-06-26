// In lib/components/memory_card_widget.dart
import 'package:flutter/material.dart';
import 'package:ff_t/utils/colors.dart';
import 'package:ff_t/utils/constants.dart';
import 'package:ff_t/utils/text_styles.dart';

class MemoryCardWidget extends StatelessWidget {
  final String letter;
  final Color backgroundColor;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isIncorrect; // <-- New property for wrong match
  final bool isMatched;
  final bool isVisible;

  const MemoryCardWidget({
    super.key,
    required this.letter,
    required this.backgroundColor,
    required this.onTap,
    this.isSelected = false,
    this.isIncorrect = false, // <-- Initialize
    this.isMatched = false,
    this.isVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    if (isIncorrect) {
      borderColor = accentRed; // <-- Red border for incorrect match
    } else if (isSelected) {
      borderColor = accentYellow;
    } else {
      borderColor = Colors.transparent;
    }

    return AnimatedOpacity(
      opacity: isMatched ? 0.0 : 1.0,
      duration: AppConstants.defaultAnimationDuration,
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isVisible ? backgroundColor : primaryDark.withOpacity(0.8),
            borderRadius:
                BorderRadius.circular(AppConstants.defaultBorderRadius / 1.5),
            border: Border.all(color: borderColor, width: 3.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6.0,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Center(
            child: isVisible
                ? Text(letter,
                    style: AppTextStyles.headline1
                        .copyWith(color: white, fontSize: 50))
                : const Icon(Icons.question_mark_rounded,
                    color: accentBlue, size: 40),
          ),
        ),
      ),
    );
  }
}
