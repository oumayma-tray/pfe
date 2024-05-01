import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure this package is included in your pubspec.yaml
import 'package:mobile_app/calendar/listEvent.dart'; // Adjust path as necessary

class EventDisplayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // As before, ensure the event list is populated elsewhere in your app logic
    addSampleEvents(); // This should ideally be done once in a stateful widget or an initialization method

    return Scaffold(
      appBar: AppBar(
        title: Text("All Events",
            style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple, // Custom color for the AppBar
      ),
      body: ListView.builder(
        itemCount: eventList.getEvents().length,
        itemBuilder: (context, index) {
          final event = eventList.getEvents()[index];
          return Card(
            // Wrap each event in a Card for better visual separation and material design feel
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                // Optional: use an icon or image
                backgroundColor: Colors.deepPurple,
                child: Text(
                    event.type
                        .toString()
                        .split('.')
                        .last[0], // Display first letter of event type
                    style: TextStyle(color: Colors.white)),
              ),
              title: Text(event.title,
                  style: GoogleFonts.roboto(
                      fontSize: 18, fontWeight: FontWeight.w500)),
              subtitle: Text(
                  "${event.description} - ${event.date.day}/${event.date.month}/${event.date.year}",
                  style: GoogleFonts.roboto(fontSize: 14)),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.deepPurple), // Edit icon
                onPressed: () {
                  // Add your code to handle event editing
                },
              ),
              onTap: () {
                // You can add a detail page or some action here on tap
              },
            ),
          );
        },
      ),
    );
  }
}
