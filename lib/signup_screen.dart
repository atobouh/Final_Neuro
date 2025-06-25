import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ff_t/components/neu_button.dart';
import 'package:ff_t/components/neu_text_field.dart';
import 'package:ff_t/utils/colors.dart';
import 'package:ff_t/utils/constants.dart';
import 'package:ff_t/utils/text_styles.dart';
import 'package:ff_t/screens/create_profile_screen.dart';
import 'package:ff_t/screens/auth/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  CreateProfileScreen(currentUser: userCredential.user)),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? 'Signup failed. Please try again.',
          isError: true);
    } catch (e) {
      _showSnackBar('An unexpected error occurred.', isError: true);
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NAVIGATION FIX: Added AppBar with a back button
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
                  // LOGO ADDED
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
                  Text('Join Neuroplay', style: AppTextStyles.headline1),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text('Create an account to get started.',
                      style: AppTextStyles.bodyText2),
                  const SizedBox(height: AppConstants.largePadding * 2),
                  NeuTextField(
                    controller: _nameController,
                    hintText: 'Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  NeuTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter your email' : null,
                  ),
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
                  const SizedBox(height: AppConstants.defaultPadding),
                  NeuTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: !_isConfirmPasswordVisible,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                        icon: Icon(_isConfirmPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => setState(() =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible)),
                    validator: (v) => v != _passwordController.text
                        ? 'Passwords do not match'
                        : null,
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  NeuButton(
                    text: 'Sign Up',
                    onPressed: _handleSignup,
                    isLoading: _isLoading,
                    backgroundColor: accentBlue,
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                          style: AppTextStyles.bodyText2),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen())),
                        child: Text('Login', style: AppTextStyles.linkText),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
