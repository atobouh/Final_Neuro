import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_t/firebase_options.dart';
import 'package:ff_t/utils/colors.dart';
import 'package:ff_t/utils/constants.dart';
import 'package:ff_t/utils/text_styles.dart';
import 'package:ff_t/screens/auth/login_screen.dart';
import 'package:ff_t/screens/home_screen.dart';
import 'package:ff_t/screens/create_profile_screen.dart';
import 'package:ff_t/screens/onboarding_screen.dart';

// A simple class to hold user profile data
class UserProfile {
  final String name;
  final int age;
  final String avatarPath;
  UserProfile(
      {required this.name, required this.age, required this.avatarPath});
}

late SharedPreferences _prefs;

class SettingsProvider with ChangeNotifier {
  bool _hasSeenOnboarding = false;
  Color? _overlayColor;
  SettingsProvider() {
    _hasSeenOnboarding = _prefs.getBool('hasSeenOnboarding') ?? false;
    final int? overlayColorValue = _prefs.getInt('overlayColor');
    if (overlayColorValue != null) {
      _overlayColor = Color(overlayColorValue);
    }
  }
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  Color? get overlayColor => _overlayColor;
  Future<void> setHasSeenOnboarding(bool value) async {
    if (_hasSeenOnboarding != value) {
      _hasSeenOnboarding = value;
      await _prefs.setBool('hasSeenOnboarding', value);
      notifyListeners();
    }
  }

  Future<void> setOverlayColor(Color? color) async {
    if (_overlayColor != color) {
      _overlayColor = color;
      if (color != null) {
        await _prefs.setInt('overlayColor', color.value);
      } else {
        await _prefs.remove('overlayColor');
      }
      notifyListeners();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _prefs = await SharedPreferences.getInstance();
  runApp(ChangeNotifierProvider(
      create: (context) => SettingsProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: accentBlue,
        scaffoldBackgroundColor: backgroundDark,
        fontFamily: AppConstants.fontFamily,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleTextStyle: AppTextStyles.headline3,
            iconTheme: const IconThemeData(color: lightText)),
        colorScheme: const ColorScheme.light(
            primary: accentBlue,
            secondary: accentYellow,
            background: backgroundDark,
            surface: primaryDark,
            error: errorRed),
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Consumer<SettingsProvider>(
        builder: (context, settings, _) => Stack(
          children: [
            child!,
            if (settings.overlayColor != null)
              IgnorePointer(child: Container(color: settings.overlayColor))
          ],
        ),
      ),
      home: const AppCoreRouter(),
    );
  }
}

class AppCoreRouter extends StatelessWidget {
  const AppCoreRouter({super.key});
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    if (!settingsProvider.hasSeenOnboarding) return const OnboardingScreen();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting)
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        if (authSnapshot.hasData) return ProfileGate(user: authSnapshot.data!);
        return const LoginScreen();
      },
    );
  }
}

// PROFILE UPDATE FIX: This now uses a StreamBuilder to listen for live data changes.
class ProfileGate extends StatelessWidget {
  final User user;
  const ProfileGate({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      // <-- Changed to StreamBuilder
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(), // <-- Listen to snapshots()
      builder: (context, profileSnapshot) {
        if (profileSnapshot.connectionState == ConnectionState.waiting)
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        if (profileSnapshot.hasError)
          return const Scaffold(
              body: Center(child: Text('Error loading profile.')));

        // If user document exists, go to HomeScreen
        if (profileSnapshot.hasData && profileSnapshot.data!.exists) {
          final data = profileSnapshot.data!.data() as Map<String, dynamic>;
          final userProfile = UserProfile(
            name: data['name'] as String? ?? 'Player',
            age: data['age'] as int? ?? 0,
            avatarPath: data['avatarPath'] as String? ??
                AppConstants.profileAvatarSvgs[0],
          );
          return HomeScreen(
              userProfile: userProfile); // Pass the UserProfile object
        } else {
          // No profile, force creation
          return CreateProfileScreen(currentUser: user);
        }
      },
    );
  }
}

