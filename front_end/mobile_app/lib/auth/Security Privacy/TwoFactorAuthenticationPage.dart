import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/services/Auth_service/authentificationService.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TwoFactorAuthenticationPage extends StatefulWidget {
  @override
  _TwoFactorAuthenticationPageState createState() =>
      _TwoFactorAuthenticationPageState();
}

class _TwoFactorAuthenticationPageState
    extends State<TwoFactorAuthenticationPage> {
  bool isTwoFactorEnabled = false;
  bool isLoading = false;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PhoneNumber _selectedPhoneNumber =
      PhoneNumber(isoCode: 'TN'); // Default to Tunisia
  bool isVerifyButtonEnabled = false;
  String? verificationId;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void promptForPhoneNumber() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Your Phone Number'),
        content: Form(
          key: _formKey,
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              _selectedPhoneNumber = number;
            },
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            initialValue: _selectedPhoneNumber,
            textFieldController: _phoneController,
            formatInput: false,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            inputBorder: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Send OTP'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.of(context).pop();
                sendOTP(_selectedPhoneNumber.phoneNumber!);
              }
            },
          ),
        ],
      ),
    );
  }

  void sendOTP(String phoneNumber) async {
    setState(() => isLoading = true);
    try {
      var authService =
          Provider.of<AuthenticationService>(context, listen: false);
      await authService.phoneAuthentication(phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
        await authService.signInWithCredential(credential);
        enableTwoFactorAuthentication();
      }, verificationFailed: (FirebaseAuthException e) {
        showSnackbar("Verification failed: ${e.message}", isError: true);
      }, codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });
        promptForOTP();
      }, codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      });
      showSnackbar("OTP sent successfully.", isError: false);
    } catch (e) {
      showSnackbar("Verification failed: $e", isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void promptForOTP() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Verification Code'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
                hintText: '123456',
              ),
              onChanged: (value) {
                setState(() {
                  isVerifyButtonEnabled = value.length == 6;
                  if (isVerifyButtonEnabled) {
                    verifyOTP();
                  }
                });
              },
            );
          },
        ),
        actions: [
          TextButton(
            child: Text('Verify'),
            onPressed: isVerifyButtonEnabled ? verifyOTP : null,
          ),
        ],
      ),
    );
  }

  void showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void verifyOTP() async {
    setState(() => isLoading = true);
    try {
      var authService =
          Provider.of<AuthenticationService>(context, listen: false);
      bool isVerified = await authService.verifyOTP(
          verificationId!, _otpController.text.trim());
      if (isVerified) {
        Navigator.of(context).pop(); // Close the OTP dialog
        showSnackbar("Verification successful.", isError: false);
        enableTwoFactorAuthentication(); // Enable 2FA and store in Firebase
      } else {
        showSnackbar("Invalid OTP.", isError: true);
      }
    } catch (e) {
      showSnackbar("Verification failed: $e", isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void enableTwoFactorAuthentication() async {
    setState(() => isLoading = true);
    try {
      var authService =
          Provider.of<AuthenticationService>(context, listen: false);
      bool success = await authService.enableTwoFactorAuthentication();
      if (success) {
        setState(() {
          isTwoFactorEnabled = true;
        });
        showSnackbar('Two-Factor Authentication enabled.', isError: false);
        // Update user's profile or database entry
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'isTwoFactorEnabled': true});
        }
      } else {
        showSnackbar('Failed to enable Two-Factor Authentication',
            isError: true);
      }
    } catch (e) {
      showSnackbar("An error occurred: $e", isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void toggleTwoFactorAuthentication(bool enabled) async {
    if (enabled) {
      promptForPhoneNumber();
    } else {
      var authService =
          Provider.of<AuthenticationService>(context, listen: false);
      bool success = await authService.disableTwoFactorAuthentication();
      if (success) {
        setState(() {
          isTwoFactorEnabled = false;
        });
        showSnackbar('Two-Factor Authentication disabled.', isError: false);
        // Update user's profile or database entry
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'isTwoFactorEnabled': false});
        }
      } else {
        showSnackbar('Failed to disable Two-Factor Authentication',
            isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0XFF28243D),
        appBarTheme: AppBarTheme(
          color: const Color(0XFF28243D),
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Two-Factor Authentication'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Two-Factor Authentication (2FA) adds an extra layer of security to your account. When enabled, logging in will require both your password and a verification code.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 16),
              isLoading
                  ? CircularProgressIndicator()
                  : SwitchListTile(
                      title: const Text(
                        'Enable Two-Factor Authentication',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: isTwoFactorEnabled,
                      onChanged: toggleTwoFactorAuthentication,
                      activeColor: Colors.green,
                    ),
              Divider(color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
