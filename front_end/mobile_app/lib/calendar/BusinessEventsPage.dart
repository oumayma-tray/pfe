import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/calendar/listEvent.dart'; // Ensure this path is correct

class BusinessEventsPage extends StatelessWidget {
  const BusinessEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Eventt> businessEvents = eventList
        .getEvents()
        .where((event) => event.type == EventType.Business)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Business Events",
            style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: businessEvents.length,
        itemBuilder: (context, index) {
          final event = businessEvents[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Text(
                  event.type.toString().split('.').last[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(event.title,
                  style: GoogleFonts.roboto(
                      fontSize: 18, fontWeight: FontWeight.w500)),
              subtitle: Text(
                "${event.description} - ${event.date.day}/${event.date.month}/${event.date.year}",
                style: GoogleFonts.roboto(fontSize: 14),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: () {
                  // Add your code to handle event editing
                },
              ),
              onTap: () {
                // Add actions or navigation for event details
              },
            ),
          );
        },
      ),
    );
  }
}
