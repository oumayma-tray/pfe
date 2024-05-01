import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/calendar/listEvent.dart'; // Make sure this path is correct

class HolidayEventsPage extends StatelessWidget {
  const HolidayEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter the events for only those that are of type 'Holiday'
    List<Eventt> holidayEvents = eventList.getEvents().where((event) => event.type == EventType.Holiday).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Holiday Events",
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple, // Custom color for the AppBar
      ),
      body: ListView.builder(
        itemCount: holidayEvents.length,
        itemBuilder: (context, index) {
          final Eventt event = holidayEvents[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Text(
                  event.type.toString().split('.').last[0], // 'H' for Holiday
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(event.title,
                style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500)),
              subtitle: Text(
                "${event.description} - ${event.date.day}/${event.date.month}/${event.date.year}",
                style: GoogleFonts.roboto(fontSize: 14),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: () {
                  // This can be linked to an editing interface for the event
                },
              ),
              onTap: () {
                // Optionally, you can add actions or navigation for more details on tap
              },
            ),
          );
        },
      ),
    );
  }
}
