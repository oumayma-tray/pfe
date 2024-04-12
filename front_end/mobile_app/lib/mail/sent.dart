// sent.dart
import 'package:flutter/material.dart';

enum EmailType { important, personal, company, private }

class Email {
  final String sender;
  final String subject;
  bool isStarred;
  final String senderImagePath;
  final EmailType type;

  Email({
    required this.sender,
    required this.subject,
    required this.isStarred,
    required this.senderImagePath,
    required this.type,
  });
}

class sentPage extends StatefulWidget {
  @override
  _sentPageState createState() => _sentPageState();
}

class _sentPageState extends State<sentPage> {
  TextEditingController searchController = TextEditingController();
  List<Email> sentEmails = [];
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
    // Simulate a network call to fetch emails
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      sentEmails = [
        Email(
          sender: 'Joaquina Weisenborn',
          subject: 'lorem ipsum lorem ipsum lorem ipsum',
          isStarred: true,
          senderImagePath:
              'assets/Ellipse 10.png', // Ensure this is the correct path for the avatar image
          type: EmailType
              .private, // The type should match the email category, here it is 'trash'
        ),
        Email(
          sender: 'Felecia Rower',
          subject: 'lorem ipsum lorem ipsum lorem ipsum',
          isStarred: false,
          senderImagePath:
              'assets/Ellipse 11.png', // Correct path for avatar image
          type: EmailType.private, // Email type is 'trash'
        ),
        // Add more Email objects with their corresponding images and types
        Email(
          sender: 'Sal Piggee',
          subject: 'lorem ipsum lorem ipsum lorem ipsum',
          isStarred: false,
          senderImagePath:
              'assets/Ellipse 12.png', // Update the asset path as needed
          type: EmailType.company,
        ),
        Email(
          sender: 'Verla Morgano',
          subject: 'lorem ipsum lorem ipsum lorem ipsum',
          isStarred: true,
          senderImagePath:
              'assets/Ellipse 13.png', // Update the asset path as needed
          type: EmailType.personal,
        ),
        Email(
          sender: 'Mauro Elenbaas',
          subject: 'lorem ipsum lorem ipsum lorem ipsum',
          isStarred: false,
          senderImagePath:
              'assets/Ellipse 14.png', // Update the asset path as needed
          type: EmailType.personal,
        ),
        Email(
          sender: 'Miguel Guelff',
          subject: 'lorem ipsum lorem ipsum lorem ipsum',
          isStarred: true,
          senderImagePath:
              'assets/Ellipse 15.png', // Update the asset path as needed
          type: EmailType.important,
        ),
      ];
      // Initialize sentEmails with your data
      filteredEmails = List.from(sentEmails); // Initially, all emails are shown
    });
  }

  void filterEmails() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      if (searchTerm.isEmpty) {
        filteredEmails = sentEmails; // If search term is empty, show all emails
      } else {
        filteredEmails = sentEmails.where((email) {
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
          Color(0xFF28243D), // Set the background color for the entire page
      appBar: AppBar(
          title: Row(
            children: [
              Image.asset('assets/send.png', height: 24), // Your sent icon
              SizedBox(width: 8),
              Text('sent'),
            ],
          ),
          backgroundColor: Color(0xFF9155FD), // AppBar background color
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
                                    sentEmails.removeAt(index);
                                  });
                                  selectedEmailIndices.clear();
                                  filteredEmails = List.from(sentEmails);
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
          _buildSearchBar(),
          _buildEmailList(),
        ],
      ),
    );
  }

  Widget _buildEmailItem(Email email, bool isSelected, VoidCallback onTap) {
    Color getTypeColor(EmailType type) {
      switch (type) {
        case EmailType.important:
          return Colors.red;
        case EmailType.personal:
          return Colors.green;
        case EmailType.company:
          return Colors.blue;
        case EmailType.private:
          return Colors.orange;
        default:
          return Colors.transparent;
      }
    }

    return Card(
      color: isSelected ? Color(0xFF9155FD) : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10), // This sets the rounded corners
      ),
      child: ListTile(
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
                  // Toggle the isStarred property
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
        title: Text(email.sender, style: TextStyle(color: Colors.white)),
        subtitle: Text(email.subject,
            style: TextStyle(color: Colors.white.withOpacity(0.5))),
        trailing: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: getTypeColor(email.type),
            shape: BoxShape.circle,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
    );
  }

  Widget _buildEmailList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredEmails.length,
        itemBuilder: (context, index) {
          final email = filteredEmails[index];
          bool isSelected = selectedEmailIndices.contains(index);

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
            title: Text(email.sender, style: TextStyle(color: Colors.white)),
            subtitle: Text(email.subject,
                style: TextStyle(color: Colors.white.withOpacity(0.5))),
            trailing: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF28243D), width: 2),
              ),
            ),
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedEmailIndices.remove(index);
                } else {
                  selectedEmailIndices.add(index);
                }
              });
            },
            tileColor: isSelected ? Colors.grey[200] : null,
          );
        },
      ),
    );
  }
// Implement the _buildEmailItem method as shown in previous code examples

  Color _getTypeColor(EmailType type) {
    switch (type) {
      case EmailType.important:
        return Colors.red;
      case EmailType.personal:
        return Colors.green;
      case EmailType.company:
        return Colors.blue;
      case EmailType.private:
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }
}

Widget _buildEmailItem(Email email, bool isSelected, VoidCallback onTap) {
  Color getTypeColor(EmailType type) {
    switch (type) {
      case EmailType.important:
        return Colors.red;
      case EmailType.personal:
        return Colors.green;
      case EmailType.company:
        return Colors.blue;
      case EmailType.private:
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }

  return ListTile(
    tileColor: isSelected ? Color(0xFF9155FD) : Colors.transparent,
    leading: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          email.isStarred ? Icons.star : Icons.star_border, // Starred icon
          color: email.isStarred ? Colors.yellow : Colors.grey,
        ),
        SizedBox(width: 8),
        CircleAvatar(
          backgroundImage: AssetImage(email.senderImagePath),
        ),
      ],
    ),
    title: Text(email.sender, style: TextStyle(color: Colors.white)),
    subtitle: Text(email.subject,
        style: TextStyle(color: Colors.white.withOpacity(0.5))),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: getTypeColor(email.type),
            shape: BoxShape.circle,
          ),
        ),
        isSelected
            ? Icon(Icons.check_circle, color: Colors.white) // Selected icon
            : SizedBox.shrink(),
      ],
    ),
    onTap: onTap,
  );
}
