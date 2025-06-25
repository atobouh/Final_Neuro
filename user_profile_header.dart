import 'package:flutter/material.dart';
import 'package:ff_t/utils/colors.dart';
import 'package:ff_t/utils/constants.dart';
import 'package:ff_t/utils/text_styles.dart';

class UserProfileHeader extends StatelessWidget {
  final String userName;
  final int userAge;
  final String avatarPath;
  final VoidCallback? onTap;

  const UserProfileHeader({
    super.key,
    required this.userName,
    required this.userAge,
    required this.avatarPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        decoration: BoxDecoration(
          color: primaryDark,
          borderRadius:
              BorderRadius.circular(AppConstants.defaultBorderRadius * 2),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accentBlue, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  avatarPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                      child:
                          Icon(Icons.broken_image, size: 30, color: errorRed)),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: Text(userName, style: AppTextStyles.headline4),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: accentYellow,
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
              child: Text(
                'Age $userAge',
                style: AppTextStyles.bodyText1
                    .copyWith(color: primaryDark, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
