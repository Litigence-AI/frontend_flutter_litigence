import 'package:Litigence/authentication/auth_screen.dart';
import 'package:Litigence/otp_auth/otp_auth_screen.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_ui/chat_page.dart';
import 'firebase_options.dart';
import '../onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

import 'otp_auth/home_screen.dart';
import 'otp_auth/splash_screen.dart';
import 'otp_auth/verify_phone_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  bool isOnboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

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
  const MyApp(
      {super.key,
      required this.isOnboardingComplete,
      required this.isAuthenticated});

  final bool isOnboardingComplete;
  final bool isAuthenticated;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String getInitialLocation(bool isOnboardingComplete, bool isAuthenticated) {
    if (isOnboardingComplete) {
      return isAuthenticated ? '/chatScreen' : '/authScreen';
      // TODO: revert to chatScreen after otp test
    } else {
      return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define your GoRouter here
    final GoRouter _router = GoRouter(
      // initialLocation: getInitialLocation(
      //     widget.isOnboardingComplete, widget.isAuthenticated),
      initialLocation: '/splashScreen',
      debugLogDiagnostics: true,
      // TODO: Remove DebugLogs
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const OnboardScreen(),
        ),
        GoRoute(
          path: '/chatScreen',
          // builder: (context, state) => ChatPage(),
          builder: (context, state) => const ChatPage(),
        ),
        GoRoute(
          path: '/authScreen',
          builder: (context, state) => AuthScreen(),
        ),
        GoRoute(path: '/otpAuthScreen', builder: (context, state) => OtpAuth()),
        GoRoute(
          path: '/verifyPhoneNumberScreen',
          builder: (context, state) => VerifyPhoneNumberScreen(
            phoneNumber: state.extra as String,
          ),
        ),
        GoRoute(
          path: '/homeScreen',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(path: '/splashScreen',
             builder: (context, state) => SplashScreen(),
            ),
      ],
    );

    return FirebasePhoneAuthProvider(
      child: MaterialApp.router(
        title: 'Litigence AI',
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          textTheme: ThemeData.dark(useMaterial3: true).textTheme.apply(
                fontFamily: 'Roboto',
              ),
          primaryTextTheme: const TextTheme().apply(
            fontFamily: 'Roboto',
          ),
        ),
        routerConfig: _router, // Use router instead of routes
      ),
    );
  }
}

