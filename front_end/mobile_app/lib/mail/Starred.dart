// Starred.dart
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

class StarredPage extends StatefulWidget {
  @override
  _StarredPageState createState() => _StarredPageState();
}

class _StarredPageState extends State<StarredPage> {
  TextEditingController searchController = TextEditingController();
  List<Email> StarredEmails = [];
  List<Email> filteredEmails = [];

  int?
      selectedEmailIndex; // Stocke l'indice de l'e-mail sélectionné// Using a Set to allow multiple selections

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
    // Simulate a network call to fetch emails
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      StarredEmails = [
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
      // Initialize StarredEmails with your data
      filteredEmails =
          List.from(StarredEmails); // Initially, all emails are shown
    });
  }

  void _onSearchChanged() {
    setState(() {
      filteredEmails = searchController.text.isEmpty
          ? StarredEmails
          : StarredEmails.where((email) => email.sender
              .toLowerCase()
              .contains(searchController.text.toLowerCase())).toList();
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
            Image.asset('assets/starred.png', height: 24), // Your Starred icon
            SizedBox(width: 8),
            Text('Starred'),
          ],
        ),
        backgroundColor: Color(0xFF9155FD), // AppBar background color
        actions: [
          IconButton(
            icon: Image.asset('assets/3p.png'), // Your settings icon
            onPressed: () {
              // TODO: Implement settings navigation
            },
          ),
        ],
      ),
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
        itemCount: filteredEmails.length,
        itemBuilder: (context, index) {
          final email = filteredEmails[index];
          bool isSelected = selectedEmailIndex == index;

          return _buildEmailItem(email, isSelected, () {
            setState(() {
              // Change la sélection
              if (isSelected) {
                selectedEmailIndex = null; // Désélectionner si déjà sélectionné
              } else {
                selectedEmailIndex = index; // Sélectionner le nouvel e-mail
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
