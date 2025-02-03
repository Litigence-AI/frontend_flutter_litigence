
import 'package:Litigence/authentication/auth_screen.dart';
import 'package:Litigence/authentication/otp_auth/otp_auth_screen.dart';
import 'package:Litigence/utils/globals.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat_ui/chat_page.dart';
import 'firebase_options.dart';
import 'onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';
import 'authentication/otp_auth/verify_phone_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For User type.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
  }

  runApp(
    ProviderScope(
      child: FirebasePhoneAuthProvider(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the onboarding state from our mutable provider.
    final isOnboardingComplete = ref.watch(onboardingCompleteProvider);

    // Also watch the Firebase auth status.
    final firebaseUserAsync = ref.watch(firebaseUserProvider);
    final firebaseUser = firebaseUserAsync.asData?.value;

    // Create our router with the current state.
    final router = createRouter(isOnboardingComplete, firebaseUser);

    return MaterialApp.router(
      scaffoldMessengerKey: Globals.scaffoldMessengerKey,
      title: 'Litigence AI',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: ThemeData.dark(useMaterial3: true)
            .textTheme
            .apply(fontFamily: 'Roboto'),
        primaryTextTheme: const TextTheme().apply(
          fontFamily: 'Roboto',
        ),
      ),
      routerConfig: router,
    );
  }
}

/// Create a GoRouter instance that uses the current onboarding & auth states.
GoRouter createRouter(bool isOnboardingComplete, User? firebaseUser) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      // Enforce onboarding:
      if (!isOnboardingComplete && state.matchedLocation != '/onboardScreen') {
        return '/onboardScreen';
      }

      // Optionally, enforce authentication.
      if (firebaseUser == null &&
          state.matchedLocation != '/chatScreen') {
        return '/authScreen';
      }

      // No redirection necessary.
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboardScreen',
        builder: (context, state) => const OnboardScreen(),
      ),
      GoRoute(
        path: '/chatScreen',
        builder: (context, state) => const ChatPage(),
      ),
      GoRoute(
        path: '/authScreen',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/otpAuthScreen',
        builder: (context, state) => const OtpAuth(),
      ),
      GoRoute(
        path: '/verifyPhoneNumberScreen',
        builder: (context, state) => VerifyPhoneNumberScreen(
          phoneNumber: state.extra as String,
        ),
      ),
    ],
  );
}
