import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gene/pages/blog/blog_page.dart';
import 'package:gene/pages/dashboard/chat_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:gene/pages/dashboard/dashboard.dart';
import 'package:gene/pages/authentication/sign_in_screen.dart';
import 'package:gene/pages/authentication/sign_up_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/dashboard': (context) => const Dashboard(),
        '/signUp': (context) => const SignUp(),
        '/signIn': (context) => const SignUp(),
        '/blog': (context) =>  BlogPage(),
      },
      title: 'Gen-E',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme), // Apply the Inter font
        // TODO: Apply the Inter font offline
      ),
      home: const ChatScreen(),
    );
  }
}
