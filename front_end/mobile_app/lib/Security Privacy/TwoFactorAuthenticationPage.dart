import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/auth/authentificationService.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String _verificationId = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PhoneNumber _selectedPhoneNumber =
      PhoneNumber(isoCode: 'TN'); // Default to Tunisia

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
                sendOTP(_selectedPhoneNumber
                    .phoneNumber!); // Ensure you send the formatted number
              }
            },
          ),
        ],
      ),
    );
  }

  void sendOTP(String phoneNumber) async {
    setState(() =>
        isLoading = true); // Starting loading indicator before the operation
    try {
      var authService =
          Provider.of<AuthenticationService>(context, listen: false);
      await authService.phoneAuthentication(phoneNumber).then((_) {
        // Assuming phoneAuthentication now returns a Future and handles all internals
        if (!mounted) return;
        setState(() => isLoading = false);
      }).catchError((e) {
        // Error handling inside catchError which is a common pattern in Flutter for Future errors
        if (!mounted) return;
        setState(() => isLoading = false);
        if (e is FirebaseAuthException) {
          showSnackbar(
              "Verification failed: ${e.message}"); // Specific handling for FirebaseAuth errors
        } else {
          showSnackbar("An unexpected error occurred: ${e.toString()}");
        }
      });
    } catch (e) {
      // Catch any other non-Firebase related errors that might have occurred
      if (!mounted) return;
      setState(() => isLoading = false);
      showSnackbar("An unexpected error occurred: ${e.toString()}");
    }
  }

  void promptForOTP() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // The user must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Verification Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller:
                    _otpController, // This controller holds the inputted OTP
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: '123456',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Verify'),
              onPressed: () {
                verifyOTP(); // Verify the OTP
              },
            ),
          ],
        );
      },
    );
  }

  void verifyOTP() async {
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    setState(() {
      isLoading = true; // Indicate loading while the verification is processed
    });
    try {
      bool isVerified =
          await authService.verifyOTP(_verificationId, _otpController.text);
      if (!mounted) return; // Check if the widget is still in the tree
      setState(() {
        isLoading = false; // Stop loading indication
      });
      Navigator.of(context).pop(); // Close the OTP dialog
      if (isVerified) {
        showSnackbar("Verification successful.");
        // Optionally update your UI or state here, like navigating to a secured page or updating user status
      } else {
        showSnackbar("Verification failed. Please try again.", isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading =
            false; // Ensure loading state is updated even if an error occurs
      });
      showSnackbar("An error occurred during verification: ${e.toString()}",
          isError: true);
    }
  }

  void showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void handleAutoRetrievalTimeout(String verificationId) {
    // Update the UI to allow manual input of the OTP
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('OTP Timeout'),
        content: Text(
            'We could not automatically detect the OTP. Please enter it manually.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void toggleTwoFactorAuthentication(bool enabled) async {
    if (enabled) {
      // User is trying to enable 2FA
      promptForPhoneNumber(); // This will handle the entire flow of enabling 2FA
    } else {
      // User is trying to disable 2FA
      var authService =
          Provider.of<AuthenticationService>(context, listen: false);
      bool success = await authService.disableTwoFactorAuthentication();
      if (success) {
        setState(() {
          isTwoFactorEnabled = false;
        });
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
        ));
  }
}
