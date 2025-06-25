class AppConstants {
  // APP NAME CHANGE: Updated the app name to "Neuroplay"
  static const String appName = 'Neuroplay';
  static const String fontFamily = 'OpenDyslexic';

  // APP LOGO CHANGE: Updated the asset path to your new logo
  static const String centralSvgAsset = 'lib/Assets/icon.jpg';

  // --- The rest of the constants remain the same ---

  static const List<String> profileAvatarSvgs = [
    'lib/Icons/Robot 64.png',
    'lib/Icons/Angry face 64.png',
    'lib/Icons/Angry face with horns 64.png',
    'lib/Icons/Anguished face 64.png',
    'lib/Icons/Anxious face with sweat 64.png',
    'lib/Icons/Astonished face 64.png',
    'lib/Icons/Beaming face with smiling eyes 64.png',
  ];

  static const int initialMemoryGameLives = 3;
  static const String phonicPlaygroundIcon =
      'lib/Icons/icons8-playground-94.png';
  static const String memoryMatchGameIcon = 'lib/Icons/icons8-color-96.png';
  static const String letterDirectionDefenderIcon =
      'lib/Icons/icons8-brain-96.png';
  static const String traceItRightIcon = 'lib/Icons/Writing Hand 64.png';

  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration feedbackDisplayDuration = Duration(seconds: 2);

  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  static const double defaultBorderRadius = 20.0;
  static const double buttonHeight = 50.0;
}
