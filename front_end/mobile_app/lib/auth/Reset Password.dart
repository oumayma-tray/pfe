import 'package:flutter/material.dart';
import 'package:mobile_app/components/texfieldEye.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/auth/authentificationService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/components/button.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final newpasswordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  bool passwordMatchError = false;
  bool showSuccessMessage = false;
  bool isLoading = false; // Declare isLoading here

  void submit() async {
    if (newpasswordController.text != confirmpasswordController.text) {
      setState(() {
        passwordMatchError = true;
        showSuccessMessage = false;
      });
      return;
    }

    setState(() {
      isLoading = true; // Set isLoading to true when operation starts
    });

    try {
      await Provider.of<AuthenticationService>(context, listen: false)
          .updatePassword(newpasswordController.text);

      setState(() {
        showSuccessMessage = true;
        passwordMatchError = false;
        newpasswordController.clear();
        confirmpasswordController.clear();
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to update password: ${e.toString()}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false; // Set isLoading to false when operation ends
      });
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
