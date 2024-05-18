import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/components/textfield.dart';
import 'package:mobile_app/services/Auth_service/authentificationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/auth/login.dart'; // Import the login screen or any other relevant screen

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  late AuthenticationService authService;
  late BuildContext _dialogContext;

  @override
  void initState() {
    super.initState();
    authService = AuthenticationService(FirebaseAuth.instance);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: _dialogContext,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: _dialogContext,
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

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(_dialogContext).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _promptEmailVerification() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      _showErrorDialog("Please enter your email address.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.resetPassword(email);
      _showSnackbar("Password reset email sent. Please check your email.");
      // Navigate to login screen or any other relevant screen
      Navigator.of(_dialogContext).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                LoginScreen()), // Replace with your login screen
      );
    } catch (e) {
      _showErrorDialog("Failed to send reset email. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Remove the overflow
        backgroundColor: Color(0XFF28243D),
        body: Builder(
          builder: (BuildContext context) {
            _dialogContext = context;
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
                        "Forgot Password?",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Email text field
                      Textfield(
                        controller: emailController,
                        hintText: 'Email',
                        icon: Icon(Icons.email_outlined, color: Colors.white),
                        obscureText: false,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Submit button
                  ElevatedButton(
                    onPressed: _promptEmailVerification,
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text('Reset Password'),
                  ),
                  SizedBox(height: screenHeight * 0.1213),
                  Expanded(
                    child: Stack(
                      children: [
                        // Right vector
                        Positioned(
                            right: 0, child: Image.asset('assets/lv.png')),
                        // Left vector
                        Positioned(
                            left: 0, child: Image.asset('assets/rv.png')),
                        // PC image
                        Positioned.fill(
                          top: screenHeight * 0.001, // Adjust the top position
                          child: Transform.scale(
                            scale: 1.24, // Adjust the scale factor as needed
                            child: Image.asset('assets/pc.png'),
                          ),
                        ),
                        // Ellipse image
                        Positioned(
                          top: screenHeight *
                              0.75 /
                              4, // Adjust the top position
                          left:
                              screenWidth * 1.5 / 4, // Adjust the left position
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
