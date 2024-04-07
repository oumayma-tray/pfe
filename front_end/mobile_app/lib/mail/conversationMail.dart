import 'package:flutter/material.dart';
import 'package:mobile_app/mail/email.dart'; // Make sure this import is correct

class ConversationMailPage extends StatefulWidget {
  final Email email;

  ConversationMailPage({required this.email});

  @override
  _ConversationMailPageState createState() => _ConversationMailPageState();
}

class _ConversationMailPageState extends State<ConversationMailPage> {
  final TextEditingController toController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    toController.text = widget.email.sender; // Pre-fill the 'To' field
    subjectController.text =
        'Re: ${widget.email.subject}'; // Pre-fill the 'Subject' field with a reply prefix
    // Here you can also pre-fill the 'Message' field with the original message if you want to include it in the reply
    // messageController.text = '...\n\nOriginal message:\n${widget.email.message}';
  }

  // This function is just a placeholder for the actual send logic
  void sendReply() {
    print('Reply sent to: ${toController.text}');
    // Here you would usually send the reply through an API or your email server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff28243D),
      appBar: AppBar(
        title: Text('Reply to: ${widget.email.subject}'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(235, 233, 240, 1),
                Color.fromRGBO(249, 248, 251, 1),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Add a read-only text field to display the original email message
            buildReadOnlyEmailField(
                'From: ${widget.email.sender}', widget.email.message),
            SizedBox(height: 16.0),
            // Add your text fields here for composing a reply
            buildTextField(
              controller: toController,
              labelText: 'To',
              isEnabled:
                  false, // You can make this read-only if this is a fixed reply
            ),
            buildTextField(
              controller: subjectController,
              labelText: 'Subject',
            ),
            buildTextField(
              controller: messageController,
              labelText: 'Message',
              maxLines: 10, // Multi-line text field for composing a message
            ),
            // Add a send button
            ElevatedButton(
              onPressed: sendReply,
              child: Text('Send Reply'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReadOnlyEmailField(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white), // Set title text color to white
        ),
        SizedBox(height: 8.0),
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(content, style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool isEnabled = true,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
          color: Colors.white38), // Set text field input text color to white
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
            TextStyle(color: Colors.white24), // Set label text color to white
        hintText: 'Enter a value',
        hintStyle: TextStyle(
            color: Colors.white30), // Set hint text color to a lighter white
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white38),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white38),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white38),
        ),
      ),
      enabled: isEnabled,
    );
  }
}
