import 'package:flutter/material.dart';
import 'package:ff_t/utils/colors.dart';
import 'package:ff_t/components/neu_button.dart';

enum SocialPlatform { facebook, google, apple }

class SocialButton extends StatelessWidget {
  final SocialPlatform platform;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.platform,
    required this.onPressed,
  });

  Color _getBackgroundColor() {
    switch (platform) {
      // GOOGLE BUTTON COLOR FIX: Changed to a standard red color.
      case SocialPlatform.google:
        return const Color(0xFFDB4437);
      case SocialPlatform.facebook:
        return const Color(0xFF1877F2);
      case SocialPlatform.apple:
        return Colors.black;
    }
  }

  Color _getForegroundColor() {
    // GOOGLE BUTTON COLOR FIX: Text and icon are now white for contrast.
    return Colors.white;
  }

  Widget _getIcon() {
    switch (platform) {
      case SocialPlatform.google:
        return const Icon(Icons.g_mobiledata_rounded, color: Colors.white);
      case SocialPlatform.facebook:
        return const Icon(Icons.facebook, color: Colors.white);
      case SocialPlatform.apple:
        return const Icon(Icons.apple, color: Colors.white);
    }
  }

  String _getText() {
    switch (platform) {
      case SocialPlatform.google:
        return 'Continue with Google';
      case SocialPlatform.facebook:
        return 'Continue with Facebook';
      case SocialPlatform.apple:
        return 'Continue with Apple';
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeuButton(
      text: _getText(),
      onPressed: onPressed,
      backgroundColor: _getBackgroundColor(),
      textColor: _getForegroundColor(),
      prefixIcon: _getIcon(),
    );
  }
}
