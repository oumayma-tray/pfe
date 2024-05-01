import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/calendar/listEvent.dart'; // Adjust this import path as necessary.

class FamilyEventsPage extends StatelessWidget {
  const FamilyEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filtering the events for only those that are of type 'Family'
    List<Eventt> familyEvents = eventList
        .getEvents()
        .where((event) => event.type == EventType.Family)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Family Events",
            style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple, // Custom color for the AppBar
      ),
      body: ListView.builder(
        itemCount: familyEvents.length,
        itemBuilder: (context, index) {
          final event = familyEvents[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Text(
                  event.type
                      .toString()
                      .split('.')
                      .last[0], // First letter of 'Family'
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
                  // Implement functionality to edit the event
                },
              ),
              onTap: () {
                // Optionally, add an action or navigation on tap
              },
            ),
          );
        },
      ),
    );
  }
}
