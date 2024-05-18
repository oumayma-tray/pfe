import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/auth/login.dart';

import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/Employee%20Management/employee_tile.dart';
import 'package:mobile_app/auth/Security%20Privacy/SecurityPrivacyPage.dart';
import 'package:mobile_app/services/Auth_service/authentificationService.dart';
import 'package:mobile_app/calendar/calendarHome.dart';
import 'package:mobile_app/chat/chatHomePage.dart';
import 'package:mobile_app/mail/mailHomePage.dart';
import 'package:mobile_app/Employee%20Management/Employees.dart';
import 'package:mobile_app/project%20management/ProjectManagementHomePage.dart';

List<Employee> employees = getMockEmployees();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSwitched = false;

  String employeeImageUrl = "assets/image 1.png";
  String name = 'tray oumayma';
  String address = 'Anywhere St., Any City123';
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // Define padding dynamically
    EdgeInsets screenPadding = EdgeInsets.only(
      top: screenHeight * 0.02, // 2% of the screen height for top padding
      right: screenWidth * 0.05,
      // 5% of the screen width for right padding
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFF28243D),
        body: Center(
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            children: <Widget>[
              Positioned(
                  child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset("assets/Group2.png",
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: screenHeight * 0.5),
              )),
              Positioned(
                top: screenHeight * 0.2,
                right: 70,
                child: Center(
                  child: CircleAvatar(
                    radius:
                        screenWidth * 0.35, //Adjust the size to fit your layout
                    backgroundImage: AssetImage(employeeImageUrl),
                    backgroundColor: Colors.transparent,
                    onBackgroundImageError: (exception, stackTrace) {
                      // Handle the error of image loading if needed
                    },
                    // You might want to show a placeholder if the image takes time to load or fails to load
                    child: employeeImageUrl.isEmpty
                        ? Icon(
                            Icons.account_circle,
                            size:
                                80, // Adjust the size to fit the circle avatar
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.54, // 50% from the top
                right: screenWidth * 0.2,
                child: Text('Hello, $name',
                    style: GoogleFonts.roboto(
                        fontSize: screenHeight * 0.03,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
              Positioned(
                bottom: screenHeight *
                    0.30, // Adjust this value based on your layout needs
                right: 110, // Right alignment padding
                child: // This button is part of your HomePage widget
                    Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(145, 85, 253, 1),
                        Color.fromRGBO(197, 165, 254, 1)
                      ]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Logout'),
                              content: Text('Are you sure you want to logout?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: Text('Logout'),
                                  onPressed: () async {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm) {
                          // Sign out the user
                          await Provider.of<AuthenticationService>(context,
                                  listen: false)
                              .signOut();

                          // Navigate to the login page
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        }
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.power_settings_new, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.25, // Adjust the position as needed
                right: 0.1, // Adjust for layout
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: isSwitched,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isSwitched = value;
                                    });
                                  },
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey[400],
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    20), // Space between Switch and Security
                            // Security and Privacy Button
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SecurityPrivacyPage()),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.security,
                                      color: Colors.white, size: 24),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: screenHeight * 0.22,
                child: Text(
                  "Apps & Pages",
                  style: GoogleFonts.roboto(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Positioned(
                top: screenHeight *
                    0.75, // Adjust this value so it is below the "Apps & Pages" text
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // App Tiles in individual Rows
                      appRow(context, 'Dynamic Email', Icons.email, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MailHomePage()),
                        );
                      }),
                      SizedBox(height: 5),
                      appRow(context, 'Smart Calendar', Icons.calendar_month,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarHome()),
                        );
                      }),
                      SizedBox(height: 5),
                      appRow(context, 'Employee Management',
                          Icons.manage_accounts_outlined, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeeDirectoryPage()),
                        );
                      }),
                      SizedBox(height: 5),
                      appRow(context, 'Smart Project management',
                          Icons.recent_actors_outlined, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProjectManagementHomePage()),
                        );
                      }),
                      SizedBox(height: 5),
                      appRow(context, 'Chat', Icons.chat, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Chat()));
                      }),
                      // ... Add more app rows as needed
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appRow(BuildContext context, String title, IconData iconData,
      VoidCallback onTap) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: screenWidth * 0.1,
        ), // Vertical padding added, horizontal padding adjusted
        decoration: BoxDecoration(
          color: Color(0xff9155FD), // Set the background color of the container
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Icon(
              iconData, // Use the IconData passed to the function
              size: screenHeight * 0.04, color: Colors.white,
            ),
            Expanded(
              // Ensure the text does not overflow
              child: Text(
                title,
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: screenHeight * 0.025),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appTile(BuildContext context, String title, String assetName,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Take the full width of the container
        padding:
            EdgeInsets.symmetric(vertical: 10.0), // Adjust padding as needed
        decoration: BoxDecoration(
          color: Color(0xff9155FD),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the children vertically
          children: [
            Image.asset(
              assetName,
              width: 80, // Increase the width for a larger icon
              height: 80, // Increase the height for a larger icon
              fit: BoxFit.contain,
            ),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
