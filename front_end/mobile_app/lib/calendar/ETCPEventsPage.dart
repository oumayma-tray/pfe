import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/calendar/listEvent.dart'; // Make sure the path is correct

class ETCPEventsPage extends StatelessWidget {
  const ETCPEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter the events for only those that are of type 'ETC'
    List<Eventt> etcEvents = eventList
        .getEvents()
        .where((event) => event.type == EventType.ETC)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("ETC Events",
            style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple, // Custom color for the AppBar
      ),
      body: ListView.builder(
        itemCount: etcEvents.length,
        itemBuilder: (context, index) {
          final event = etcEvents[index];
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
                  // Here you can add functionality to edit the event
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
