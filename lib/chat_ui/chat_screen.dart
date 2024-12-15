import 'package:flutter/material.dart';
import '../services/nvdia_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _messages = [];

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _messages.add("Thinking...");
        _controller.clear();
      });
      _scrollToBottom();

      try {
        String response = await sendMessage(_controller.text);
        setState(() {
          _messages.removeLast(); // Remove "Thinking..." message
          _messages.add(response);
        });
      } catch (e) {
        setState(() {
          _messages.removeLast(); // Remove "Thinking..." message
          _messages.add("An error occurred: $e");
        });
      }
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Multimodal AI Chat"),
      ),
      body: Column(
        children: [
          // Message display area
          Expanded(
            child: Container(
              color: Colors.grey[200], // Optional: background color for the messages area
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
          ),
          // Message input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
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