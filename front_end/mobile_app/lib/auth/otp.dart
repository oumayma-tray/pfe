import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/services/Auth_service/authentificationService.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  OTPScreen({required this.phoneNumber, required this.verificationId});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;

  void verifyOTP() async {
    setState(() {
      isLoading = true;
    });

    try {
      AuthenticationService authService =
          Provider.of<AuthenticationService>(context, listen: false);
      bool isVerified = await authService.verifyOTP(
          widget.verificationId, _otpController.text.trim());

      if (isVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP verification successful')),
        );
        Navigator.of(context).pop(); // Close the OTP screen
        // Optionally, navigate to a different screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification code has been sent to ${widget.phoneNumber}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: verifyOTP,
                    child: Text('Verify OTP'),
                  ),
          ],
        ),
      ),
    );
  }
}
