import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/calendar/AllEventsPage.dart';
import 'package:mobile_app/calendar/BusinessEventsPage.dart';
import 'package:mobile_app/calendar/ETCPEventsPage.dart';
import 'package:mobile_app/calendar/FamilyEventsPage.dart';
import 'package:mobile_app/calendar/HolidayEventsPage.dart';
import 'package:mobile_app/calendar/PersonalEventsPage.dart';
import 'package:mobile_app/services/calendarService/service_calendar.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:mobile_app/calendar/event.dart';

class CalendarHome extends StatefulWidget {
  const CalendarHome({super.key});

  @override
  State<CalendarHome> createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  final CalendarService _calendarService = CalendarService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _searchController = TextEditingController();
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchUserEvents();
  }

  Future<void> _fetchUserEvents() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('User not logged in');
        return;
      }

      List<Map<String, dynamic>> events =
          await _calendarService.fetchUserEvents(currentUser.uid);
      setState(() {
        _events = events;
        _filteredEvents = [];
      });
    } catch (e) {
      print('Error fetching user events: $e');
    }
  }

  void _filterEvents(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredEvents = [];
      });
      return;
    }

    final events = _events.where((event) {
      final titleLower = event['title'].toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredEvents = events;
    });
  }

  void _navigateToEventPage(String eventType) {
    switch (eventType) {
      case 'Personal':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonalEventsPage()),
        );
        break;
      case 'Holiday':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HolidayEventsPage()),
        );
        break;
      case 'Family':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FamilyEventsPage()),
        );
        break;
      case 'Business':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BusinessEventsPage()),
        );
        break;
      case 'ETC':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ETCPEventsPage()),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDisplayWidget()),
        );
        break;
    }
  }

  void _showAddEventSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.8,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Event(), // Using the Event form widget
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff9155fd), Color(0x84c5a5fe)],
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      width: double.infinity,
                      "assets/Vector 1.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  right: 130,
                  child: Image.asset("assets/image.png"),
                ),
                Positioned(
                  top: 5,
                  left: 60,
                  child: Text(
                    'CALENDARS',
                    style: GoogleFonts.roboto(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.08,
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  child: Padding(
                    padding: EdgeInsets.symmetric(),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        height: screenHeight * 0.25,
                        width: screenWidth * 0.9,
                        child: Column(
                          children: [
                            TextField(
                              controller: _searchController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: 'Search (Ctrl+/)',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.grey),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterEvents('');
                                  },
                                ),
                              ),
                              onChanged: (query) => _filterEvents(query),
                            ),
                            if (_searchController.text.isNotEmpty &&
                                _filteredEvents.isNotEmpty)
                              Expanded(
                                child: Container(
                                  height: 20,
                                  color: Colors.white30,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _filteredEvents.length,
                                    itemBuilder: (context, index) {
                                      final event = _filteredEvents[index];
                                      return ListTile(
                                        title: Text(event['title']),
                                        subtitle: Text(event['description']),
                                        trailing: ElevatedButton(
                                          onPressed: () {
                                            _navigateToEventPage(
                                                event['calendar']);
                                          },
                                          child: Text('Go'),
                                        ),
                                        onTap: () {
                                          _navigateToEventPage(
                                              event['calendar']);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.3,
                  left: screenWidth * 0.0001,
                  child: Image.asset('assets/cercle.png'),
                ),
                Positioned(
                  top: screenHeight * 0.391,
                  left: screenWidth * 0.03,
                  child: GestureDetector(
                    onTap: () => _showAddEventSheet(context),
                    child: Image.asset('assets/Rect-grey.png'),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.391,
                  left: screenWidth * 0.04,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.41,
                  left: screenWidth * 0.03,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventDisplayWidget()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'View All',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.45,
                  left: screenWidth * 0.25,
                  child: Image.asset('assets/Rect-red.png'),
                ),
                Positioned(
                  top: screenHeight * 0.45,
                  left: screenWidth * 0.25,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonalEventsPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Personal',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.49,
                  left: screenWidth * 0.6,
                  child: Image.asset('assets/Rect-yellow.png'),
                ),
                Positioned(
                  top: screenHeight * 0.49,
                  left: screenWidth * 0.6,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FamilyEventsPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Family',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.38,
                  right: screenWidth * 0.19,
                  child: Image.asset('assets/Rect-purple.png'),
                ),
                Positioned(
                  top: screenHeight * 0.38,
                  right: screenWidth * 0.03,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BusinessEventsPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Business',
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.49,
                  right: screenWidth * 0.19,
                  child: Image.asset('assets/Rect-blue.png'),
                ),
                Positioned(
                  top: screenHeight * 0.49,
                  right: screenWidth * 0.1,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ETCPEventsPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'ETC',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.52,
                  left: screenWidth * 0.38,
                  child: Image.asset('assets/Rect-green.png'),
                ),
                Positioned(
                  top: screenHeight * 0.52,
                  left: screenWidth * 0.38,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HolidayEventsPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Holiday',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.34,
                  left: MediaQuery.of(context).size.width * 0.36,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Event(),
                        ),
                      );
                    },
                    child: Text(
                      'Add Event',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(224, 58, 52, 90),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.55,
                  child: Container(
                    width: screenWidth * 0.95,
                    child: TableCalendar(
                      firstDay: DateTime.utc(today.year, today.month - 100),
                      lastDay: DateTime.utc(today.year, today.month + 100),
                      focusedDay: selectedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDay, day);
                      },
                      onDaySelected: (selectedDate, focusedDate) {
                        setState(() {
                          selectedDay = selectedDate;
                        });
                      },
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          final children = <Widget>[];
                          if (events.isNotEmpty) {
                            children.add(
                              Positioned(
                                bottom: 1,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: GoogleFonts.roboto(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
