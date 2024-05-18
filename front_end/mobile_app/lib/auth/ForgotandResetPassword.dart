import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mobile_app/components/textfield.dart';
import 'package:mobile_app/components/texfieldEye.dart';
import 'package:mobile_app/services/Auth_service/authentificationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class ForgotAndResetPassword extends StatefulWidget {
  @override
  State<ForgotAndResetPassword> createState() => _ForgotAndResetPasswordState();
}

class _ForgotAndResetPasswordState extends State<ForgotAndResetPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool passwordMatchError = false;
  bool showSuccessMessage = false;
  bool isLoading = false;
  late AuthenticationService authService;

  @override
  void initState() {
    super.initState();
    authService = AuthenticationService(FirebaseAuth.instance);
  }

  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (!EmailValidator.validate(emailController.text.trim())) {
      _showErrorDialog("Please enter a valid email address.");
      return;
    }
    if (newPasswordController.text.trim().length < 6) {
      _showErrorDialog("Password must be at least 6 characters long.");
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      _showErrorDialog("Passwords do not match.");
      return;
    }

    setState(() => isLoading = true);

    try {
      bool userExists =
          await authService.checkUserExists(emailController.text.trim());
      if (!userExists) {
        _showErrorDialog("No user found with this email.");
        setState(() => isLoading = false);
        return;
      }

      await authService.sendEmailVerification();
      _showVerificationAwaitDialog();

      Timer.periodic(Duration(seconds: 5), (timer) async {
        User? user = FirebaseAuth.instance.currentUser;
        await user!.reload();
        if (user.emailVerified) {
          timer.cancel();
          _handlePasswordReset();
        }
      });
    } catch (e) {
      _showErrorDialog(e.toString());
      setState(() => isLoading = false);
    }
  }

  void _showVerificationAwaitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Verify Your Email'),
        content: Text(
            'A verification email has been sent. Please check your email and click the verification link. Press "CHECK" once you have verified.'),
        actions: <Widget>[
          TextButton(
            child: Text('CHECK'),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              User? user = FirebaseAuth.instance.currentUser;
              await user!.reload();
              if (user.emailVerified) {
                _handlePasswordReset(); // Method to handle password reset
              } else {
                _showErrorDialog("Please verify your email to proceed.");
              }
            },
          ),
        ],
      ),
    );
  }

  void _handlePasswordReset() async {
    try {
      await authService.updatePassword(newPasswordController.text.trim());
      setState(() {
        showSuccessMessage = true;
        newPasswordController.clear();
        confirmPasswordController.clear();
      });
      _showSuccessDialog("Password has been successfully reset.");
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0XFF28243D),
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.032),
                  Image.asset("assets/Group.png"),
                  SizedBox(height: screenHeight * 0.097),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Forgot and Reset Password?",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Email text field
                      Textfield(
                        controller: emailController,
                        hintText: 'Email',
                        icon: Icon(Icons.email_outlined, color: Colors.white),
                        obscureText: false,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // New password text field
                      TextFieldEye(
                        controller: newPasswordController,
                        hintText: 'New Password',
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Confirm new password text field
                      TextFieldEye(
                        controller: confirmPasswordController,
                        hintText: 'Confirm New Password',
                      ),
                      if (passwordMatchError)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Passwords do not match.",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      if (showSuccessMessage)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Password changed successfully!",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Submit button
                  ElevatedButton(
                    onPressed: resetPassword,
                    child: Text('Submit'),
                  ),
                  SizedBox(height: screenHeight * 0.1213),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                            right: 0, child: Image.asset('assets/lv.png')),
                        Positioned(
                            left: 0, child: Image.asset('assets/rv.png')),
                        Positioned.fill(
                          top: screenHeight * 0.001,
                          child: Transform.scale(
                            scale: 1.24,
                            child: Image.asset('assets/pc.png'),
                          ),
                        ),
                        Positioned(
                          top: screenHeight * 0.75 / 4,
                          left: screenWidth * 1.5 / 4,
                          child: Transform.scale(
                            scale: 2.8,
                            child: Image.asset('assets/ellipse1.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
