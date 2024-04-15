import 'package:flutter/material.dart';
import 'package:mobile_app/Security%20Privacy/ChangePasswordPage%20.dart';
import 'package:mobile_app/Security%20Privacy/TwoFactorAuthenticationPage.dart';

class SecurityPrivacyPage extends StatelessWidget {
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
        // Other theme overrides if necessary
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Security & Privacy'),
          elevation: 0,
        ),
        backgroundColor: Color(0XFF28243D),
        body: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change Password'),
                subtitle: const Text('Last updated: 2 months 20 days ago'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.phonelink_lock),
                title: const Text('Two-factor authentication'),
                subtitle:
                    const Text('Authentication: Google Authentication (R)'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => TwoFactorAuthenticationPage()),
                  );
                },
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }
}
