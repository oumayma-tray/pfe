import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/auth/register.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/auth/authentificationService.dart';
import 'package:mobile_app/auth/forgotPassword.dart';
import 'package:mobile_app/components/textfield.dart';
import 'package:mobile_app/homePage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    if (password.length < 6) {
      _showErrorDialog('Your password must be at least 6 characters.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthenticationService>(context, listen: false)
          .signInWithEmailAndPassword(email, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthMultiFactorException catch (e) {
      // Handle the second factor requirement
      handleMultiFactorAuthentication(e);
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'An unexpected error occurred.');
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void handleMultiFactorAuthentication(FirebaseAuthMultiFactorException e) {
    final resolver = e.resolver;
    // Example: prompt for SMS verification
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController smsCodeController = TextEditingController();
        return AlertDialog(
          title: Text("Multi-Factor Authentication"),
          content: TextField(
            controller: smsCodeController,
            decoration: InputDecoration(labelText: "Enter SMS code"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId:
                      resolver.session.id, // Get the session ID correctly
                  smsCode: smsCodeController.text.trim(),
                );
                try {
                  await resolver.resolveSignIn(
                      PhoneMultiFactorGenerator.getAssertion(credential));
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } catch (e) {
                  _showErrorDialog(
                      "Failed to verify SMS code: ${e.toString()}");
                }
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically signs in the user.
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle error.
      },
      codeSent: (String verificationId, int? resendToken) {
        // This callback is where you get your verificationId
        _showVerificationCodeInput(
            context, verificationId); // Call a function to show input dialog
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto retrieval timeout handling
      },
    );
  }

  void _showVerificationCodeInput(BuildContext context, String verificationId) {
    TextEditingController codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Verification Code"),
          content: TextField(
            controller: codeController,
            decoration: InputDecoration(labelText: "Verification code"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: codeController.text.trim(),
                );

                // Now, sign in with the credential
                try {
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  Navigator.of(context).pop(); // Dismiss the dialog
                } catch (e) {
                  // Handle errors
                }
              },
              child: Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
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
                    "Welcome!",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
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
                height: screenHeight * 0.03,
              ),
              //password text-field
              Textfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: _isObscure,
                Icon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.023),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Text(
                          'Remember Password',
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Column(
                      // Changed from Row to Column for vertical arrangement
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RegisterScreen(), // Ensure you have this screen defined
                              ),
                            );
                          },
                          child: Text(
                            "Register",
                            style: GoogleFonts.roboto(
                                color: Color(0XFF9155FD), fontSize: 13),
                          ),
                        ),
                        SizedBox(
                            height:
                                8), // Space between Register and Forgot Password links
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.roboto(
                                color: Color(0XFF9155FD), fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: screenHeight * 0.1,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: screenHeight * 0.33,
                      width: screenWidth * 0.88,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              Image.asset(
                                "assets/img.png",
                                width: 260,
                                height: 350,
                              ),
                              Positioned(
                                top: 139,
                                right: 35,
                                child: Image.asset("assets/ellipse1.png"),
                              ),
                              Positioned(
                                top: screenHeight * 0.22,
                                right: screenWidth * 0.15,
                                child: SizedBox(
                                  width: screenWidth * 0.164,
                                  height: screenHeight * 0.05,
                                  child: InkWell(
                                    onTap: () {
                                      login(); // This already handles navigation upon successful login
                                    },
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.001,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
