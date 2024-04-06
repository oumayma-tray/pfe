import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/mail/CompanyMail.dart';
import 'package:mobile_app/mail/Draft.dart';
import 'package:mobile_app/mail/PersonalMail.dart';
import 'package:mobile_app/mail/ImportantMail.dart';
import 'package:mobile_app/mail/PrivateMail.dart';
import 'package:mobile_app/mail/Starred.dart';
import 'package:mobile_app/mail/TrashMail.dart';
import 'package:mobile_app/mail/compose.dart';
import 'package:mobile_app/mail/inbox.dart';
import 'package:mobile_app/mail/sent.dart';
import 'package:mobile_app/mail/spam.dart';

class MailHomePage extends StatefulWidget {
  @override
  _MailHomePageState createState() => _MailHomePageState();
}

class _MailHomePageState extends State<MailHomePage> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Define the screen width for positioning the circles on the image.
    double screenWidth = MediaQuery.of(context).size.width;
    // Assuming the image asset takes the full width of the screen.
    double imageWidth = screenWidth;
    // Calculate the ratio of the dot's position to the image width (replace with actual value).
    double dotSize = 25;
    // Calculate the scale factor if your design is based on a different width than your current screen width.
    double scaleFactor = screenWidth /
        355; // designWidth is the width of your image in your design tool.
    return Scaffold(
      backgroundColor: const Color(0xFF28243D), // The dark background color
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF28243D), // Adjust the color to match your design
        elevation: 0, // No shadow for the AppBar
        centerTitle: true, // Centers the title widget
        title: Image.asset('assets/smartovate.png',
            height: 40), // Logo as the title widget
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical:
                    0), // Adjust the padding to control the search bar's size on the screen
            child: TextField(
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical:
                        10.0), // Reduced padding inside the search field for a smaller bar
                hintText: 'Search (Ctrl+/)',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search,
                    color: Colors.white,
                    size: 20), // You can adjust the size of the icon as needed
                filled: true,
                fillColor: Color(0xFF312D4B),
                enabledBorder: OutlineInputBorder(
                  // Normal state border
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Colors.white), // White border as described
                ),
                focusedBorder: OutlineInputBorder(
                  // Border when TextField is selected
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),

          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Image.asset('assets/mail_box.png'), // Background image
                // Personal button
                _buildPositionedCircleButton(
                  top: scaleFactor * 108,
                  left: imageWidth * .063 - dotSize / 2,
                  color: Colors.green,
                  label: 'Personal',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonalMailPage()),
                    );
                  },
                ),
                // Company button
                _buildPositionedCircleButton(
                  top: scaleFactor * 63,
                  left: imageWidth * .107 - dotSize / 2,
                  color: Colors.blue,
                  label: 'Company',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyMailPage()),
                    );
                  },
                ),
                // Important button
                _buildPositionedCircleButton(
                  top: 44, // Adjust these values as needed
                  left: screenWidth * .245 - dotSize / 2,
                  color: Colors.yellow,
                  label: 'Important',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImportantMailPage()),
                    );
                  },
                ),
                // Private button
                _buildPositionedCircleButton(
                  top: 66, // Adjust these values as needed
                  left: screenWidth * .395 - dotSize / 2,
                  color: Colors.red,
                  label: 'Private',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivateMailPage()),
                    );
                  },
                ),
                // Trash button
                Positioned(
                  top: 105, // Adjust this value as needed to match your layout
                  left: screenWidth * .49 -
                      dotSize, // Adjust based on the icon's width for centering
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TrashMailPage()),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Trash', // Label text for the icon
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12, // Adjust the font size as needed
                          ),
                        ),
                        SizedBox(height: 4), // Space between text and the icon
                        Image.asset('assets/trash.png',
                            width: dotSize), // Assuming the image is square
                      ],
                    ),
                  ),
                ),
                // ... Add other labeled buttons if needed
              ],
            ),
          ),

          // Email folder buttons using images
          Column(
            children: <Widget>[
              _buildEmailFolderButton(context, 'assets/inbox.png', 'Inbox', 3,
                  Colors.blue, InboxPage()),
              _buildEmailFolderButton(context, 'assets/send.png', 'Sent', 0,
                  Colors.orange, sentPage()),
              _buildEmailFolderButton(context, 'assets/draft.png', 'Draft', 4,
                  Colors.blue, DraftPage()),
              _buildEmailFolderButton(context, 'assets/starred.png', 'Starred',
                  0, Colors.blue, StarredPage()),
              _buildEmailFolderButton(context, 'assets/spam.png', 'Spam', 2,
                  Colors.blue, spamPage()),
              // Add more buttons as needed
            ],
          ),

          Positioned(
            child: Container(
              width: 120,
              padding: EdgeInsets.all(5), // Padding around the button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ComposeMailScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF312D4B), // Button background color
                  foregroundColor: Colors.white, // Text color
                  shadowColor: Colors.transparent, // No shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 16), // Vertical padding for a taller button
                ),
                child: Text('Compose'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionedCircleButton({
    required double top,
    required double left,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // To keep the Column as big as its children
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12, // Adjust the font size as needed
              ),
            ),
            SizedBox(height: 4), // Space between text and the circle
            CircleAvatar(
              backgroundColor: color,
              radius: 9.5, // Adjust the size as needed
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailFolderButton(BuildContext context, String imagePath,
      String title, int count, Color iconColor, Widget destinationPage) {
    return Container(
      height: 47,
      margin: EdgeInsets.only(top: 5), // Adjust margins as necessary
      decoration: BoxDecoration(
        color: Color(0xFF9155FD), // Button background color
        borderRadius:
            BorderRadius.circular(10.0), // Adjust border radius as necessary
      ),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 24,
          color: iconColor,
        ),
        title: Text(title, style: TextStyle(color: Colors.white)),
        trailing: _buildCounter(count, iconColor),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => destinationPage));
        },
      ),
    );
  }

  Widget _buildCounter(int count, Color color) {
    return count > 0
        ? Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color, // Notification color matches the type of mail
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: TextStyle(color: Colors.white),
            ),
          )
        : SizedBox(); // Returns an empty box if count is 0
  }
}

void main() => runApp(MaterialApp(home: MailHomePage()));
