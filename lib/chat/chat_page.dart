import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/gemini_service.dart';
import 'chat_drawer.dart';
import '../chat/chat_input_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService();
  List<Map<String, String>> _messages = [];
  bool _isGeminiInitialized = false;
  bool _isTyping = false;
  String _currentChatTitle = "Default Chat";
  bool _isNewChat = false;
  bool _isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _controller.addListener(() {
      setState(() {
        _isTextEmpty = _controller.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeGemini() async {
    try {
      await _geminiService.initialize();
      setState(() {
        _isGeminiInitialized = true;
      });
    } catch (e) {
      print("Error initializing Gemini Service: $e");
    }
  }

  Future<void> _sendMessage([String? predefinedMessage]) async {
    if (((_controller.text.isNotEmpty) || predefinedMessage != null) &&
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
          setState(() {
            _messages.add({'role': 'ai', 'message': aiResponse});
          });
          // Scroll to bottom after receiving the AI response
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );
        }
      } catch (e) {
        setState(() {
          _messages.add({'role': 'ai', 'message': 'Error: $e'});
        });
      } finally {
        setState(() {
          _isTyping = false;
        });
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
          builder:
              (context) => IconButton(
                icon: SvgPicture.asset(
                  'assets/chat/sidebar.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/chat/add_note.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
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
      drawer: const ChatDrawer(),
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
                          'Explain Article 21 of Indian Constitution in detail',
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
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
                        color:
                            message['role'] == 'user'
                                ? Colors.blue
                                : Colors.green,
                      ),
                    ),
                    subtitle: Text(
                      message['role'] == 'user' ? 'You' : 'AI Assistant',
                    ),
                  );
                },
              ),
            ),
          if (_isTyping) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Colors.grey, // Adds a grey border
                  width: 1.0, // Border thickness
                ),
                borderRadius: BorderRadius.circular(30), // Adds rounded corners
              ),
              child: ChatInputBar(
                controller: _controller,
                isTextEmpty: _isTextEmpty,
                sendMessage: _sendMessage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
