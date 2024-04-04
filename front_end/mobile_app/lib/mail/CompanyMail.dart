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

class CompanyMailPage extends StatefulWidget {
  @override
  _CompanyMailPageState createState() => _CompanyMailPageState();
}

class _CompanyMailPageState extends State<CompanyMailPage> {
  TextEditingController searchController = TextEditingController();

  // This list would be populated with company emails, typically fetched from your backend
  List<Email> companyEmails = [];
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
          IconButton(
            icon: Image.asset(
                'assets/3p.png'), // Replace with your settings icon asset
            onPressed: () {
              // Implement your settings action
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
              itemCount: filteredEmails
                  .length, // itemCount set to the length of filteredEmails
              itemBuilder: (context, index) {
                if (index >= filteredEmails.length) {
                  return Container(); // Return an empty container in case of index out of range
                }
                final email =
                    filteredEmails[index]; // Use email from filteredEmails
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 16.0), // Padding at the start of the row
                      Icon(
                        email.isStarred ? Icons.star : Icons.star_border,
                        color: email.isStarred ? Colors.yellow : Colors.white,
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
                          color:
                              Colors.blue, // Blue to represent 'Company' email
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Color(0xFF28243D), width: 2),
                        ),
                      ),
                      SizedBox(width: 16.0), // Padding at the end of the row
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
