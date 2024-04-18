import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectManagementDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Project Management', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D42CE),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/project_management_detail.png',
                fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Explore advanced project management tools and techniques to effectively manage your projects. Learn about agile methodologies, scrum practices, and how to handle complex project challenges.',
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
              ),
            ),
            ListTile(
              title: Text('Agile Project Management',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.white)),
              subtitle: Text(
                  'Understand the principles of agile management and how to apply them.',
                  style: GoogleFonts.roboto(color: Colors.white70)),
              leading:
                  Icon(Icons.check_circle_outline, color: Colors.green[200]),
            ),
            ListTile(
              title: Text('Risk Management',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.white)),
              subtitle: Text(
                  'Learn techniques to identify and mitigate risks in your projects.',
                  style: GoogleFonts.roboto(color: Colors.white70)),
              leading: Icon(Icons.abc, color: Colors.red[200]),
            ),
            ListTile(
              title: Text('Resource Allocation',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.white)),
              subtitle: Text(
                  'Maximize efficiency by effectively allocating resources.',
                  style: GoogleFonts.roboto(color: Colors.white70)),
              leading: Icon(Icons.group_work, color: Colors.blue[200]),
            ),
          ],
        ),
      ),
    );
  }
}
