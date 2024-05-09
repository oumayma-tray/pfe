import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/auth/authentificationService.dart';
import 'package:mobile_app/components/textfield.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String message = '';

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      bool emailSent =
          await Provider.of<AuthenticationService>(context, listen: false)
              .sendPasswordResetEmail(emailController.text.trim());
      if (emailSent) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Check Your Email"),
            content: Text(
                "A password reset link has been sent to your email. Please follow the instructions to reset your password."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pop(); // Optionally navigate back to the login screen
                },
              ),
            ],
          ),
        );
      } else {
        showErrorDialog("No account found with this email.");
      }
    } on FirebaseAuthException catch (e) {
      showErrorDialog(e.message ?? "An unexpected error occurred.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
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
        resizeToAvoidBottomInset: false, //remove the overflow
        backgroundColor: Color(0XFF28243D),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.032,
              ), //khater hasb design logo b3id al top 23.2 w a7na aana screen height 722 donc 23.2/722= 0.032
              Image.asset("assets/Group.png"),

              SizedBox(
                height: screenHeight * 0.097,
              ),
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
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  //mail text-field
                  Textfield(
                    controller: emailController,
                    hintText: 'Email',
                    Icon: Icon(Icons.email_outlined, color: Colors.white),
                    obscureText: false,
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              //submit box
              ElevatedButton(
                onPressed: resetPassword,
                child: Text('Reset Password'),
              ),
              SizedBox(
                height: screenHeight * 0.1213,
              ),

              Expanded(
                child: Stack(
                  children: [
                    // Right vector
                    Positioned(
                      right: 0,
                      child: Image.asset('assets/lv.png'),
                    ),
                    // Left vector
                    Positioned(
                      left: 0,
                      child: Image.asset('assets/rv.png'),
                    ),
                    // PC image

                    // Ellipse image
                    Positioned(
                      top: screenHeight * 0.75 / 4, // Adjust the top position
                      left: screenWidth * 1.5 / 4, // Adjust the left position

                      child: Transform.scale(
                        scale: 2.8,
                        child: Image.asset('assets/ellipse1.png'),
                      ),
                    ),
                    Positioned.fill(
                      top: screenHeight * 0.001, // Adjust the top position

                      child: Transform.scale(
                        scale: 1.24, // Adjust the scale factor as needed
                        child: Image.asset('assets/pc.png'),
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
