import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:ff_t/components/neu_button.dart';
import 'package:ff_t/components/neu_text_field.dart';
import 'package:ff_t/utils/colors.dart';
import 'package:ff_t/utils/constants.dart';
import 'package:ff_t/utils/text_styles.dart';
import 'package:ff_t/screens/auth/forgot_password_screen.dart';
import 'package:ff_t/screens/auth/signup_screen.dart';
import 'package:ff_t/main.dart'; // For SettingsProvider and AppCoreRouter
import 'package:ff_t/components/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: AppTextStyles.bodyText1.copyWith(color: white)),
        backgroundColor: isError ? errorRed : successGreen,
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Provider.of<SettingsProvider>(context, listen: false)
            .setHasSeenOnboarding(true);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AppCoreRouter()),
          (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? 'Login failed. Please try again.',
          isError: true);
    } catch (e) {
      _showSnackBar('An unexpected error occurred.', isError: true);
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // GOOGLE LOGIN FIX: The full, correct flow for web and mobile
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (mounted) setState(() => _isLoading = false);
        return; // User cancelled the flow
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        Provider.of<SettingsProvider>(context, listen: false)
            .setHasSeenOnboarding(true);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AppCoreRouter()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      _showSnackBar('Google Sign-In failed. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryDark,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10)
                      ],
                    ),
                    child: ClipOval(
                      child:
                          Image.asset('lib/Assets/icon.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  Text('Welcome Back!', style: AppTextStyles.headline1),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text('Login to continue your learning journey.',
                      style: AppTextStyles.bodyText2),
                  const SizedBox(height: AppConstants.largePadding * 2),
                  NeuTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (v) =>
                          v!.isEmpty ? 'Please enter your email' : null),
                  const SizedBox(height: AppConstants.defaultPadding),
                  NeuTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: !_isPasswordVisible,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible)),
                    validator: (v) => v!.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen())),
                        child: Text('Forgot Password?',
                            style: AppTextStyles.bodyText2
                                .copyWith(color: mediumText))),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  NeuButton(
                      text: 'Login',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                      backgroundColor: accentBlue),
                  const SizedBox(height: AppConstants.largePadding),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: mediumText)),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.smallPadding),
                          child: Text('OR', style: AppTextStyles.bodyText2)),
                      const Expanded(child: Divider(color: mediumText)),
                    ],
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  SocialButton(
                      platform: SocialPlatform.google,
                      onPressed: _signInWithGoogle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
