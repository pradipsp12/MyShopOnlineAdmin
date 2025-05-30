import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:admin/screens/main/main_screen.dart';
import '../../utility/snack_bar_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      
      theme: LoginTheme(
        pageColorLight: Colors.grey[900], // Dark background
        pageColorDark: Colors.grey[850], // Slightly lighter dark shade
        primaryColor: Colors.blueAccent, // Retain vibrant primary color
        accentColor: Colors.grey[200], // Light accent for contrast
        cardTheme: CardTheme(
          color: Colors.grey[800], // Dark card background
          elevation: 12, // Keep elevation for depth
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Softer corners
            side: BorderSide(color: Colors.grey[700]!, width: 1), // Subtle dark border
          ),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[850], // Darker input background
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[600]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400),
          labelStyle: TextStyle(color: Colors.grey[200], fontWeight: FontWeight.w500),
        ),
        titleStyle: const TextStyle(
          color: Colors.blueAccent,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        bodyStyle: TextStyle(
          color: Colors.grey[200], // Light text for dark background
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        buttonTheme: LoginButtonTheme(
          backgroundColor: Colors.blueAccent,
          highlightColor: Colors.blue[600], // Slightly darker highlight
          elevation: 4,
          highlightElevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        errorColor: Colors.redAccent,
        switchAuthTextColor: Colors.blueAccent,
      ),
      logo: 'assets/images/logo.png', // Logo unchanged
      title: 'Admin Panel',
       userValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Username cannot be empty';
        }
        return null; // Accept any non-empty string as a valid username
      },
      onLogin: (loginData) async {
        try {
          final result = await context.authServiceProvider.login(loginData.name, loginData.password);
          if (result != null) {
            SnackBarHelper.showErrorSnackBar('Login failed: $result');
          }
          return result;
        } catch (e) {
          SnackBarHelper.showErrorSnackBar('An error occurred: $e');
          return e.toString();
        }
      },
      onSignup: null, // Signup remains disabled
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      },
      onRecoverPassword: (String email) async {
        SnackBarHelper.showErrorSnackBar('Password recovery is not supported');
        return 'Password recovery is not supported';
      },
      messages: LoginMessages(
        userHint: 'Username',
        passwordHint: 'Password',
        loginButton: 'LOG IN',
        flushbarTitleError: 'Login Error',
        flushbarTitleSuccess: 'Login Success',
      ),
      scrollable: true,
      hideForgotPasswordButton: true,
    );
  }
}