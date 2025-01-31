import 'package:Litigence/chat_ui/chat_drawer.dart';
// import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
import '../services/gemini_service.dart';
// import '../utils/helpers.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat_ui/firestore_operations.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController

  final GeminiService _geminiService = GeminiService();
  List<Map<String, String>> _messages = [];
  bool _isGeminiInitialized = false;
  bool _isTyping = false;
  String _currentChatTitle =
      "Default Chat"; // Example chat title - make dynamic later
  // List<Map<String, dynamic>> _chatTitles = []; // List to hold chat titles
  // bool _isLoadingTitles = false;

  bool _isNewChat = false; // Tracks if it's the first message in a new chat

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    // _loadChatTitles(); // Load chat titles on page load
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose(); // Dispose ScrollController
    super.dispose();
  }

  Future<void> _initializeGemini() async {
    try {
      await _geminiService.initialize();
      setState(() => _isGeminiInitialized = true);
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> _sendMessage([String? predefinedMessage]) async {
    if ((!_controller.text.isEmpty || predefinedMessage != null) &&
        _isGeminiInitialized) {
      final userMessage = predefinedMessage ?? _controller.text;
      setState(() {
        _messages.add({'role': 'user', 'message': userMessage});
        _isTyping = true;
        _controller.clear();
      });

      // Scroll to bottom after sending user message
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      try {
        final aiResponse = await _geminiService.sendMessage(userMessage);
        if (aiResponse != null) {
          setState(() => _messages.add({'role': 'ai', 'message': aiResponse}));

          // Scroll to bottom after receiving AI response
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToBottom());

          // Call the modularized Firestore saving function
          await saveChatMessageToFirestore(
            chatTitle: _currentChatTitle,
            userMessage: userMessage,
            aiResponse: aiResponse,
          );
        }
      } catch (e) {
        setState(() => _messages.add({'role': 'ai', 'message': 'Error: $e'}));
      } finally {
        setState(() => _isTyping = false);
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'Litigence AI',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset(
              'assets/chat/sidebar.svg', // Replaces Icons.menu_pounded
              width: 24, // Adjust size as needed
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/chat/add_note.svg', // Replaces Icons.logout (adjust based on your use case)
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
            ),
            onPressed: () async {
              setState(() {
                _messages.clear();                
              });
              _isNewChat = true;
            },
          ),
        ],
      ),
      drawer: ChatDrawer(
          // chatTitles: _chatTitles,
          // isLoading: _isLoadingTitles,
          // onChatSelected: (selectedTitle) => _loadChatMessages(selectedTitle), // Pass callback
          ),
      body: Column(
        children: [
          if (_messages.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Law of the Day',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        _sendMessage(
                            'Explain Article 21 of Indian Constitution in detail');
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Text(
                          'Article 21: Protection of Life and Personal Liberty - No person shall be deprived of his life or personal liberty except according to procedure established by law.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_messages.isNotEmpty)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ListTile(
                    title: Text(
                      message['message']!,
                      style: TextStyle(
                        color: message['role'] == 'user'
                            ? Colors.blue
                            : Colors.green,
                      ),
                    ),
                    subtitle: Text(
                        message['role'] == 'user' ? 'You' : 'AI Assistant'),
                  );
                },
              ),
            ),
          if (_isTyping) const LinearProgressIndicator(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: KeyboardListener(
                    // Wrap TextField with RawKeyboardListener
                    focusNode: FocusNode(), // Create a FocusNode
                    onKeyEvent: (KeyEvent event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.enter) {
                        _sendMessage();
                      }
                    },
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Message Litigence AI',
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.6),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




// Future<void> _loadChatTitles() async {
//   setState(() {
//     _isLoadingTitles = true;
//     _chatTitles.clear(); // Clear existing titles
//   });

//   try {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     String? userId = currentUser?.uid;

//     if (userId == null) {
//       print("Error: User not logged in. Cannot load chat titles.");
//       return;
//     }

//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('chat_history')
//         .doc(userId)
//         .collection('user_chats')
//         .orderBy('last_updated', descending: true)
//         .limit(10) // Load only top 10 titles initially
//         .get();

//     List<Map<String, dynamic>> fetchedChatTitles = querySnapshot.docs
//         .map((doc) => {
//               'title': doc.get('title') as String,
//               'last_updated': (doc.get('last_updated') as Timestamp).toDate(),
//               // Add other metadata you want to display in the title list
//             })
//         .toList();

//     setState(() {
//       _chatTitles.addAll(fetchedChatTitles);
//     });
//   } catch (e) {
//     print("Error loading chat titles: $e");
//     // Handle error (e.g., show an error message)
//   } finally {
//     setState(() {
//       _isLoadingTitles = false;
//     });
//   }
// }

// Future<void> _loadChatMessages(String chatTitle) async {
//   setState(() {
//     _messages.clear(); // Clear existing messages
//     _isTyping = true; // Show loading indicator
//     _currentChatTitle = chatTitle;
//   });

//   try {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     String? userId = currentUser?.uid;

//     if (userId == null) {
//       print("Error: User not logged in. Cannot load chat history.");
//       return; // Or handle error appropriately
//     }

//     DocumentSnapshot chatSessionDoc = await FirebaseFirestore.instance
//         .collection('chat_history')
//         .doc(userId)
//         .collection('user_chats')
//         .doc(chatTitle)
//         .get();

//     if (chatSessionDoc.exists) {
//       List<dynamic> messagesFromFirestore = chatSessionDoc.get('messages');
//       // Cast to List<Map<String, String>>
//       List<Map<String, String>> fetchedMessages = messagesFromFirestore
//           .map((message) => {
//                 'role': message['role'] as String,
//                 'message': message['message'] as String,
//               })
//           .toList();

//       setState(() {
//         _messages.addAll(fetchedMessages);
//       });
//     }
//   } catch (e) {
//     print("Error loading chat history: $e");
//     // Handle error (e.g., show a snackbar or an error message)
//   } finally {
//     setState(() {
//       _isTyping = false; // Hide loading indicator
//     });
//   }
// }
