import 'package:flutter/material.dart';

class Email {
  final String sender;
  final String subject;
  final bool isStarred;
  final String senderImagePath; // Field for the sender's image

  Email({
    required this.sender,
    required this.subject,
    required this.isStarred,
    required this.senderImagePath, // Initialize the sender's image
  });
}

class ImportantMailPage extends StatefulWidget {
  @override
  _ImportantMailPageState createState() => _ImportantMailPageState();
}

class _ImportantMailPageState extends State<ImportantMailPage> {
  TextEditingController searchController = TextEditingController();
  List<Email> ImportantEmails = [];
  List<Email> filteredEmails = [];

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
          senderImagePath:
              'assets/Ellipse 12.png', // Replace with actual image path
        ),
        Email(
          sender: 'Miguel Guelff',
          subject: 'lorem ipsum lorem ipsum lorem ipsum',
          isStarred: false,
          senderImagePath:
              'assets/Ellipse 15.png', // Replace with actual image path
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
          IconButton(
            icon: Image.asset('assets/3p.png'),
            onPressed: () {
              // Settings action
            },
          ),
        ],
      ),
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
              itemCount: ImportantEmails.length,
              itemBuilder: (context, index) {
                if (index >= filteredEmails.length) {
                  return Container(); // Return an empty container in case of index out of range
                }
                final email = filteredEmails[index];
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        email.isStarred ? Icons.star : Icons.star_border,
                        color: email.isStarred ? Colors.yellow : Colors.white,
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
                          .orange, // Orange to represent 'Important' email
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF28243D), width: 2),
                    ),
                  ),
                  onTap: () {
                    // Open email details
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
