import 'package:flutter/material.dart';
import 'package:mobile_app/mail/Starred.dart';

class Email {
  final String sender;
  final String subject;
  bool isStarred; // Changed to mutable
  final String senderImagePath;

  Email({
    required this.sender,
    required this.subject,
    required this.isStarred,
    required this.senderImagePath,
  });
}

class CompanyMailPage extends StatefulWidget {
  @override
  _CompanyMailPageState createState() => _CompanyMailPageState();
}

class _CompanyMailPageState extends State<CompanyMailPage> {
  TextEditingController searchController = TextEditingController();

  // This list would be populated with company emails, typically fetched from your backend
  List<Email> companyEmails = [];
  List<Email> filteredEmails = [];
  Set<int> selectedEmailIndices = {}; //

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

  // Placeholder for an async function to fetch personal emails
  void fetchEmails() async {
    await Future.delayed(Duration(seconds: 2));
    // Correctly update the class member 'personalEmails', not the local variable
    setState(() {
      companyEmails = [
        Email(
          sender: 'Mauro Elenbaas',
          subject: 'lorem ipsum lorem ipsum lorem ipsum',
          isStarred: true,
          senderImagePath:
              'assets/Ellipse 14.png', // Make sure this is the correct path
        ),
        // Add more Email objects with their respective images here...
      ];
      filteredEmails = companyEmails;
    });
  }

  void filterEmails() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      if (searchTerm.isEmpty) {
        filteredEmails =
            companyEmails; // If search term is empty, show all emails
      } else {
        filteredEmails = companyEmails.where((email) {
          // Filter emails based on the search term
          return email.sender.toLowerCase().contains(searchTerm) ||
              email.subject.toLowerCase().contains(searchTerm);
        }).toList();
      }
    });
  }

  void deleteSelectedEmails() {
    setState(() {
      // Remove emails from the end of the list to avoid index shifting issues
      var indicesList = selectedEmailIndices.toList()
        ..sort((a, b) => b.compareTo(a));
      for (var index in indicesList) {
        companyEmails.removeAt(index);
      }
      // After deletion, reset the selectedEmailIndices and update filteredEmails
      selectedEmailIndices.clear();
      filteredEmails = List.from(companyEmails);
    });
  }

  void _onSearchChanged() {
    setState(() {
      filteredEmails = searchController.text.isEmpty
          ? companyEmails
          : companyEmails
              .where((email) => email.sender
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFF28243D), // Set the background color of the page
      appBar: AppBar(
          title: Text('Company'),
          backgroundColor: Color(
              0xFF9155FD), // Adjust the color to match the design for 'Company'
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
                                    companyEmails.removeAt(index);
                                  });
                                  selectedEmailIndices.clear();
                                  filteredEmails = List.from(companyEmails);
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
                bool isSelected = selectedEmailIndices
                    .contains(index); // Check selection status

                // Define the selected color
                Color selectedColor = Color(
                    0xFF4E5B81); // Choose a color for selected items, for example

                return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle selection status on tap
                        if (isSelected) {
                          selectedEmailIndices.remove(index);
                        } else {
                          selectedEmailIndices.add(index);
                        }
                      });
                    },
                    child: Container(
                      color: isSelected
                          ? selectedColor
                          : Colors
                              .transparent, // Use selected color if the email is selected
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                              width: 16.0), // Padding at the start of the row
                          IconButton(
                            icon: Icon(
                              email.isStarred ? Icons.star : Icons.star_border,
                              color: email.isStarred
                                  ? Colors.yellow
                                  : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                // Toggle the isStarred status of the email
                                email.isStarred = !email.isStarred;

                                // If email gets starred and we are in the StarredPage, add it to selectedEmailIndices
                                if (email.isStarred &&
                                    this.widget is StarredPage) {
                                  selectedEmailIndices.add(index);
                                } else {
                                  selectedEmailIndices.remove(index);
                                }
                              });
                            },
                          ),

                          SizedBox(width: 8),
                          CircleAvatar(
                            backgroundImage: AssetImage(email.senderImagePath),
                          ),
                          SizedBox(
                              width: 16.0), // Space between the avatar and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(email.sender,
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(height: 4.0),
                                Text(email.subject,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.5))),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 8.0),
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: Colors
                                  .blue, // Blue to represent 'Company' email
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(0xFF28243D), width: 2),
                            ),
                          ),
                          SizedBox(
                              width: 16.0), // Padding at the end of the row
                        ],
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
