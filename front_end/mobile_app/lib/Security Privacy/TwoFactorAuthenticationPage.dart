import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class TwoFactorAuthenticationPage extends StatefulWidget {
  @override
  _TwoFactorAuthenticationPageState createState() =>
      _TwoFactorAuthenticationPageState();
}

class _TwoFactorAuthenticationPageState
    extends State<TwoFactorAuthenticationPage> {
  late VideoPlayerController _controller;
  bool isTwoFactorEnabled = false;
  String verificationCode = '';
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://smartovate.io/fr',
    )..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        showSnackbar("Failed to load video", isError: true);
        print("Video Player Error: $error");
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _toggleTwoFactorAuthentication(bool enabled) {
    setState(() {
      isTwoFactorEnabled = enabled;
    });
    if (enabled) {
      // Here you would typically trigger the backend to send a verification code
      // For demonstration, we'll show an AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Verify Your Identity'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter the verification code sent to your device.'),
                TextField(
                  onChanged: (value) => verificationCode = value,
                  decoration: InputDecoration(
                    labelText: 'Verification Code',
                    prefixIcon: Icon(Icons.security),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Here, you would handle the verification logic
                  Navigator.of(context).pop();
                },
                child: Text('Verify'),
              ),
            ],
          );
        },
      );
    } else {
      // Disable 2FA in your backend
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
        backgroundColor: const Color(0XFF28243D),
      ),
      backgroundColor: const Color(0XFF28243D),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Two-Factor Authentication (2FA) adds an extra layer of security to your account. When enabled, logging in will require both your password and a verification code from your mobile device.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text(
                'Enable Two-Factor Authentication',
                style: TextStyle(color: Colors.white),
              ),
              value: isTwoFactorEnabled,
              onChanged: _toggleTwoFactorAuthentication,
              activeColor: Colors.green,
            ),
            if (isTwoFactorEnabled)
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Set up your two-factor authentication by following the steps below:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            if (isTwoFactorEnabled)
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.white),
                title: const Text(
                  '1. Install a 2FA app on your device.',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Such as Google Authenticator, Authy, or Microsoft Authenticator.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            if (isTwoFactorEnabled)
              ListTile(
                leading: const Icon(Icons.qr_code_scanner, color: Colors.white),
                title: const Text(
                  '2. Scan the QR code or enter setup key.',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'We will provide you with a QR code to scan with the 2FA app.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            if (isTwoFactorEnabled)
              ListTile(
                leading: const Icon(Icons.lock_clock, color: Colors.white),
                title: const Text(
                  '3. Enter the verification code generated by the app.',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'This code verifies that 2FA is set up correctly.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            // It is a good practice to provide help or support links.
            const Divider(color: Colors.white54),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.white),
              title: const Text(
                'Need help?',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                final email = 'SmartovateHelp@gmail.com';
                final subject = Uri.encodeComponent(
                    'Need Help with Two-Factor Authentication');
                final url = 'mailto:$email?subject=$subject';
                try {
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No email apps available.'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to send email: $e'),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library, color: Colors.white),
              title: const Text(
                'Watch a setup tutorial',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                const url =
                    'https://www.yoursite.com/tutorial'; // URL of your tutorial video
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not launch the tutorial.'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
