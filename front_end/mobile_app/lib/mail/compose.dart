import 'package:flutter/material.dart';

class ComposeMailScreen extends StatefulWidget {
  @override
  _ComposeMailScreenState createState() => _ComposeMailScreenState();
}

class _ComposeMailScreenState extends State<ComposeMailScreen> {
  final TextEditingController messageController = TextEditingController();
  TextStyle currentStyle = TextStyle(color: Colors.white);
  final TextEditingController toController = TextEditingController();
  final TextEditingController ccController = TextEditingController();
  final TextEditingController bccController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  // Placeholder function to mimic sending an email
  void sendEmail() {
    // Here you could call your own API or another method to send the email
    print('Send email logic would go here');
  }

  String selectedFormatAction = '';

  void onFormatButtonPressed(String formatAction) {
    setState(() {
      // Toggle the current style with the new action
      if (selectedFormatAction != formatAction) {
        selectedFormatAction = formatAction;
      } else {
        selectedFormatAction = '';
      }

      // Start with a white text color for the current style
      currentStyle = TextStyle(color: Colors.white);

      if (selectedFormatAction == 'bold') {
        currentStyle = currentStyle.copyWith(fontWeight: FontWeight.bold);
      } else if (selectedFormatAction == 'italic') {
        currentStyle = currentStyle.copyWith(fontStyle: FontStyle.italic);
      } else if (selectedFormatAction == 'underline') {
        currentStyle =
            currentStyle.copyWith(decoration: TextDecoration.underline);
      } else if (selectedFormatAction == 'strikethrough') {
        currentStyle =
            currentStyle.copyWith(decoration: TextDecoration.lineThrough);
      }

      // Apply the current style along with the white text color to the messageController
      messageController.value = messageController.value.copyWith(
        text: messageController.text,
        selection: messageController.selection,
        composing: TextRange.empty,
      );
    });
  }

  Widget formatButton(IconData icon, String formatAction) {
    bool isSelected = selectedFormatAction == formatAction;
    Color backgroundColor = isSelected ? Color(0xFFC5A5FE) : Colors.transparent;

    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.white : Colors.grey),
      onPressed: () => onFormatButtonPressed(formatAction),
      // Apply a color filter if the button is selected
      color: isSelected ? Color(0xFFC5A5FE) : Colors.grey,
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    toController.dispose();
    ccController.dispose();
    bccController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
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
              maxLines: 10, // Allows for multiline input
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.grey),
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
      style: currentStyle,
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
