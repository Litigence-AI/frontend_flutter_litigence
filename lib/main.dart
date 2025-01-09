import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:lexmachina/src/authentication/sign_in_screen.dart';
// import '../chat_ui/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blog/blog_page.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'authentication/google_auth/google_auth_screen.dart';

import 'chat_ui/chat_page.dart';
import 'firebase_options.dart';
// import '/src/dashboard/dashboard.dart';
// import '/src/authentication/sign_up_screen.dart';
import '../onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  bool isOnboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  // bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

  bool isAuthenticated = true;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
  }

  runApp(MyApp(
    isOnboardingComplete: isOnboardingComplete,
    isAuthenticated: isAuthenticated,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isOnboardingComplete, required this.isAuthenticated});

  final bool isOnboardingComplete;
  final bool isAuthenticated;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String getInitialLocation(bool isOnboardingComplete, bool isAuthenticated) {
    if (isOnboardingComplete) {
      return isAuthenticated ? '/chatScreen' : '/gauth';
    } else {
      return '/';
    }
  }

  @override
  Widget build(BuildContext context) {

    // Define your GoRouter here
    final GoRouter _router = GoRouter(
    initialLocation: getInitialLocation(widget.isOnboardingComplete, widget.isAuthenticated),      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const OnboardScreen(),
        ),
        // GoRoute(
        //   path: '/dashboard',
        //   builder: (context, state) => const Dashboard(),
        // ),
        // GoRoute(
        //   path: '/signIn',
        //   builder: (context, state) => const SignIn(),
        // ),
        // GoRoute(
        //   path: '/signUp',
        //   builder: (context, state) => const SignUp(),
        // ),
        // GoRoute(path: '/gauth', builder: ( context, state ) => GoogleAuthScreen()),
        GoRoute(
          path: '/blog',
          builder: (context, state) => BlogPage(),
        ),
        GoRoute(
          path: '/chatScreen',
          builder: (context, state) => ChatPage(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Litigence AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme), // Apply the Inter font
        // TODO: Apply the Inter font offline
      ),
      routerConfig: _router, // Use router instead of routes
    );
  }
}
