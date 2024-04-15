import 'package:flutter/material.dart';

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
                  leading: Icon(Icons.security),
                  title: Text('Login Activity'),
                  subtitle: Text('Current login: OneplusNORD 5G 10:30 PM'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  leading: Icon(Icons.lock_outline),
                  title: Text('Change Password'),
                  subtitle: Text('Last updated: 2 months 20 days ago'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  leading: Icon(Icons.phonelink_lock),
                  title: Text('Two-factor authentication'),
                  subtitle: Text('Authentication: Google Authentication (R)'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text('Connected Account'),
                  subtitle: Text('Google\nnevah.simmons@example.com'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  leading: Icon(Icons.data_usage),
                  title: Text('Access Data'),
                  subtitle: Text('Last access: 10 months 1 day ago'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ).toList(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color(0XFF28243D),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedItemColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Category',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Favourite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ));
  }
}
