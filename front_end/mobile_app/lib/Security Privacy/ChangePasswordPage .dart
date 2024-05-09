import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/auth/authentificationService.dart';

class ChangePasswordPage extends StatelessWidget {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<AuthenticationService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: Icon(Icons.visibility_off),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: Icon(Icons.visibility_off),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: Icon(Icons.visibility_off),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_newPasswordController.text ==
                        _confirmPasswordController.text) {
                      try {
                        await authService.changePassword(
                            _currentPasswordController.text,
                            _newPasswordController.text);
                        // Show a success message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Password changed successfully!')));
                      } catch (e) {
                        // Handle errors, e.g., wrong current password
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Failed to change password: ${e.toString()}')));
                      }
                    } else {
                      // Handle error when passwords don't match
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'New password and confirm password do not match!')));
                    }
                  },
                  child: Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
