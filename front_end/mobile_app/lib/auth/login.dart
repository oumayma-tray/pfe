import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/auth/forgotPassword.dart';
import 'package:mobile_app/components/textfield.dart';
//import 'package:mobile_app/homePage.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
//login  method
  void Login() async {
    //show loading cercle
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false, //remove the overflow
        backgroundColor: Color(0XFF28243D),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.032,
              ), //khater hasb design logo b3id al top 23.2 w a7na aana screen height 722 donc 23.2/722= 0.032
              Image.asset("assets/Group.png"),

              SizedBox(
                height: screenHeight * 0.097,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome!",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  //mail text-field
                  Textfield(
                    controller: emailController,
                    hintText: 'Email',
                    Icon: Icon(Icons.email_outlined, color: Colors.white),
                    obscureText: false,
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              //password text-field
              Textfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                Icon: Icon(Icons.lock_outline, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.023),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Text(
                          'Remember Password',
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ForgotPassword(onTap: widget.onTap),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.roboto(
                            color: Color(0XFF9155FD), fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: screenHeight * 0.33,
                      width: screenWidth * 0.88,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              Image.asset(
                                "assets/img.png",
                                width: 260,
                                height: 350,
                              ),
                              Positioned(
                                top: 139,
                                right: 35,
                                child: Image.asset("assets/ellipse1.png"),
                              ),
                              Positioned(
                                top: screenHeight * 0.22,
                                right: screenWidth * 0.15,
                                child: SizedBox(
                                  width: screenWidth * 0.164,
                                  height: screenHeight * 0.05,
                                  child: InkWell(
                                    onTap: () {
                                      Login();
                                      //Navigator.push(
                                      /// context,
                                      // MaterialPageRoute(
                                      //builder: (context) => HomePage(),
                                      // ),
                                      // );
                                    },
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.001,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginService {
  static Future<void> fetchData() async {
    try {
      final response = await http
          .get('https://dev.app.smartovate.com/authentication' as Uri);

      if (response.statusCode == 200) {
        // Traitement des données de réponse
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);

        // Mettez à jour votre interface utilisateur avec les données
        // ...
      } else {
        // Gestion des erreurs
        print('Erreur de requête : ${response.statusCode}');
      }
    } catch (error) {
      // Gestion des erreurs lors de la requête
      print('Erreur lors de la requête : $error');
    }
  }
}
