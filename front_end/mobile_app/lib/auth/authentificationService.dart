import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  // Method to sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Optionally handle the error better or simply rethrow it
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true; // Email is valid and reset email sent
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Email is not valid
        return false;
      } else if (e.code == 'invalid-email') {
        // Handle invalid email format
        throw FirebaseAuthException(
          code: e.code,
          message:
              "The email address is badly formatted. Please enter a valid email address.",
        );
      } else {
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
}
