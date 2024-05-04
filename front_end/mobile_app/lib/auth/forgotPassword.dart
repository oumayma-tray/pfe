import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/components/button.dart';
import 'package:mobile_app/components/textfield.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPassword extends StatefulWidget {
  final Function()? onTap;
  ForgotPassword({super.key, required this.onTap});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //text editing controllers
  final emailController = TextEditingController();

//submit  method
// submit method
  void submit() async {
    // Validate email address
    bool isEmailValid = EmailValidator.validate(emailController.text);
    if (!isEmailValid) {
      // Show error message for invalid email
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Invalid Email"),
            content: Text("Please enter a valid email address."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.toLowerCase());
      // Assuming email exists and reset email sent, navigate to ResetPassword page
      Navigator.pushNamed(context, '/reset_password');
    } catch (e) {
      // If an error occurs (e.g., email not found), handle it appropriately
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "An error occurred. Please check the email address and try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  bool isChecked = false;

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
              button(
                onTap: submit,
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
