// import 'package:Litigence/utils/helpers.dart';
// import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:go_router/go_router.dart';
// // import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

// import '../models/chat_users.dart';
// import '../services/gemini_service.dart';
// import '../widgets/chat_typing_indicator.dart';
// // import '../utils/file_handlers.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final List<types.Message> _messages = [];
//   final GeminiService _geminiService = GeminiService();
//   bool _isAITyping = false;
//   bool _isGeminiInitialized = false;
//   String? _initError;

//   @override
//   void initState() {
//     super.initState();
//     _initializeGemini();
//   }

//   Future<void> _initializeGemini() async {
//     int retryCount = 0;
//     const int maxRetries = 10;
//     const Duration retryDelay = Duration(seconds: 2);

//     while (retryCount < maxRetries) {
//       try {
//         await _geminiService.initialize();
//         setState(() => _isGeminiInitialized = true);
//         return;
//       } catch (e) {
//         retryCount++;
//         if (retryCount >= maxRetries) {
//           setState(() => _initError =
//               '$e Failed to initialize after $maxRetries attempts.');
//           print('Initialization error: $e');
//         } else {
//           await Future.delayed(retryDelay);
//         }
//       }
//     }
//   }

//   void _handleAttachmentPressed() {
//     showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) => SafeArea(
//         child: SizedBox(
//           height: 144,
//           child: Column(
//             children: <Widget>[
//               ListTile(
//                 leading: const Icon(Icons.photo),
//                 title: const Text('Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // _handleImageSelection();
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.attach_file),
//                 title: const Text('File'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // _handleFileSelection();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // void _handleFileSelection() async {
//   //   final result = await FileHandlers.handleFileSelection(ChatUsers.currentUser);
//   //   if (result != null) {
//   //     setState(() => _messages.insert(0, result));
//   //   }
//   // }
//   //
//   // void _handleImageSelection() async {
//   //   final result = await FileHandlers.handleImageSelection(ChatUsers.currentUser);
//   //   if (result != null) {
//   //     setState(() => _messages.insert(0, result));
//   //   }
//   // }

//   void _handleMessageTap(BuildContext _, types.Message message) async {
//     if (message is types.FileMessage) {
//       // Handle file message tap
//     }
//   }

//   void _handlePreviewDataFetched(
//     types.TextMessage message,
//     types.PreviewData previewData,
//   ) {
//     final index = _messages.indexWhere((element) => element.id == message.id);
//     final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
//       previewData: previewData,
//     );

//     setState(() {
//       _messages[index] = updatedMessage;
//     });
//   }

//   void _handleSendPressed(types.PartialText message) async {
//     final textMessage = types.TextMessage(
//       author: ChatUsers.currentUser,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       text: message.text,
//     );

//     setState(() {
//       _messages.insert(0, textMessage);
//       _isAITyping = true;
//     });

//     try {
//       final response = await _geminiService.sendMessage(message.text);
//       if (response != null) {
//         final aiMessage = types.TextMessage(
//           author: ChatUsers.aiUser,
//           createdAt: DateTime.now().millisecondsSinceEpoch,
//           id: DateTime.now().millisecondsSinceEpoch.toString(),
//           text: response,
//         );
//         setState(() => _messages.insert(0, aiMessage));
//       }
//     } finally {
//       setState(() => _isAITyping = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isGeminiInitialized) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Indian Legal AI Assistant'),
//         ),
//         body: Center(
//           child: _initError != null
//               ? Text('Error: $_initError')
//               : const CircularProgressIndicator(),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Indian Legal AI Assistant'),
//         bottom: _isAITyping
//             ? const PreferredSize(
//                 preferredSize: Size.fromHeight(4.0),
//                 child: LinearProgressIndicator(),
//               )
//             : null,
//         leading: Builder(
//           builder: (context) {
//             return IconButton(
//               icon: const Icon(Icons.menu),
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             );
//           },
//         ),
//       ),
//       drawer: Drawer(
//         // Add a ListView to the drawer. This ensures the user can scroll
//         // through the options in the drawer if there isn't enough vertical
//         // space to fit everything.
//         child: ListView(
//           // Important: Remove any padding from the ListView.
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text('Drawer Header'),
//             ),
//             ListTile(title: Text('Home')),
//             ListTile(title: Text('Home1')),
//             ListTile(title: Text('Home2')),
//             ElevatedButton(

//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
//                 ),

//                 onPressed : () async {
//                   await FirebasePhoneAuthHandler.signOut(context);
//                   showSnackBar('Logged out successfully!');

//                   if (context.mounted) {
//                     context.go('/authScreen');
//                   }
//                 },
//                 child: const Text('Logout'),
//               ),
//           ],
//         ),
//       ),
//       body: Chat(
//         messages: _messages,
//         onAttachmentPressed: _handleAttachmentPressed,
//         onMessageTap: _handleMessageTap,
//         onPreviewDataFetched: _handlePreviewDataFetched,
//         onSendPressed: _handleSendPressed,
//         showUserAvatars: true,
//         showUserNames: true,
//         user: ChatUsers.currentUser,
//         customBottomWidget: _isAITyping ? const ChatTypingIndicator() : null,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final List<Map<String, String>> _messages = [];
  bool _isGeminiInitialized = false;
  bool _isTyping = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  Future<void> _initializeGemini() async {
    try {
      await _geminiService.initialize();
      setState(() => _isGeminiInitialized = true);
    } catch (e) {
      setState(() => _initError = e.toString());
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty || !_isGeminiInitialized) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add({'role': 'user', 'message': userMessage});
      _isTyping = true;
      _controller.clear();
    });

    try {
      final aiResponse = await _geminiService.sendMessage(userMessage);
      if (aiResponse != null) {
        setState(() => _messages.add({'role': 'ai', 'message': aiResponse}));
      }
    } catch (e) {
      setState(() => _messages.add({'role': 'ai', 'message': 'Error: $e'}));
    } finally {
      setState(() => _isTyping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isGeminiInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text("Custom Chat")),
        body: Center(
          child: _initError != null
              ? Text('Initialization Failed: $_initError')
              : const CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Custom Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(
                    message['message']!,
                    style: TextStyle(
                      color:
                          message['role'] == 'user' ? Colors.blue : Colors.green,
                    ),
                  ),
                  subtitle:
                      Text(message['role'] == 'user' ? 'You' : 'AI Assistant'),
                );
              },
            ),
          ),
          if (_isTyping) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: "Type your message..."),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
