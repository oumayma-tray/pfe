import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/Project%20Management/employee_tile.dart';
import 'package:mobile_app/calendar/calendarHome.dart';
import 'package:mobile_app/chat/chatHomePage.dart';
import 'package:mobile_app/mail/mailHomePage.dart';
import 'package:mobile_app/Project Management/Employees.dart';
import 'package:mobile_app/Project%20Management/EmployeeDetails.dart';

List<Employee> employees = getMockEmployees();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String employeeImageUrl = "assets/image 1.png";
  String name = 'tray oumayma';
  String address = 'Anywhere St., Any City123';
  @override
  Widget build(BuildContext context) {
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
                child: Image.asset(
                  "assets/Group2.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
              )),
              Positioned(
                top: 140,
                right: 100,
                child: Center(
                  child: CircleAvatar(
                    radius: 110, // Adjust the size to fit your layout
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
                                120, // Adjust the size to fit the circle avatar
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
              ),
              Positioned(
                top: 360,
                right: 100,
                child: Text('Hello, $name',
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
              Positioned(
                bottom: 230,
                right: 70,
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(145, 85, 253, 1),
                          Color.fromRGBO(197, 165, 254, 1)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 0.8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_sharp,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '$address',
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
                bottom: 180,
                right: 150,
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(145, 85, 253, 1),
                          Color.fromRGBO(197, 165, 254, 1)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        // Assuming the login page is the previous one in the stack
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/power.png",
                            ),
                            SizedBox(width: 6),
                            Text(
                              ' logout ',
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
                left: 20,
                bottom: 140,
                child: Text(
                  "Apps & Pages",
                  style: GoogleFonts.roboto(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Positioned(
                top:
                    520, // Adjust this value so it is below the "Apps & Pages" text
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
                      appRow(context, 'Project Management',
                          Icons.manage_accounts_outlined, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeeDirectoryPage()),
                        );
                      }),
                      SizedBox(height: 5),
                      appRow(context, 'Smart Recruitment',
                          Icons.recent_actors_outlined, () {
                        // Add navigation to Smart Recruitment page
                      }),
                      SizedBox(height: 5),
                      appRow(context, 'Chat', Icons.chat, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Chat()),
                        );
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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal:
                100), // Vertical padding added, horizontal padding adjusted
        decoration: BoxDecoration(
          color: Color(0xff9155FD), // Set the background color of the container
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Icon(
              iconData, // Use the IconData passed to the function
              size: 30, // Set a larger size for the icon
              color: Colors.white,
            ),
            Expanded(
              // Ensure the text does not overflow
              child: Text(
                title,
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
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
