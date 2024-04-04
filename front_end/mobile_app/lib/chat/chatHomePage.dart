import 'package:flutter/material.dart';
import 'package:haroun/chat/Conversation.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  int? selectedChatIndex;
  final TextEditingController searchController = TextEditingController();
  List<ChatEntry> chats = [
    // Add your initial list of chat entries here
    ChatEntry(
        "Frontend Developer",
        'Joaquina Weisenborn',
        'lorem ipsum lorem ipsum lorem ipsum',
        'assets/Ellipse 10.png',
        true,
        MessageStatus.read),
    ChatEntry(
        "Frontend Developer",
        'Felecia Rower',
        'lorem ipsum lorem ipsum lorem ipsum',
        'assets/Ellipse 11.png',
        false,
        MessageStatus.received),
    ChatEntry(
        "Frontend Developer",
        'Sal Piggee',
        'lorem ipsum lorem ipsum lorem ipsum',
        'assets/Ellipse 12.png',
        true,
        MessageStatus.sent),
    ChatEntry(
        "Frontend Developer",
        'Verla Morgano',
        'lorem ipsum lorem ipsum lorem ipsum',
        'assets/Ellipse 13.png',
        true,
        MessageStatus.sent),
    ChatEntry(
        "Frontend Developer",
        'Mauro Elenbaas',
        'lorem ipsum lorem ipsum lorem ipsum',
        'assets/Ellipse 14.png',
        true,
        MessageStatus.sent),
    ChatEntry(
        "Frontend Developer",
        'Miguel Guelff',
        'lorem ipsum lorem ipsum lorem ipsum',
        'assets/Ellipse 15.png',
        true,
        MessageStatus.sent),
    // Add more ChatEntry instances as needed
  ];
  List<ChatEntry> filteredChats = [];

  @override
  void initState() {
    super.initState();
    filteredChats = chats; // Start with all chats visible
    searchController.addListener(() {
      setState(() {
        filteredChats = chats
            .where((chat) =>
                chat.name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                chat.message
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHAT',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 32.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF9155FD), Color(0xFFC5A5FE)],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'assets/Sans-titre-61 .png', // Assurez-vous que le chemin est correct
              width: 22,
              height: 22,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF28243D), // Set the background color here

      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0), // Reduced vertical padding
            child: TextField(
              controller: searchController,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14), // Optional: adjust font size if necessary
              decoration: InputDecoration(
                hintText: 'Search (Ctrl+/)',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search,
                    color: Colors.white,
                    size: 20), // Adjust icon size if necessary
                filled: true,
                fillColor: Color(0xFF312D4B),
                contentPadding: EdgeInsets.symmetric(
                    vertical:
                        10.0), // Adjust content padding to reduce field height
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  // Padding for each chat item
                  child: ChatItemWidget(
                    chat: filteredChats[index],
                    isSelected: selectedChatIndex == index,
                    onSelect: () {
                      setState(() {
                        selectedChatIndex =
                            selectedChatIndex == index ? null : index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class ChatEntry {
  String jobTitle;
  String name;
  String message;
  String avatarPath;
  bool isOnline;
  MessageStatus messageStatus;

  ChatEntry(this.jobTitle, this.name, this.message, this.avatarPath,
      this.isOnline, this.messageStatus);
}

enum MessageStatus {
  sent, // Message sent but not received
  received, // Message received but not read
  read, // Message read
}

void navigateToConversation(BuildContext context, ChatEntry chatEntry) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ConversationPage(
        jobTitle: chatEntry.jobTitle,
        chatName: chatEntry.name,
        chatImageAsset: chatEntry.avatarPath,
        isOnline:
            chatEntry.isOnline, //// Pass the chatId to the conversation page
        // Add any other arguments you need for the ConversationPage constructor
      ),
    ),
  );
}

class ChatItemWidget extends StatelessWidget {
  final ChatEntry chat;
  final bool isSelected;
  final VoidCallback onSelect;

  const ChatItemWidget({
    Key? key,
    required this.chat,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);
  Widget _buildMessageStatusIcon(BuildContext context, MessageStatus status) {
    List<Widget> icons;

    switch (status) {
      case MessageStatus.sent:
        icons = [
          Image.asset('assets/now hiring! - 2023-10-26T234739 4.png',
              width: 21, height: 15),
        ];
        break;
      case MessageStatus.received:
        icons = [
          Image.asset('assets/now hiring! - 2023-10-26T234739 4.png',
              width: 21, height: 15),
          Positioned(
            top: 2, // No vertical space between icons.
            child: Image.asset('assets/now hiring! - 2023-10-26T234739 4.png',
                width: 27, height: 19),
          ),
        ];
        break;
      case MessageStatus.read:
        icons = [
          Image.asset('assets/now hiring! - 2023-10-26T234739 9.png',
              width: 21, height: 15),
          Positioned(
            top: 2, // No vertical space between icons.
            child: Image.asset('assets/now hiring! - 2023-10-26T234739 9.png',
                width: 27, height: 19),
          ),
        ];
        break;
      default:
        icons = []; // Default case to return an empty placeholder.
    }

    return Container(
      padding: EdgeInsets.all(4.0),
      constraints: BoxConstraints(
        maxWidth:
            MediaQuery.of(context).size.width * 0.15, // Set a maximum width
        maxHeight: 40.0, // Set a maximum height if necessary
      ),
      child: Stack(
        alignment: Alignment.center,
        children: icons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToConversation(context, chat),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF9155FD)
              : Color(0xFF312D4B), // Color changes based on selection
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(chat.avatarPath),
              ),
              if (chat.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset('assets/Rect-green.png',
                      width: 15, height: 15),
                ),
            ],
          ),
          title: Text(chat.name, style: TextStyle(color: Colors.white)),
          subtitle: Text(chat.message,
              style: TextStyle(color: Colors.white.withOpacity(0.6))),
          trailing: _buildMessageStatusIcon(context, chat.messageStatus), //
          // The rest of your ListTile
        ),
      ),
    );
  }
}
