import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldEye extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const TextFieldEye({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  _TextFieldEyeState createState() => _TextFieldEyeState();
}

class _TextFieldEyeState extends State<TextFieldEye> {
  bool isobscure = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      height: screenHeight * 0.062,
      width: screenWidth * 0.778,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(145, 85, 253, 0.5),
            Color.fromRGBO(197, 165, 254, 0.5),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: widget.controller,
            obscureText: isobscure,
            style: GoogleFonts.roboto(),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              suffixIcon: IconButton(
                icon: isobscure
                    ? Icon(Icons.visibility_off,
                     color: Colors.white,
                     size: 20.0,)
                    : Icon(Icons.visibility,
                     color: Colors.white,
                     size: 20.0,),
                     
                onPressed: togglePasswordVisibility,
              ),
              hintStyle: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                
              ),
               contentPadding: EdgeInsets.symmetric(vertical: 2.0 , horizontal: 8.0),
              
            ),
          ),
              
          
        ),
      ),
    );
     
  }

  void togglePasswordVisibility() {
    setState(() {
      isobscure = !isobscure;
    });
  }
}
