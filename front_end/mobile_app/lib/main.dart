import 'package:flutter/material.dart';
import 'package:mobile_app/auth/Reset Password.dart';
import 'package:mobile_app/auth/forgotPassword.dart';
import 'package:mobile_app/auth/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smartovate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(
              onTap: () {},
            ), // Set LoginPage as the initial route
        '/forgot_password': (context) => ForgotPassword(
              onTap: () {},
            ),
        '/reset_password': (context) => ResetPassword(
              onTap: () {},
            ),
      },
    );
  }
}
