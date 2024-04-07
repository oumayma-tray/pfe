import 'package:flutter/material.dart';
import 'package:mobile_app/mail/conversationMail.dart';
import 'package:mobile_app/mail/email.dart';
// Define an Email data model

class PersonalMailPage extends StatefulWidget {
  @override
  _PersonalMailPageState createState() => _PersonalMailPageState();
}

class _PersonalMailPageState extends State<PersonalMailPage> {
  TextEditingController searchController = TextEditingController();
  // This list would actually come from your backend
  List<Email> emails = [];
  List<Email> filteredEmails = [];

  @override
  void initState() {
    super.initState();
    fetchEmails();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  // Placeholder for an async function to fetch personal emails
  void fetchEmails() async {
    await Future.delayed(Duration(seconds: 2));
    // Correctly update the class member 'personalEmails', not the local variable
    setState(() {
      emails = [
        Email(
          sender: 'Verla Morgano',
          subject: 'lorem ipsum lorem ipsum lorem ipsum',
          isStarred: false,
          senderImagePath: 'assets/Ellipse 13.png',
          message: '', // Make sure this is the correct path
        ),
        // Add more Email objects with their respective images here...
      ];
      filteredEmails = emails;
    });
  }

  void _onSearchChanged() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      if (searchTerm.isEmpty) {
        filteredEmails = emails; // If search term is empty, show all emails
      } else {
        filteredEmails = emails.where((email) {
          // Filter emails based on the search term
          return email.sender.toLowerCase().contains(searchTerm);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF28243D), // The background color for the page
        appBar: AppBar(
          title: Text('Personal'),
          backgroundColor: Color(0xFF9155FD), // The header color in the image
          actions: [
            IconButton(
              icon: Image.asset(
                  'assets/3p.png'), // Use your own asset for the button
              onPressed: () {
                // Define what happens when this button is tapped
              },
            ),
          ],
        ),
        body: Column(children: <Widget>[
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
                if (index >= filteredEmails.length) {
                  return Container(); // Return an empty container in case of index out of range
                }
                final email = filteredEmails[index];
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Important to prevent the Row from taking up all the available space
                    children: [
                      Icon(
                        email.isStarred ? Icons.star : Icons.star_border,
                        color: email.isStarred ? Colors.yellow : Colors.white,
                      ), // Star icon
                      SizedBox(
                          width: 8), // Spacing between the star and the avatar
                      CircleAvatar(
                        backgroundImage:
                            AssetImage(email.senderImagePath), // Sender's image
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
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF28243D), width: 2),
                    ),
                  ), // The green dot
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ConversationMailPage(email: email),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]));
  }
}
