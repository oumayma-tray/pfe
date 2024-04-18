import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/ProjectManagementDetails.dart';
import 'package:mobile_app/project%20management/planing/PlanningDetails.dart';

class ProjectManagementHomePage extends StatefulWidget {
  @override
  _ProjectManagementHomePageState createState() =>
      _ProjectManagementHomePageState();
}

class _ProjectManagementHomePageState extends State<ProjectManagementHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF28243D),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            _buildTopBanner(screenWidth, screenHeight),
            _buildFeatureSection(screenWidth, 'Gestion de Projet',
                Icons.dashboard_customize, ProjectManagementDetails()),
            _buildFeatureSection(screenWidth, 'Planification', Icons.schedule,
                PlanningDetails()),
            _buildStatisticsBanner(screenWidth),
            _buildTestimonialCarousel(screenWidth, screenHeight),
          ],
        ),
      )),
    );
  }

  Widget _buildTopBanner(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/R.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        // Overlay gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7), // Adjust opacity as needed
            ],
          ),
        ),
        // Inner padding for text
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        child: Text(
          'Enhance Your Project Management Skills',
          textAlign: TextAlign.center, // Ensure text is centered
          style: GoogleFonts.roboto(
            fontSize: screenWidth * 0.06, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 2), // Text shadow position
                blurRadius: 3.0,
                color: Color.fromARGB(
                    150, 0, 0, 0), // Text shadow color with some transparency
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureSection(
      double screenWidth, String title, IconData icon, Widget page) {
    return Card(
      margin: EdgeInsets.all(screenWidth * 0.05),
      color: Color(0xFF6D42CE),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, size: screenWidth * 0.1, color: Colors.white),
        title: Text(title,
            style: GoogleFonts.roboto(
                fontSize: screenWidth * 0.05, color: Colors.white)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsBanner(double screenWidth) {
    // Assuming you want to set the font size to 6% of the screen width for the title
    // and 5% of the screen width for the statistics values
    final titleFontSize = screenWidth * 0.06;
    final statsFontSize = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      color: Color(0xFF9155FD),
      child: Column(
        children: [
          Text(
            'Quick Stats',
            style: GoogleFonts.roboto(
                fontSize: titleFontSize, color: Colors.white),
          ),
          SizedBox(height: screenWidth * 0.05), // Space between title and stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: _buildStatistic(
                      '150+', 'Projects Managed', statsFontSize)),
              Expanded(
                  child: _buildStatistic('89%', 'Success Rate', statsFontSize)),
              Expanded(
                  child: _buildStatistic(
                      '30+', 'Certified Trainers', statsFontSize)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String number, String description, double fontSize) {
    return Column(
      children: <Widget>[
        Text(
          number,
          style: GoogleFonts.roboto(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          description,
          style: GoogleFonts.roboto(
            fontSize: fontSize *
                0.8, // 80% of the number font size for the description
            color: Colors.white.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTestimonialCarousel(double screenWidth, double screenHeight) {
    return Container(
      height: screenHeight * 0.2,
      child: PageView(
        children: [
          _buildTestimonial(
              screenWidth,
              "This system helped our team streamline the development process.",
              "- John Doe, CTO"),
          _buildTestimonial(
              screenWidth,
              "I highly recommend this for any project managers looking to improve.",
              "- Jane Smith, Project Manager"),
        ],
      ),
    );
  }

  Widget _buildTestimonial(double screenWidth, String quote, String author) {
    return ListTile(
      title: Text(quote,
          style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
      subtitle: Text(author, style: TextStyle(color: Colors.white70)),
      contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
    );
  }
}
