import 'package:flutter/material.dart';
import 'package:mobile_app/mail/Draft.dart';
import 'package:mobile_app/mail/chat-mail.dart';

import 'package:mobile_app/mail/email.dart';

class ImportantMailPage extends StatefulWidget {
  @override
  _ImportantMailPageState createState() => _ImportantMailPageState();
}

class _ImportantMailPageState extends State<ImportantMailPage> {
  TextEditingController searchController = TextEditingController();
  List<Email> ImportantEmails = [];
  List<Email> filteredEmails = [];
  Set<int> selectedEmailIndices = {};

  @override
  void initState() {
    super.initState();
    fetchEmails();
    searchController.addListener(() {
      filterEmails();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void fetchEmails() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      ImportantEmails = [
        Email(
          sender: 'Sal Piggee',
          subject: 'lorem ipsum lorem ipsum lorem ipsum',
          isStarred: true,
          senderImagePath: 'assets/Ellipse 12.png',
          cc: '',
          recipient: '',
          date: '',
          message: '',
          type: EmailType.important, // Replace with actual image path
        ),
        Email(
            sender: 'Miguel Guelff',
            subject: 'lorem ipsum lorem ipsum lorem ipsum',
            isStarred: false,
            senderImagePath: 'assets/Ellipse 15.png',
            cc: '',
            recipient: '',
            date: '',
            message: '',
            type: EmailType.important // Replace with actual image path
            ),
        // Add more Email objects...
      ];
      filteredEmails = ImportantEmails;
    });
  }

  void filterEmails() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      if (searchTerm.isEmpty) {
        filteredEmails =
            ImportantEmails; // If search term is empty, show all emails
      } else {
        filteredEmails = ImportantEmails.where((email) {
          // Filter emails based on the search term
          return email.sender.toLowerCase().contains(searchTerm) ||
              email.subject.toLowerCase().contains(searchTerm);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF28243D),
      appBar: AppBar(
          title: Text('Important'),
          backgroundColor: Color(0xFF9155FD),
          actions: [
            // ... (Any other actions)
            PopupMenuButton<String>(
              onSelected: (String value) {
                switch (value) {
                  case 'Select All':
                    setState(() {
                      selectedEmailIndices.addAll(
                        List.generate(filteredEmails.length, (index) => index),
                      );
                    });
                    break;
                  case 'Delete':
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // Return a dialog for confirmation
                        return AlertDialog(
                          title: Text('Confirm Delete'),
                          content: Text(
                              'Are you sure you want to delete the selected emails?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Dismiss the dialog
                              },
                            ),
                            TextButton(
                              child: Text('Delete'),
                              onPressed: () {
                                setState(() {
                                  selectedEmailIndices
                                      .toList()
                                      .reversed
                                      .forEach((index) {
                                    ImportantEmails.removeAt(index);
                                  });
                                  selectedEmailIndices.clear();
                                  filteredEmails = List.from(ImportantEmails);
                                });
                                Navigator.of(context)
                                    .pop(); // Dismiss the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Select All',
                  child: Text('Select All'),
                ),
                const PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text('Delete'),
                ),
              ],
              icon: Icon(Icons.more_vert), // Icon for the button
            ),
          ]),
      body: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search (Ctrl+/)',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                filled: true,
                fillColor: Color(0xFF312D4B),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEmails.length,
              itemBuilder: (context, index) {
                final email = filteredEmails[index];
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          email.isStarred ? Icons.star : Icons.star_border,
                          color: email.isStarred ? Colors.yellow : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            email.isStarred = !email.isStarred;
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        backgroundImage: AssetImage(email.senderImagePath),
                      ),
                    ],
                  ),
                  title:
                      Text(email.sender, style: TextStyle(color: Colors.white)),
                  subtitle: Text(email.subject,
                      style: TextStyle(color: Colors.white.withOpacity(0.5))),
                  trailing: Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Colors
                          .orange, // Orange color indicates 'Important' email
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF28243D), width: 2),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EmailViewScreen(email: email),
                      ),
                    );
                  },
                  tileColor: selectedEmailIndices.contains(index)
                      ? Colors.grey[200]
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
