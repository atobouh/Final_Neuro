import 'package:flutter/material.dart';
import 'package:ff_t/utils/colors.dart';
import 'package:ff_t/utils/constants.dart';
import 'package:ff_t/utils/text_styles.dart';

class NeuButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? prefixIcon;
  final bool isLoading;
  final double? width;
  final double? height;

  const NeuButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.prefixIcon,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // This button now has no audio logic
    return SizedBox(
      width: width,
      height: height ?? AppConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? accentYellow,
          foregroundColor: textColor ?? primaryDark,
          disabledBackgroundColor:
              (backgroundColor ?? accentYellow).withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor ?? primaryDark,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: AppConstants.smallPadding),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.buttonText
                        .copyWith(color: textColor ?? primaryDark),
                  ),
                ],
              ),
      ),
    );
  }
}
