import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/auth/authentificationService.dart';
import 'package:mobile_app/components/textfield.dart';
import 'package:mobile_app/homePage.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final authService =
          Provider.of<AuthenticationService>(context, listen: false);
      final userCredential = await authService.signInWithGoogle();
      if (userCredential.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? "Failed to sign in with Google.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> register() async {
    if (!EmailValidator.validate(emailController.text.trim())) {
      _showErrorDialog("Please enter a valid email address.");
      return;
    }
    if (passwordController.text.trim().length < 6) {
      _showErrorDialog("Password must be at least 6 characters long.");
      return;
    }

    setState(() => isLoading = true);
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context, listen: false);

    try {
      await authService.registerWithEmailAndPassword(
          emailController.text.trim(), passwordController.text.trim());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(
          e.message ?? "An unexpected error occurred during registration.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
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
                    "Register",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Textfield(
                    controller: emailController,
                    hintText: 'Email',
                    Icon: Icon(Icons.email_outlined, color: Colors.white),
                    obscureText: false,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Textfield(
                    controller: passwordController,
                    hintText: 'Password',
                    Icon: Icon(Icons.lock_outline, color: Colors.white),
                    obscureText: _isObscure,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: register,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Register', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF9155FD)),
              ),
              ElevatedButton(
                onPressed: () => signInWithGoogle(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/google.png',
                        height: 24), // Ensure you have this asset
                    SizedBox(width: 10),
                    Text('Sign in with Google'),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
