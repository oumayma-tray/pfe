import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/components/textfield.dart';
import 'package:mobile_app/services/Auth_service/authentificationService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  late AuthenticationService authService;

  @override
  void initState() {
    super.initState();
    authService = AuthenticationService(FirebaseAuth.instance);
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetPassword() async {
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog("Please enter and confirm your new password.");
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog("Passwords do not match. Please try again.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = authService.currentUser;
      if (user != null) {
        await user.updatePassword(password);
        _showSnackbar("Password has been changed successfully.");
        Navigator.of(context).pop(); // Go back to previous screen
      }
    } catch (e) {
      _showErrorDialog("Failed to change password. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
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
        body: Center(
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
                    "Reset Password",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // New password text field
                  Textfield(
                    controller: passwordController,
                    hintText: 'New Password',
                    icon: Icon(Icons.lock_outline, color: Colors.white),
                    obscureText: true,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Confirm new password text field
                  Textfield(
                    controller: confirmPasswordController,
                    hintText: 'Confirm New Password',
                    icon: Icon(Icons.lock_outline, color: Colors.white),
                    obscureText: true,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              // Submit button
              ElevatedButton(
                onPressed: _resetPassword,
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Change Password'),
              ),
              SizedBox(height: screenHeight * 0.1213),
              Expanded(
                child: Stack(
                  children: [
                    // Right vector
                    Positioned(right: 0, child: Image.asset('assets/lv.png')),
                    // Left vector
                    Positioned(left: 0, child: Image.asset('assets/rv.png')),
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
                      top: screenHeight * 0.75 / 4, // Adjust the top position
                      left: screenWidth * 1.5 / 4, // Adjust the left position
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
        ),
      ),
    );
  }
}
