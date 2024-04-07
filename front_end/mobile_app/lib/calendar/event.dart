import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event extends StatefulWidget {
  const Event({Key? key}) : super(key: key);

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final calendarKey = GlobalKey<FormState>();
  final guestKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1));
  Map<DateTime, List<String>> selectedEvents = {};

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd hh:mm a');
  String? selectedGuests;
  final List<String> guestOptions = [
    'guest 1',
    'guest 2',
    'guest 3',
    'guest 4',
    'guest 5'
  ];
  List<String> selectedGuestsList = [];
  String? selectedCalendar;
  final List<String> calendarOptions = [
    "Personal",
    "Holiday",
    "Family",
    "ETC",
    "Buisiness",
    "View All"
  ];

  void _addEventToCalendar(DateTime selectedDate, String eventTitle) {
    if (selectedEvents[selectedDate] == null) {
      selectedEvents[selectedDate] = [eventTitle];
    } else {
      selectedEvents[selectedDate]!.add(eventTitle);
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event added on $selectedDate'),
      ),
    );

    _controller.clear();
  }

  bool viewAllList = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          // Allows the form to be scrollable
          reverse:
              true, // Ensures the scrollview starts at the bottom of the viewport
          child: Padding(
            padding: EdgeInsets.only(
                bottom: bottomInset), // Padding for the keyboard
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(40, 36, 61, 1),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(40, 36, 61, 1),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      TextFormField(
                        controller: _controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter an event title ';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Title*',
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Form(
                        key: calendarKey,
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: selectedCalendar,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'please enter a calendar ';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Calendar*',
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(145, 85, 253, 1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(145, 85, 253, 1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(145, 85, 253, 1),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedCalendar = value!;
                                });
                              },
                              dropdownColor: Color.fromRGBO(40, 36, 61, 1),
                              items: calendarOptions.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a start date';
                          }
                          return null;
                        },
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (selectedTime != null) {
                              setState(() {
                                _startDate = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                                _startDateController.text =
                                    dateFormat.format(_startDate);
                              });
                            }
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Start Date*',
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _endDateController,
                        readOnly: true,
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (selectedTime != null) {
                              setState(() {
                                _endDate = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                                _endDateController.text =
                                    dateFormat.format(_endDate);
                              });
                            }
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Event URL',
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.url,
                      ),
                      SizedBox(height: 12),
                      Form(
                        key: guestKey,
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: selectedGuests,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Guests',
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(145, 85, 253, 1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(145, 85, 253, 1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(145, 85, 253, 1),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedGuests = value!;
                                });
                              },
                              dropdownColor: Color.fromRGBO(40, 36, 61, 1),
                              items: guestOptions.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(145, 85, 253, 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  calendarKey.currentState!.validate()) {
                                DateTime selectedDate = selectedDay;
                                String eventTitle = _controller.text;
                                _addEventToCalendar(selectedDate, eventTitle);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(145, 85, 253, 1),
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(40, 36, 61, 1),
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: Color.fromRGBO(145, 85, 253, 1),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
