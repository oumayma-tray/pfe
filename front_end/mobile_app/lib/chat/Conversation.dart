import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/chat/call.dart';
import 'package:mobile_app/chat/vedio.dart';
import 'package:intl/intl.dart'; // Ensure you have added the intl package for date formatting
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

enum MessageType { text, audio, file }

// Assuming you have a Message class like this:
class Message {
  String senderId;
  String text;
  DateTime timestamp;
  String senderAvatar; // Add this line
  String? audioPath;
  String? filePath;
  MessageType type;
  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.senderAvatar,
    this.audioPath, // Add this line
    this.type = MessageType.text,
    this.filePath,
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
  String? _selectedFilePath;
  bool _isFileSelected = false;

  late List<Message> messages;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    messages = [];
    initRecorder();
  }
// Import required for file handling

  void sendMessageWithAudio(String path) {
    File audioFile = File(path);

    // Create a new message object for the audio
    Message newMessage = Message(
      senderId: currentUserId,
      text: "",
      timestamp: DateTime.now(),
      senderAvatar: senderAvatar,
      type: MessageType.audio,
      audioPath: path,
    );
    setState(() {
      messages.add(newMessage);
    });

    // Optionally, upload the audio file to a server
    uploadAudioFile(audioFile);
  }

  Future<void> initRecorder() async {
    var hasPermission = await checkPermissions();
    if (!hasPermission) {
      print("Microphone permission not granted");
      return;
    }

    try {
      await _audioRecorder.openRecorder();
    } catch (e) {
      print("Failed to open the recorder: $e");
      return;
    }
  }

  Future<bool> checkPermissions() async {
    var status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

// Example placeholder function for uploading an audio file
  Future<void> uploadAudioFile(File audioFile) async {
    try {
      // Implementation of file upload
      // This can be done using various methods depending on how your backend is set up
      // For example, using HTTP multipart requests, Firebase Storage, etc.
      print("Audio file uploaded: ${audioFile.path}");
    } catch (e) {
      print("Failed to upload audio file: $e");
    }
  }

  Future<void> startRecording() async {
    try {
      await _audioRecorder.startRecorder(toFile: 'audio_message.aac');
    } catch (e) {
      print("Failed to start recording: $e");
      // Optionally, try to re-initialize the recorder if it fails to start
      await initRecorder();
      try {
        await _audioRecorder.startRecorder(toFile: 'audio_message.aac');
      } catch (e) {
        print("Second attempt to start recording failed: $e");
        // Handle further errors or notify the user as necessary
      }
    }
  }

  Future<void> stopRecordingAndSend() async {
    final String? path = await _audioRecorder.stopRecorder();
    if (path != null) {
      sendMessageWithAudio(path); // Only call this if path is not null
    } else {
      // Optionally handle the situation where no recording was captured
      print("Recording failed or was cancelled.");
    }
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

  Future<void> _pickMedia() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // To pick only images, change as needed
      );

      if (result != null) {
        setState(() {
          _selectedFilePath = result.files.single.path;
          _isFileSelected = true;
          _messageController.text =
              _selectedFilePath!.split('/').last; // Display file name in input
        });
      } else {
        // User canceled the picker
        setState(() {
          _isFileSelected = false;
        });
      }
    } catch (e) {
      print('Failed to pick file: $e');
    }
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
// Assume you have a variable to hold the picked file path
  String? pickedFilePath;

// A widget to display the picked file or image
  Widget displayPickedFile() {
    if (pickedFilePath == null) {
      return Text('No file selected');
    } else {
      return pickedFilePath!.endsWith('.jpg') ||
              pickedFilePath!.endsWith('.jpeg') ||
              pickedFilePath!.endsWith('.png') ||
              pickedFilePath!.endsWith('.gif')
          ? Image.file(File(pickedFilePath!))
          : ListTile(
              leading: Icon(Icons.file_present),
              title: Text(pickedFilePath!.split('/').last),
            );
    }
  }

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
            maxLines:
                null, // Allows the input field to expand to accommodate the text
            //softWrap: true, // Enables text wrapping
            keyboardType: TextInputType.multiline, // Allows for multiline input
            decoration: InputDecoration(
              hintText: "Type a message",
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              border: InputBorder.none,
              suffixIcon: IconButton(
                iconSize: iconSize,
                icon: Icon(Icons.attach_file),
                onPressed: _pickMedia,
              ),
              labelStyle: TextStyle(
                color: Colors.white, // Style the label text (e.g., color, size)
                overflow: TextOverflow
                    .ellipsis, // Add an ellipsis if the text overflows
              ),
            ),
          )),

          GestureDetector(
            onLongPressStart: (_) => startRecording(),
            onLongPressEnd: (_) => stopRecordingAndSend(),
            child: IconButton(
              iconSize: iconSize,
              icon: Image.asset('assets/vocal.png'),
              onPressed: null, // Disable the default press functionality
            ),
          ),
          IconButton(
            iconSize: iconSize,
            icon: Icon(
              Icons.send, // Uses the built-in send icon
              color: Colors.white, // Icon color
            ),
            onPressed: _sendMessage, // Triggers sending a message
          ),

          // Send button
        ],
      ),
    );
  }

  Widget _buildMessage(
    Message message,
    bool isMe,
  ) {
    Color messageBgColor = isMe ? Color(0xFFFFFFFF) : Color(0xFF937CC1);
    double maxWidth = MediaQuery.of(context).size.width *
        0.6; // Decrease the max width to make the bubble smaller

    Widget messageContent = SizedBox.shrink();
    switch (message.type) {
      case MessageType.audio:
        messageContent = Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: AudioPlayerWidget(audioPath: message.audioPath),
          ),
        );
        break;
      case MessageType.file:
        messageContent = Container(
          padding: EdgeInsets.all(8.0),
          constraints: BoxConstraints(maxWidth: maxWidth),
          decoration: BoxDecoration(
            color: isMe ? Colors.lightBlueAccent : Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_file), // Change the icon for non-audio files
              Expanded(
                child: Text(
                  message.filePath?.split('/').last ?? 'Unknown file',
                  softWrap: true,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                  // Allow for text to span up to 2 lines
                ),
              ),
              // You may want to conditionally show the duration for audio files
            ],
          ),
        );

      case MessageType.text:
      default:
        messageContent = Text(
          message.text,
          style: TextStyle(
            color: isMe ? Color(0xFF28243D) : Color(0xFFFFFFFF),
            fontSize: 16,
          ),
        );
        break;
    }

    Widget avatarWidget = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        backgroundImage: AssetImage(message.senderAvatar),
      ),
    );

    Widget messageBubble = Container(
      margin: EdgeInsets.symmetric(
          vertical: 4.0, horizontal: 8.0), // Adjust margins as needed
      padding: EdgeInsets.symmetric(
          horizontal: 12.0, vertical: 8.0), // Adjust padding as needed
      decoration: BoxDecoration(
        color: messageBgColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: messageContent,
    );

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (!isMe) avatarWidget,
        messageBubble,
        if (isMe) avatarWidget,
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

    _audioRecorder.closeRecorder();

    super.dispose();
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String? audioPath;

  AudioPlayerWidget({Key? key, this.audioPath}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    // Updated to use the correct API for position updates
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
      });
    });
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // Check if the audio file exists
      final file = File(widget.audioPath!);
      if (await file.exists()) {
        // File exists, play the audio
        await _audioPlayer.play(DeviceFileSource(file.path));
      } else {
        // File does not exist, handle the error
        print('Audio file does not exist at path: ${widget.audioPath}');
        // You might want to show an alert or a message to the user
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set the height of the play button and slider thumb to fit within the 50 pixels.
    final double buttonHeight = 30.0;
    final double sliderHeight =
        20.0; // Adjust as needed to fit within 50px height

    return Container(
      height: 50.0, // Container height fixed at 50 pixels
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2.0, // Adjust track height to be smaller
                thumbShape:
                    RoundSliderThumbShape(enabledThumbRadius: sliderHeight / 2),
              ),
              child: Slider(
                value: _position.inSeconds.toDouble(),
                min: 0.0,
                max: _duration.inSeconds.toDouble(),
                onChanged: (value) {
                  final newPosition = Duration(seconds: value.toInt());
                  _audioPlayer.seek(newPosition);
                  setState(() {
                    _position = newPosition;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: buttonHeight,
                onPressed: _togglePlay,
              ),
              SizedBox(
                  width: 8.0), // Provides spacing between the button and text
              Text(formatDuration(_position)),
              Text(' / '),
              Text(formatDuration(_duration)),
            ],
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }
}
