import 'package:flutter/material.dart';

enum EmailType { important, personal, company, private }

class Email {
  final String sender;
  final String subject;
  final bool isStarred;
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

//... rest of your code

class TrashMailPage extends StatefulWidget {
  @override
  _TrashMailPageState createState() => _TrashMailPageState();
}

class _TrashMailPageState extends State<TrashMailPage> {
  TextEditingController searchController = TextEditingController();
  List<Email> trashEmails = [];
  List<Email> filteredEmails = [];
  int? selectedEmailIndex;
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

  void fetchEmails() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      trashEmails = [
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
      filteredEmails = List.from(trashEmails);
    });
  }

  void _onSearchChanged() {
    if (searchController.text.isEmpty) {
      setState(() {
        filteredEmails = List.from(
            trashEmails); // Show all emails if the search bar is empty
      });
    } else {
      setState(() {
        filteredEmails = trashEmails.where((email) {
          return email.sender.toLowerCase().contains(searchController.text
              .toLowerCase()); // Filter emails by sender name
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF28243D),
      appBar: AppBar(
        title: Text('Trash'),
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
              itemCount:
                  filteredEmails.length, // Use the length of filteredEmails
              itemBuilder: (context, index) {
                final email =
                    filteredEmails[index]; // Access the filteredEmails

                bool isSelected = selectedEmailIndex == index;
                return _buildEmailItem(email, isSelected, () {
                  setState(() {
                    if (selectedEmailIndex == index) {
                      selectedEmailIndex =
                          null; // Deselect if the same email is tapped again
                    } else {
                      selectedEmailIndex = index; // Select the tapped email
                    }
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailItem(Email email, bool isSelected, VoidCallback onTap) {
    Color getTypeColor(EmailType type) {
      switch (type) {
        case EmailType.important:
          return Colors.yellow;
        case EmailType.personal:
          return Colors.green;
        case EmailType.company:
          return Colors.blue;
        case EmailType.private:
          return Colors.red;
        default:
          return Colors.transparent;
      }
    }

    return ListTile(
      tileColor: isSelected
          ? Color(0xFF9155FD)
          : Colors.transparent, // Change tile color when selected
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            email.isStarred ? Icons.star : Icons.star_border,
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
          Image.asset('assets/flesh.png'), // Your action icon
          Container(
            height: 12,
            width: 12,
            margin: EdgeInsets.only(
                left: 8), // Add margin between the icon and the dot
            decoration: BoxDecoration(
              color: getTypeColor(email.type), // Use the method to get color
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      onTap: onTap, // Call the onTap callback provided as a parameter
    );
  }
}
