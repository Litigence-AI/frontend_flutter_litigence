import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/gemini_service.dart';
import '../utils/helpers.dart';

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
            appBar: AppBar(
        title: const Text('Indian Legal AI Assistant'),
        bottom: _isTyping
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4.0),
                child: LinearProgressIndicator(),
              )
            : null,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(title: Text('Home')),
            ListTile(title: Text('Home1')),
            ListTile(title: Text('Home2')),
            ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
                ),

                onPressed : () async {
                  await FirebasePhoneAuthHandler.signOut(context);
                  showSnackBar('Logged out successfully!');

                  if (context.mounted) {
                    context.go('/authScreen');
                  }
                },
                child: const Text('Logout'),
              ),
          ],
        ),
      ),
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
