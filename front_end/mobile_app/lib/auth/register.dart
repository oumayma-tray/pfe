import 'dart:async';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/components/texfieldEye.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/services/Auth_service/authentificationService.dart';
import 'package:mobile_app/homePage.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  File? _userImageFile;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  bool _isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    jobTitleController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> pickUserImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _userImageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> signInWithGoogle() async {
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
    } catch (e) {
      _showErrorDialog(e.toString());
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
          emailController.text.trim(), passwordController.text.trim(),
          name: nameController.text.trim(),
          jobTitle: jobTitleController.text.trim(),
          country: countryController.text.trim(),
          photoPath: _userImageFile?.path);

      // Start a timer to check email verification status
      Timer.periodic(Duration(seconds: 5), (timer) async {
        User? user = FirebaseAuth.instance.currentUser;
        await user!.reload();
        if (user.emailVerified) {
          timer.cancel();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      });

      _showVerificationAwaitDialog();
      setState(() => isLoading = false);
    } catch (e) {
      _showErrorDialog(e.toString());
      setState(() => isLoading = false);
    }
  }

  void _showVerificationAwaitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Verify Your Email'),
        content: Text(
            'A verification email has been sent. Please check your email and click the verification link. Press "CHECK" once you have verified.'),
        actions: <Widget>[
          TextButton(
            child: Text('CHECK'),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              User? user = FirebaseAuth.instance.currentUser;
              await user!.reload();
              if (user.emailVerified) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              } else {
                _showErrorDialog("Please verify your email to proceed.");
              }
            },
          ),
        ],
      ),
    );
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
              onPressed: () => Navigator.of(context).pop()),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_userImageFile != null)
                  Image.file(_userImageFile!, height: 100, width: 100),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: pickUserImage,
                  child: Text('Upload Image',
                      style: TextStyle(color: Colors.white)),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFieldContainer(
                    controller: nameController,
                    hintText: 'Name',
                    icon: Icons.person),
                TextFieldContainer(
                    controller: jobTitleController,
                    hintText: 'Job Title',
                    icon: Icons.work_outline),
                TextFieldContainer(
                    controller: emailController,
                    hintText: 'Email',
                    icon: Icons.email_outlined),
                PhoneNumberTextField(
                  controller:
                      phoneNumberController, // Your TextEditingController instance
                  hintText: 'Phone Number', // Placeholder text
                  obscureText: false, // Text visibility
                  keyboardType:
                      TextInputType.phone, // Keyboard type for phone input
                ),
                TextFieldContainer(
                    controller: countryController,
                    hintText: 'Country',
                    icon: Icons.location_on),
                TextFieldContainer(
                    controller: passwordController,
                    hintText: 'Password',
                    icon: Icons.lock_outline,
                    isObscure: _isObscure),
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
                  onPressed: signInWithGoogle,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/google.png', height: 24),
                      SizedBox(width: 10),
                      Text('Sign in with Google',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isObscure;

  const TextFieldContainer({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isObscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFF6F35A5),
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.white),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
