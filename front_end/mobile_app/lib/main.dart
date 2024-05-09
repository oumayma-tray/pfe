import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/auth/Reset Password.dart';
import 'package:mobile_app/auth/authentificationService.dart';
import 'package:mobile_app/auth/forgotPassword.dart';
import 'package:mobile_app/auth/login.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyAur9eYzldF-G3Oc9s7BUxG4KK1Qc-Av-o",
    appId: "1:623372766400:android:b38d3e49edbce3e1967125",
    messagingSenderId: "623372766400",
    projectId: "authapp-ec7af",
  );
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthenticationService>(
      create: (_) => AuthenticationService(FirebaseAuth.instance),
      child: MyApp(),
    );
  }
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
        '/': (context) => LoginScreen(), // Home page or initial route
        '/login': (context) => LoginScreen(), // Login route
        '/forgot_password': (context) => ForgotPassword(),
        '/reset_password': (context) => ResetPassword(),
        // Define other routes as needed
      },
    );
  }
}
