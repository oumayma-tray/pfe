import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanningDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planning', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFF6D42CE),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/planning_detail.webp', fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Effective planning is crucial for the success of any project. Learn how to create detailed project plans, set realistic timelines, and ensure that all stakeholders are aligned.',
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.black),
              ),
            ),
            ListTile(
              title: Text('Timeline Development',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.black)),
              subtitle: Text(
                  'Create accurate and achievable timelines for all project phases.',
                  style: GoogleFonts.roboto(color: Colors.black)),
              leading: Icon(Icons.timeline, color: Colors.purple[200]),
            ),
            ListTile(
              title: Text('Stakeholder Management',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.black)),
              subtitle: Text(
                  'Strategies to engage and manage stakeholders throughout the project.',
                  style: GoogleFonts.roboto(color: Colors.black)),
              leading: Icon(Icons.people_alt, color: Colors.orange[200]),
            ),
            ListTile(
              title: Text('Budgeting',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.black)),
              subtitle: Text(
                  'Effective budget management to keep the project within financial constraints.',
                  style: GoogleFonts.roboto(color: Colors.black)),
              leading: Icon(Icons.attach_money, color: Colors.green[200]),
            ),
          ],
        ),
      ),
    );
  }
}
