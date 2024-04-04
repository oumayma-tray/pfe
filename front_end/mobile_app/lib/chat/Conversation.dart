import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/chat/call.dart';
import 'package:mobile_app/chat/vedio.dart';
import 'package:intl/intl.dart'; // Ensure you have added the intl package for date formatting
//import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// Assuming you have a Message class like this:
class Message {
  String senderId;
  String text;
  DateTime timestamp;
  String senderAvatar; // Add this line

  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.senderAvatar, // Add this line
  });
}

class ConversationPage extends StatefulWidget {
  final String jobTitle;
  final String chatName;
  final String chatImageAsset;
  final bool isOnline;

  ConversationPage({
    Key? key,
    required this.jobTitle,
    required this.chatName,
    required this.chatImageAsset,
    required this.isOnline,
  }) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  bool _isEmojiPickerVisible = false;
  final FocusNode _textFieldFocusNode = FocusNode();
  String currentUserId = 'yourCurrentUserId';
  String senderAvatar = 'assets/Ellipse 11.png';

  late List<Message> messages;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messages = [];
  }

  void onCallButtonPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CallPage(
          name: widget.chatName,
          title: widget.jobTitle,
          imageAsset: widget.chatImageAsset,
        ),
      ),
    );
  }

  void onVideoPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPage(
          name: widget.chatName,
          title: widget.jobTitle,
          imageAsset: widget.chatImageAsset,
        ), // Your VideoPage class
      ),
    );
  }

  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(Message(
          senderId:
              currentUserId, // Assurez-vous que c'est l'identifiant actuel de l'utilisateur
          text: text,
          timestamp: DateTime.now(),
          senderAvatar:
              senderAvatar, // Ajoutez le chemin vers l'image de l'avatar de l'expéditeur ici
        ));
        // Après avoir ajouté un message, vérifiez si le grand avatar doit être masqué.
      });
      _messageController.clear();

      // Si vous voulez défiler automatiquement vers le bas pour montrer le nouveau message :
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  bool isMenuOpen = false; // Suivi de l'état du menu
  OverlayEntry? _overlayEntry;
  void _showOptionsMenu() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Vérifie si le widget est toujours monté
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
        isMenuOpen = true;
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        right: 20,
        top: 150,
        width: 200,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _menuButton('View Contact'),
                _menuButton('Mute Notifications'),
                _menuButton('Clear Chat'),
                _menuButton('Report'),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    bool shouldShowLargeAvatar = messages.length < 4; // Example condition
    return Scaffold(
      backgroundColor: Color(0xFF28243D),
      body: Column(
        children: [
          _buildHeader(shouldShowLargeAvatar: shouldShowLargeAvatar),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];
                final bool isMe = message.senderId ==
                    currentUserId; // Replace with actual user ID
                return _buildMessage(message, isMe);
              },
            ),
          ),
          _buildInputSection(),
        ],
      ),
    );
  }

  // bool _showEmojiPicker = false;

  //void _toggleEmojiPicker() {
  // setState(() {
  // _showEmojiPicker = !_showEmojiPicker;
  // });
  // }

  Widget _buildInputSection() {
    final BorderRadius borderRadius = BorderRadius.circular(30.0);
    final double iconSize = 20.0; // Icon size for the emojis and other actions

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/barre_input.png"),
          fit: BoxFit.fill,
        ),
        borderRadius: borderRadius,
        border: Border.all(
          color: Colors.white, // White border color for contrast
          width: 1.0, // Border width
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode:
                  _textFieldFocusNode, // Ensure you have a FocusNode for the text field
              onTap: () {
                // When the text field is tapped, ensure the emoji picker is not shown
                setState(() {
                  // _showEmojiPicker = false;
                });
              },
              decoration: InputDecoration(
                hintText: "Message",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Image.asset('assets/emoji.png'),
                  onPressed: () {
                    // Check if the keyboard is already open
                    // if (_textFieldFocusNode.hasFocus) {
                    // If the keyboard is open, close it to show the emoji picker
                    // SystemChannels.textInput.invokeMethod('TextInput.hide');
                    // setState(() {
                    // _showEmojiPicker = true;
                    // });
                    //} else {
                    // If the keyboard is not open, request focus and open it
                    // _textFieldFocusNode.requestFocus();
                    // setState(() {
                    // _showEmojiPicker = false;
                    // });
                    //   }
                  },
                ),
              ),
            ),
          ),

          IconButton(
            iconSize: iconSize,
            icon: Image.asset('assets/photo.png'),
            onPressed: () {}, // Updated to call _pickImage
          ),

          IconButton(
            iconSize: iconSize,
            icon: Image.asset('assets/vocal.png'),
            onPressed: () {
              // Implement microphone functionality
            },
          ),
          // Send button
          IconButton(
            iconSize: iconSize,
            icon: Icon(
              Icons.send, // This uses the built-in send icon
              color: Colors.white, // Change the color as needed
            ),
            onPressed: _sendMessage, // Call your send message function
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message, bool isMe) {
    // Couleurs de la bulle de message
    Color messageBgColor = isMe ? Color(0xFFFFFFFF) : Color(0xFF937CC1);
    Color messageTextColor = isMe ? Color(0xFF28243D) : Color(0xFFFFFFFF);

    // Temps formaté
    String formattedTime = DateFormat('h:mm a').format(message.timestamp);

    // Création du widget d'avatar
    Widget avatarWidget = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        backgroundImage:
            AssetImage(message.senderAvatar), // Chemin vers l'image d'avatar
      ),
    );

    // Widget de la bulle de message
    Widget messageBubble = Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: messageBgColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: messageTextColor,
          fontSize: 16.0,
        ),
      ),
    );

    // Aligner l'avatar et la bulle de message dans un Row selon isMe
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          avatarWidget, // Si le message est reçu, placer l'avatar à gauche
        messageBubble,
        if (isMe)
          avatarWidget, // Si le message est envoyé, placer l'avatar à droite
        // Inclure un espace entre le message et l'avatar pour éviter le chevauchement
      ],
    );
  }

  Widget _menuButton(String text) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: EdgeInsets.all(16), // Padding for the button
        alignment: Alignment.centerLeft, // Align text to the left
        textStyle: TextStyle(fontSize: 16), // Text style
      ),
      onPressed: () {
        print('$text pressed');
        if (isMenuOpen) {
          _overlayEntry?.remove();
          _overlayEntry = null;
          isMenuOpen = false; // Mettre à jour l'état du menu
        }
      },
      child: Text(text),
    );
  }

  Widget _buildHeader({required bool shouldShowLargeAvatar}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double fem = screenWidth / 375; // Scaling factor for width
    final double ffem = screenHeight / 812; // Scaling factor for height
    final double arcHeight = 219 * fem;
    final double largeAvatarSize = 123 * fem;
    final double iconSize = 24 * fem;
    final double headerHeight = shouldShowLargeAvatar
        ? arcHeight + (largeAvatarSize / 2)
        : 60 * fem; // 60 is an arbitrary value for a smaller header

    return Container(
      height: headerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Arc background image
          if (shouldShowLargeAvatar)
            Positioned.fill(
              child: Image.asset(
                'assets/arc.png',
                fit: BoxFit.cover,
              ),
            ),
          // Row for small avatar, name, and icons
          Positioned(
            top:
                MediaQuery.of(context).padding.top, // Align with the status bar
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 20 * fem), // Horizontal margin
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Small avatar with online status indicator
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.isOnline)
                        CircleAvatar(
                          radius:
                              24 * fem, // Outer circle for the status indicator
                          backgroundColor: Colors.green,
                        ),
                      CircleAvatar(
                        radius: 20 * fem, // Actual avatar size
                        backgroundImage: AssetImage(widget.chatImageAsset),
                      ),
                    ],
                  ),
                  // Text for name and job title
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8 * fem),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.chatName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13 * fem,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.jobTitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12 * fem,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Icons for call, video, etc.

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/call.png',
                            width: iconSize, height: iconSize),
                        onPressed:
                            onCallButtonPressed, // Assuming this is defined somewhere
                      ),
                      IconButton(
                        icon: Image.asset('assets/video.png',
                            width: iconSize, height: iconSize),
                        onPressed:
                            onVideoPressed, // Assuming this is defined somewhere
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/3p.png',
                          width:
                              iconSize, // Define your iconSize variable somewhere
                          height: iconSize,
                        ),
                        onPressed:
                            _showOptionsMenu, // Call the method to show the menu
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Large avatar with the user's name below it
          if (shouldShowLargeAvatar)
            Positioned(
              top: arcHeight - (largeAvatarSize / 2),
              child: CircleAvatar(
                radius: largeAvatarSize / 2,
                backgroundImage: AssetImage(widget.chatImageAsset),
              ),
            ),

          // Conditionally display the user's name below the large avatar
          if (shouldShowLargeAvatar)
            Positioned(
              top:
                  arcHeight + (largeAvatarSize / 2) + 8, // Adjusted for spacing
              child: Text(
                widget.chatName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20 * ffem,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
