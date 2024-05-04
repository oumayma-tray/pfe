import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/auth/forgotPassword.dart';
import 'package:mobile_app/components/textfield.dart';
import 'package:mobile_app/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isObscure = true; // For password visibility toggle
  bool _isLoading = false; // To handle loading state

  // Form validation
  bool get _isFormValid {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  Future<void> login() async {
    if (!_isFormValid) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'An unexpected error occurred.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _safePop() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _showErrorDialog(String message) {
    _safePop(); // Safe pop if any dialog is open

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(), // Dismiss the dialog
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void logout() {
    // Clear the text fields
    emailController.clear();
    passwordController.clear();

    // Navigate the user back to the login screen or another appropriate screen
    Navigator.pushReplacementNamed(
        context, '/login'); // Adjust according to your navigation setup
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                obscureText: true,
                Icon: Icon(Icons.lock_outline, color: Colors.white),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ForgotPassword(onTap: widget.onTap),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.roboto(
                            color: Color(0XFF9155FD), fontSize: 13),
                      ),
                    )
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
