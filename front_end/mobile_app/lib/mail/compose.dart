import 'package:flutter/material.dart';

class ComposeMailScreen extends StatefulWidget {
  @override
  _ComposeMailScreenState createState() => _ComposeMailScreenState();
}

class _ComposeMailScreenState extends State<ComposeMailScreen> {
  final TextEditingController toController = TextEditingController();
  final TextEditingController ccController = TextEditingController();
  final TextEditingController bccController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Placeholder function to mimic sending an email
  void sendEmail() {
    // Here you could call your own API or another method to send the email
    print('Send email logic would go here');
  }

  void onFormatButtonPressed(String formatAction) {
    // This is just a placeholder function
    // You would implement the actual formatting logic here
    print('Format action: $formatAction');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF28243D),
      appBar: AppBar(
        title: Text('Compose Mail'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(145, 85, 253, 0.5),
                Color.fromRGBO(197, 165, 254, 0.5),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: sendEmail,
          ),
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              // File picker logic would go here
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // More actions here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // Using ListView to make the form scrollable
          children: <Widget>[
            buildTextField(
              controller: toController,
              labelText: 'To',
              hint: 'Enter recipient email',
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 8.0),
            buildTextField(
              controller: ccController,
              labelText: 'Cc',
              hint: 'Enter cc email',
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 8.0),
            buildTextField(
              controller: bccController,
              labelText: 'Bcc',
              hint: 'Enter bcc email',
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 8.0),
            buildTextField(
              controller: subjectController,
              labelText: 'Subject',
              hint: 'Enter subject',
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.black),
            ),
            Wrap(
              children: <Widget>[
                formatButton(Icons.format_bold, 'bold'),
                formatButton(Icons.format_italic, 'italic'),
                formatButton(Icons.format_underline, 'underline'),
                formatButton(Icons.format_strikethrough, 'strikethrough'),
                formatButton(Icons.format_align_left, 'align_left'),
                formatButton(Icons.format_align_center, 'align_center'),
                formatButton(Icons.format_align_right, 'align_right'),

                // Add more buttons as needed
              ],
            ),
            SizedBox(height: 8.0),
            buildTextField(
              controller: messageController,
              labelText: 'Message',
              hint: 'Enter your message here',
              maxLines: 10, // Adjust maxLines for the message field
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hint,
    required labelStyle,
    required hintStyle,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hint,
        labelStyle: labelStyle,
        hintStyle: hintStyle,
        border: OutlineInputBorder(),
      ),
    );
  }
}

Widget formatButton(IconData icon, String formatAction) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Ink(
      decoration: BoxDecoration(
        color: Color(0xFF28243D), // Background color
        borderRadius:
            BorderRadius.circular(4), // Adjust border radius if needed
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(4), // Match the border radius
        onTap: () => onFormatButtonPressed(formatAction),
        child: Padding(
          padding: EdgeInsets.all(8.0), // Padding inside the button
          child: Icon(icon, color: Colors.white), // Icon color
        ),
      ),
    ),
  );
}

onFormatButtonPressed(String formatAction) {}

void main() => runApp(MaterialApp(home: ComposeMailScreen()));
