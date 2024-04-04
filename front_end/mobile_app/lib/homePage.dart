import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:mobile_app/Project%20Management/employee_tile.dart';
//import 'package:mobile_app/calendar/calendarHome.dart';
//import 'package:mobile_app/chat/chatHomePage.dart';
//import 'package:mobile_app/mail/mailHomePage.dart';
//import 'package:mobile_app/Project Management/Employees.dart';

//List<Employee> employees = getMockEmployees();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              Positioned.fill(
                  child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/Group2.png",
                  fit: BoxFit.cover,
                ),
              )),
              Positioned(
                right: 65,
                top: 150,
                child: Image.asset(
                  "assets/image 1.png",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 370,
                right: 50,
                child: Text('Hello, Jonnathan Petterson',
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
              Positioned(
                bottom: 330,
                right: 30,
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
                              'Anywhere St., Any City123 ',
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
                bottom: 280,
                right: 110,
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
                        // Your button action goes here
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
                  right: 20,
                  bottom: 230,
                  child: Image.asset("assets/menu.png")),
              Positioned(
                left: 20,
                bottom: 230,
                child: Text(
                  "Apps & Pages",
                  style: GoogleFonts.roboto(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 140,
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(145, 85, 253, 0.5),
                              Color.fromRGBO(197, 165, 254, 0.5)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            // Add the navigation to MailHomePage here
                            //Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //builder: (context) => MailHomePage(),
                            //),
                            // );
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: EdgeInsets.all(2),
                            child: Image.asset(
                              "assets/email.png",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 2), // Space between the button and the text
                    Text(
                      "Dynamic Email",
                      style: GoogleFonts.roboto(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 100,
                  bottom: 140,
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(145, 85, 253, 0.5),
                                Color.fromRGBO(197, 165, 254, 0.5)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              //Navigator.push(
                              //context,
                              //MaterialPageRoute(
                              //builder: (context) => CalendarHome(),
                              //),
                              //);
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              padding: EdgeInsets.all(2),
                              child: Image.asset(
                                "assets/calendar.png",
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2), // Espace entre le bouton et le texte
                      Text(
                        "Smart Calendar",
                        style: GoogleFonts.roboto(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  )),
              Positioned(
                right: 100,
                bottom: 140,
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(145, 85, 253, 0.5),
                              Color.fromRGBO(197, 165, 254, 0.5)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            //Navigator.push(
                            // context,
                            //MaterialPageRoute(
                            //builder: (context) =>
                            //  EmployeeDirectoryPage(), // You need to pass the actual 'employee' object you want to display.
//),
                            // );
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: EdgeInsets.all(2),
                            child: Image.asset(
                              "assets/management.png",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2), // Espace entre le bouton et le texte
                    Text(
                      "Project Management",
                      style: GoogleFonts.roboto(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 15,
                bottom: 140,
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(145, 85, 253, 0.5),
                              Color.fromRGBO(197, 165, 254, 0.5)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {},
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: EdgeInsets.all(2),
                            child: Image.asset(
                              "assets/recruit.png",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2), // Espace entre le bouton et le texte
                    Text(
                      "Smart Recruitment",
                      style: GoogleFonts.roboto(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 15,
                bottom: 50,
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(145, 85, 253, 0.5),
                              Color.fromRGBO(197, 165, 254, 0.5)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {},
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: EdgeInsets.all(2),
                            child: Image.asset(
                              "assets/invoice.png",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2), // Espace entre le bouton et le texte
                    Text(
                      "Smart Invoice",
                      style: GoogleFonts.roboto(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 100,
                bottom: 50,
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(145, 85, 253, 0.5),
                              Color.fromRGBO(197, 165, 254, 0.5)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {},
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: EdgeInsets.all(2),
                            child: Image.asset(
                              "assets/payroll.png",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2), // Espace entre le bouton et le texte
                    Text(
                      "Smart Payroll",
                      style: GoogleFonts.roboto(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              Positioned(
                  right: 115,
                  bottom: 50,
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(145, 85, 253, 0.5),
                                Color.fromRGBO(197, 165, 254, 0.5)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {},
                            child: Container(
                              width: 60,
                              height: 60,
                              padding: EdgeInsets.all(2),
                              child: Image.asset(
                                "assets/leave.png",
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2), // Espace entre le bouton et le texte
                      Text(
                        "Smart Leave",
                        style: GoogleFonts.roboto(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  )),
              Positioned(
                right: 25,
                bottom: 50,
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(145, 85, 253, 0.5),
                              Color.fromRGBO(197, 165, 254, 0.5)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            // Add the navigation to MailHomePage here
                            // Navigator.push(
                            //context,
                            // MaterialPageRoute(
                            //  builder: (context) => Chat(),
                            // ),
                            //);
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: EdgeInsets.all(2),
                            child: Image.asset(
                              "assets/all.png",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2), // Espace entre le bouton et le texte
                    Text(
                      "Chat",
                      style: GoogleFonts.roboto(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
