import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  final String name;
  final String title;
  final String imageAsset;

  VideoPage({
    Key? key,
    required this.name,
    required this.title,
    required this.imageAsset,
  }) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  double iconSize = 48; // Adjust based on your design

  void onMutePressed() {
    // Mute logic here
  }

  void onKeyboardPressed() {
    // Keyboard logic here
  }

  void onVideoPressed() {
    // Video logic here
  }

  void onHangupPressed() {
    // Hang up logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Ensure Stack fills the screen
        children: [
          // Background image for video call
          Image.asset(
            widget.imageAsset,
            fit: BoxFit.cover, // Cover the entire screen
          ),
          // Name tag container at the top right
          Positioned(
            top: 16.0, // Distance from the top of the screen
            right: 16.0, // Distance from the right of the screen
            child: Container(
              width: 156.0, // Width of the name tag
              height: 29.0, // Height of the name tag
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/R_nom.png"), // Your name tag background image
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(
                    4), // Adjust if you want rounded corners
              ),
              alignment: Alignment.center,
              child: Text(
                widget.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14, // Adjust font size as needed
                ),
              ),
            ),
          ),
          // Bottom bar with action buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 321.0, // Width of the bottom bar
              height: 62.0, // Height of the bottom bar
              margin: const EdgeInsets.only(
                  bottom:
                      12.0), // Adjust the distance from the bottom as needed
              decoration: BoxDecoration(
                // Add your image, color, or gradient here
                image: DecorationImage(
                  image: AssetImage("assets/Rectangle 7.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    BorderRadius.circular(12), // Optional, for rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceAround, // Align buttons with equal spacing
                children: <Widget>[
                  IconButton(
                    icon: Image.asset('assets/mute.png'),
                    iconSize: iconSize,
                    onPressed: onMutePressed,
                  ),
                  IconButton(
                    icon: Image.asset('assets/vocal.png'),
                    iconSize: iconSize,
                    onPressed: onKeyboardPressed,
                  ),
                  IconButton(
                    icon: Image.asset('assets/video.png'),
                    iconSize: iconSize,
                    onPressed: onVideoPressed,
                  ),
                  IconButton(
                    icon: Image.asset('assets/R_button.png'),
                    iconSize: iconSize,
                    onPressed: onHangupPressed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
