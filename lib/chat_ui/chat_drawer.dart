import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({Key? key}) : super(key: key);

  // Static chat history for now
  final List<Map<String, String>> _chatHistory = const [
    {'title': 'Trial Spawner Loot Reuse'},
    {'title': 'Samsung M21 NFC Support'},
    {'title': 'How to Record Meet'},
    {'title': 'Sleeping Pills Side Effects'},
    {'title': 'Trial Spawner Loot Reuse'},
    {'title': 'Samsung M21 NFC Support'},
    {'title': 'How to Record Meet'},
    {'title': 'Sleeping Pills Side Effects'},
    {'title': 'Trial Spawner Loot Reuse'},
    {'title': 'Samsung M21 NFC Support'},
    {'title': 'How to Record Meet'},
    {'title': 'Sleeping Pills Side Effects'},
    {'title': 'Trial Spawner Loot Reuse'},
    {'title': 'Samsung M21 NFC Support'},
    {'title': 'How to Record Meet'},
    {'title': 'Sleeping Pills Side Effects'},
  ];

  // Logout handler
  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully!')),
        );
        context.go('/authScreen');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Removes all corner rounding
      ),
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
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    )),
                Spacer(),
                SvgPicture.asset(
                  'assets/chat/add_note.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Static chat history list
                ..._chatHistory.map((chat) => ListTile(
                      title: Text(chat['title']!),
                      onTap: () {
                        // Placeholder for chat selection logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Selected chat: ${chat['title']}')),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          // Logout button
          ListTile(
            title: const Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }
}














// import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../utils/helpers.dart';

// class ChatDrawer extends StatelessWidget {
//   // final List<Map<String, dynamic>> chatTitles; // List of chat titles
//   // final bool isLoading; // Whether titles are loading
//   // final ValueChanged<String> onChatSelected; // Callback for chat selection

//   const ChatDrawer({
//     Key? key,
//     // required this.chatTitles,
//     // required this.isLoading,
//     // required this.onChatSelected,
//   }) : super(key: key);

//   Future<void> signOutGoogle() async {

//     final _googleSignIn = GoogleSignIn(scopes: ['email']);

//     await _googleSignIn.signOut();
//     await FirebaseAuth.instance.signOut();
//   }

//   // Create a method to handle logout
//   Future<void> _handleLogout(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       await FirebasePhoneAuthHandler.signOut(context);

//       // Show success message
//       if (context.mounted) {
//         showSnackBar('Logged out successfully!');
//       }

//       context.go('/authScreen');

//       // No need to manually navigate - the router will handle it
//       // because the auth state will change automatically
//     } catch (e) {
//       if (context.mounted) {
//         showSnackBar('Error logging out: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration:
//                 BoxDecoration(color: Theme.of(context).colorScheme.primary),
//             child: const Text(
//               'Litigence AI',
//               style: TextStyle(color: Colors.white, fontSize: 24),
//             ),
//           ),
//           // if (isLoading)
//           //   const LinearProgressIndicator() // Show loading indicator
//           // else
//           //   ...chatTitles.map(

//           //     (chatTitleData) => ListTile(
//           //         title: Text(chatTitleData['title']),
//           //         onTap: () {
//           //           Navigator.pop(context); // Close drawer
//           //           onChatSelected(chatTitleData['title']); // Trigger callback
//           //         },
//           //       )),
//           const Divider(),
//           ListTile(title: const Text('Home')),
//           ListTile(title: const Text('Settings')),
//           ListTile(title: const Text('About')),
//           const Divider(),
//           ListTile(
//             title: const Text('Logout'),
//             leading: const Icon(Icons.logout),
//             onTap: () => _handleLogout(context),
//           ),
//         ],
//       ),
//     );
//   }
// }
