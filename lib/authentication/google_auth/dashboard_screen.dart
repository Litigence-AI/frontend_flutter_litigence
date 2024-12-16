// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'google_auth_screen.dart';
//
// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               await GoogleSignIn().signOut();
//
//               if (context.mounted) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AuthScreen()),
//                 );
//               }
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (user != null) ...[
//               CircleAvatar(
//                 radius: 40,
//                 backgroundImage: NetworkImage(user.photoURL ?? ''),
//               ),
//               const SizedBox(height: 10),
//               Text('Name: ${user.displayName ?? ""}'),
//               Text('Email: ${user.email ?? ""}'),
//             ] else
//               const Text('No user signed in'),
//           ],
//         ),
//       ),
//     );
//   }
// }
