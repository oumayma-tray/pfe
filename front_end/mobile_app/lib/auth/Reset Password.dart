import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/components/button.dart';
import 'package:mobile_app/components/texfieldEye.dart';

class ResetPassword extends StatefulWidget {
  final Function()? onTap;

  ResetPassword({Key? key, required this.onTap}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final newpasswordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  bool passwordMatchError = false;
  bool showSuccessMessage = false;

  void submit() async {
    // Check if the passwords match
    if (newpasswordController.text != confirmpasswordController.text) {
      setState(() {
        passwordMatchError = true;
        showSuccessMessage =
            false; // Reset success message if passwords don't match
      });
      return;
    }

    // Attempt to update the password
    try {
      // Get the current user
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newpasswordController.text);

        // Show success message
        setState(() {
          showSuccessMessage = true;
          passwordMatchError = false;
        });

        // Optionally, navigate the user or perform other actions like logging out
        // Navigator.pushReplacementNamed(context, '/login'); // Example: Navigate to login page
      } else {
        // Handle case where user is not found (unlikely unless user data is corrupted or session expired)
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Session Expired"),
              content: Text("Please log in again to update your password."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle errors, such as weak password, recent login required, etc.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error Updating Password"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
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
              SizedBox(
                height: screenHeight * 0.032,
              ),
              Image.asset("assets/Group.png"),
              SizedBox(
                height: screenHeight * 0.097,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reset Password?",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  // New password text-field
                  TextFieldEye(
                    controller: newpasswordController,
                    hintText: 'New Password',
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Confirm password text-field
                  TextFieldEye(
                    controller: confirmpasswordController,
                    hintText: 'Confirm New Password',
                  ),

                  // Display error message if passwords don't match
                  if (passwordMatchError)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Passwords do not match.",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),

                  // Display success message
                  if (showSuccessMessage)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Password changed successfully!",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              // Submit button
              button(onTap: submit),
              SizedBox(
                height: screenHeight * 0.1213,
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: Image.asset('assets/vecp3.png'),
                    ),
                    Positioned.fill(
                      top: screenHeight * 0.06,
                      right: screenWidth * 0.4,
                      child: Transform.scale(
                        scale: 1.066,
                        child: Image.asset('assets/imgp3.png'),
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
