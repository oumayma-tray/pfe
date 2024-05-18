import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/auth/forgotPassword.dart';
import 'package:mobile_app/auth/otp.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/auth/ForgotandResetPassword.dart';
import 'package:mobile_app/auth/register.dart';
import 'package:mobile_app/components/textfield.dart';
import 'package:mobile_app/homePage.dart';
import 'package:mobile_app/services/Auth_service/authentificationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;
  bool isOTPEnabled = false;
  String? _verificationId;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData['isTwoFactorEnabled'] == true) {
          _showPhoneNumberInput(userData['phoneNumber']);
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      } else {
        _showErrorDialog('Failed to login. Check credentials.');
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'Failed to login. Check credentials.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendOTP(String phoneNumber) async {
    setState(() {
      _isLoading = true;
    });

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        _showErrorDialog('Failed to send OTP.');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OTPScreen(
            phoneNumber: phoneNumber,
            verificationId: verificationId,
          ),
        ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _showPhoneNumberInput(String phoneNumber) {
    _sendOTP(phoneNumber);
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
                Navigator.of(context).pop();
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
                    "Welcome!",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Textfield(
                    controller: emailController,
                    hintText: 'Email',
                    icon: Icon(Icons.email_outlined, color: Colors.white),
                    obscureText: false,
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              Textfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: _isObscure,
                icon: IconButton(
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Register",
                            style: GoogleFonts.roboto(
                                color: Color(0XFF9155FD), fontSize: 13),
                          ),
                        ),
                        SizedBox(height: 8),
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
              SizedBox(height: screenHeight * 0.1),
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
                                      if (isOTPEnabled) {
                                        _showPhoneNumberInput('');
                                      } else {
                                        _login();
                                      }
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
