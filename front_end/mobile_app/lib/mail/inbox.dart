// inbox.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/mail/Starred.dart';

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

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  TextEditingController searchController = TextEditingController();
  List<Email> inboxEmails = [];
  List<Email> filteredEmails = [];
  Set<int> selectedEmailIndices =
      {}; // Using a Set to allow multiple selections

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
// Define a callback

  void fetchEmails() async {
    // Simulate a network call to fetch emails
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      inboxEmails = [
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
      // Initialize inboxEmails with your data
      filteredEmails =
          List.from(inboxEmails); // Initially, all emails are shown
    });
  }

  void _onSearchChanged() {
    setState(() {
      filteredEmails = searchController.text.isEmpty
          ? inboxEmails
          : inboxEmails
              .where((email) => email.sender
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
              .toList();
    });
  }

  void deleteSelectedEmails() {
    setState(() {
      // Remove emails from the end of the list to avoid index shifting issues
      var indicesList = selectedEmailIndices.toList()
        ..sort((a, b) => b.compareTo(a));
      for (var index in indicesList) {
        inboxEmails.removeAt(index);
      }
      // After deletion, reset the selectedEmailIndices and update filteredEmails
      selectedEmailIndices.clear();
      filteredEmails = List.from(inboxEmails);
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
              Image.asset('assets/inbox.png', height: 24), // Your inbox icon
              SizedBox(width: 8),
              Text('Inbox'),
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
                                    inboxEmails.removeAt(index);
                                  });
                                  selectedEmailIndices.clear();
                                  filteredEmails = List.from(inboxEmails);
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

  Widget _buildEmailItem(
      Email email, int index, bool isSelected, VoidCallback onTap) {
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

    void toggleStarred() {
      // Update the isStarred property of the email
      // This assumes you have a way to modify the state of the email
      // For example, you could use a setState call if the emails are stored in the state of your widget
      setState(() {
        inboxEmails[index].isStarred = !inboxEmails[index].isStarred;
      });
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
        onChanged: (value) {
          // Call the search filter function
          _onSearchChanged();
        },
      ),
    );
  }

  Widget _buildEmailList() {
    return Expanded(
      child: ListView.builder(
        itemCount:
            filteredEmails.length, // Use the length of your filtered emails
        itemBuilder: (context, index) {
          final email = filteredEmails[index];
          bool isSelected =
              selectedEmailIndices.contains(index); // Check selection status

          // Pass the index to the _buildEmailItem method
          return _buildEmailItem(email, index, isSelected, () {
            setState(() {
              // Toggle selection status
              if (isSelected) {
                selectedEmailIndices.remove(index);
              } else {
                selectedEmailIndices.add(index);
              }
            });
          });
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
