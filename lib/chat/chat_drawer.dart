import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // For storing user ID

class ChatDrawer extends StatefulWidget {
  const ChatDrawer({super.key});

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  late Future<List<Map<String, dynamic>>> _chatTitles;

  @override
  void initState() {
    super.initState();
    _chatTitles = _fetchChatTitles();
  }

  String backendUrl = const String.fromEnvironment('BACKEND_URL', defaultValue: 'https://default-backend-url.com');

  Future<List<Map<String, dynamic>>> _fetchChatTitles() async {
    // Get user ID from SharedPreferences (replace with your auth solution)
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getString('user_id');

    const String userId = 'user123';

    // if (userId == null) {
    //   throw Exception('User not logged in');
    // }

    final response = await http.get(
      Uri.parse('$backendUrl/chat_titles?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(data['chat_titles']);
      } else {
        throw Exception(data['error'] ?? 'Failed to load chat titles');
      }
    } else {
      throw Exception('Failed to connect to server: ${response.statusCode}');
    }
  }

  Future<void> _refreshChatTitles() async {
    setState(() {
      _chatTitles = _fetchChatTitles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    'assets/chat/sidebar.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Handle new chat creation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Creating new chat')),
                    );
                    // Add new chat functionality here
                  },
                  child: SvgPicture.asset(
                    'assets/chat/add_note.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshChatTitles,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _chatTitles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${snapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshChatTitles,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No chats found. Create your first chat!'),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final chat = snapshot.data![index];
                      return ListTile(
                        title: Text(chat['title'] ?? 'Untitled Chat'),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selected chat: ${chat['title']}'),
                            ),
                          );
                          Navigator.pop(context);
                          // Add navigation to specific chat here using chat['id']
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              // Implement logout functionality
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logging out...')));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
