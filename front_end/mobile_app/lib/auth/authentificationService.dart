import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AuthenticationService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore; // Declare the FirebaseFirestore instance.

  AuthenticationService(this._firebaseAuth)
      : _firestore = FirebaseFirestore.instance;
  void handleAuthException(FirebaseAuthException e) {
    String message = 'Authentication failed: ${e.message}';
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided for that user.';
        break;
      case 'too-many-requests':
        message = 'Too many requests. Please try again later.';
        break;
      case 'invalid-email':
        message = 'The email address is badly formatted.';
        break;
    }
    Get.snackbar('Authentication Error', message);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.');
      return false;
    }

    if (!EmailValidator.validate(email)) {
      Get.snackbar('Error', 'Your email address is malformed.');
      return false;
    }

    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        // Proceed to the home page or next step
        return true;
      } else {
        // If email is not verified, consider this as needing further verification
        await sendVerificationCode(userCredential.user!);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      handleAuthException(e);
      return false;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

// Method to register with email and password
  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Optionally handle the error better or simply rethrow it
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> enableTwoFactorAuthentication() async {
    try {
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .set({
        'twoFactorEnabled': true,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error enabling 2FA: $e');
      return false;
    }
  }

  Future<bool> disableTwoFactorAuthentication() async {
    try {
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .set({
        'twoFactorEnabled': false,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error disabling 2FA: $e');
      return false;
    }
  }

  Future<bool> checkTwoFactorEnabled() async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      Map<String, dynamic> data =
          userDoc.data() as Map<String, dynamic>; // Safely cast to a Map
      return data['twoFactorEnabled'] ??
          false; // Now you can safely use the index operator
    } catch (e) {
      print('Failed to fetch 2FA status: $e');
      return false;
    }
  }

  Future<bool> isTwoFactorEnabled() async {
    // Example of fetching 2FA status from Firestore
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      return userDoc.data()?['twoFactorEnabled'] ?? false;
    } catch (e) {
      print('Error checking 2FA status: $e');
      return false;
    }
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic handling of the code
        await _firebaseAuth.signInWithCredential(credential);
        // Optionally, handle a successful sign in
      },
      codeSent: (String verificationId, int? resendToken) {
        // This function is called after sending the OTP
        Get.find<AuthController>().updateVerificationId(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout handling
        Get.find<AuthController>().updateVerificationId(verificationId);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle various errors
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('Error', 'The provided phone number is not valid.');
        } else {
          Get.snackbar('Error', 'Something went wrong. Try again.');
        }
      },
    );
  }

  // This function verifies the OTP entered by the user
  Future<bool> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _firebaseAuth.currentUser?.linkWithCredential(credential);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify OTP: ${e.toString()}');
      return false;
    }
  }

  Future<void> sendVerificationCode(User user) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: user.phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await user.linkWithCredential(credential);
        Get.snackbar('Success', 'Verification completed automatically');
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Verification Failed', e.message!);
      },
      codeSent: (String verificationId, int? resendToken) {
        // This would typically trigger a new screen where the user can enter the OTP
        Get.to(() => OTPScreen(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout, possibly resend code or prompt user again
      },
    );
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      User? user = _firebaseAuth.currentUser;
      // Re-authenticate the user
      AuthCredential credentials = EmailAuthProvider.credential(
          email: user!.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credentials);

      // If re-authentication is successful, proceed to update the password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      // Handle different Firebase auth exceptions
      throw Exception(e.message);
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true; // Email is valid and reset email sent
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          // Email is not valid
          return false;
        case 'invalid-email':
          // Handle invalid email format
          throw FirebaseAuthException(
            code: e.code,
            message:
                "The email address is badly formatted. Please enter a valid email address.",
          );
        default:
          // Rethrow the exception to be handled elsewhere or show a generic error
          rethrow;
      }
    }
  }

  // Optional: Method to update password (used in reset password functionality)
  Future<void> updatePassword(String newPassword) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
      } on FirebaseAuthException catch (e) {
        throw FirebaseAuthException(code: e.code, message: e.message);
      }
    } else {
      throw Exception('No user logged in.');
    }
  }

  verifyCode(String trim) {}
}

class AuthController extends GetxController {
  String? verificationId;

  void updateVerificationId(String newVerificationId) {
    verificationId = newVerificationId;
    update();
  }
}

// OTP Screen Class (simplified version)
class OTPScreen extends StatelessWidget {
  final String verificationId;

  OTPScreen({required this.verificationId});

  @override
  Widget build(BuildContext context) {
    TextEditingController otpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Column(
        children: [
          TextField(
            controller: otpController,
            decoration: InputDecoration(labelText: 'OTP'),
          ),
          ElevatedButton(
            onPressed: () {
              final authService =
                  Provider.of<AuthenticationService>(context, listen: false);
              authService.verifyOTP(verificationId, otpController.text.trim());
            },
            child: Text('Verify OTP'),
          ),
        ],
      ),
    );
  }
}
