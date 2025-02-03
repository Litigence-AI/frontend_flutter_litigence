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
// import '../url_strategy_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

// // Use conditional URL strategy (only effective on web).
// configureUrlStrategy();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
  }

  runApp(
    ProviderScope(
      child: FirebasePhoneAuthProvider(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch onboarding state from Riverpod.
    final bool isOnboardingComplete = ref.watch(onboardingCompleteProvider);

    // Watch the Firebase user.
    final User? firebaseUser =
        ref.watch(firebaseUserProvider).asData?.value;

    // Create our router with the current app state.
    final GoRouter router =
        createRouter(isOnboardingComplete, firebaseUser);

    return MaterialApp.router(
      scaffoldMessengerKey: Globals.scaffoldMessengerKey,
      title: 'Litigence AI',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: ThemeData.dark(useMaterial3: true)
            .textTheme
            .apply(fontFamily: 'Roboto'),
        primaryTextTheme:
            const TextTheme().apply(fontFamily: 'Roboto'),
      ),
      routerConfig: router,
    );
  }
}

/// Create a GoRouter instance that uses nested routes with relative paths.
/// A splash/root ("/") route is provided so that redirection picks up immediately.
GoRouter createRouter(bool isOnboardingComplete, User? firebaseUser) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    // Redirect callback inspects the current state.
    redirect: (BuildContext context, GoRouterState state) {
      final String loc = state.matchedLocation;
      // If onboarding is not done, force the user to the onboardScreen.
      if (!isOnboardingComplete && loc != '/onboardScreen') {
        return '/onboardScreen';
      }
      // If onboarding is done but the user is not authenticated,
      // force them to the authScreen.
      if (isOnboardingComplete && firebaseUser == null &&
          loc != '/authScreen' && loc != '/otpAuthScreen' && loc != '/verifyPhoneNumberScreen') {
        return '/authScreen';
      }

      // If onboarding is done and the user is authenticated,
      // force them to the chatScreen.

      if (isOnboardingComplete &&
          firebaseUser != null &&
          loc != '/chatScreen') {
        return '/chatScreen';
      }
      
      // Otherwise, no redirection.
      return null;
    },
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Something went wrong!'),
      ),
    ),
    routes: [
      // Define the root route ("/") as a splash (loading) screen.
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          // The splash screen should be displayed very briefly
          // because the redirect callback will route elsewhere immediately.
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
        // Now define nested routes with relative paths—as shown in the docs.
        routes: [
          GoRoute(
            path: 'onboardScreen',
            builder: (BuildContext context, GoRouterState state) =>
                const OnboardScreen(),
          ),
          GoRoute(
            path: 'authScreen',
            builder: (BuildContext context, GoRouterState state) =>
                const AuthScreen(),
          ),
          GoRoute(
            path: 'chatScreen',
            builder: (BuildContext context, GoRouterState state) =>
                const ChatPage(),
          ),
          GoRoute(
            path: 'otpAuthScreen',
            builder: (BuildContext context, GoRouterState state) =>
                const OtpAuth(),
          ),
          GoRoute(
            path: 'verifyPhoneNumberScreen',
            builder: (BuildContext context, GoRouterState state) =>
                VerifyPhoneNumberScreen(
              phoneNumber: state.extra as String,
            ),
          ),
        ],
      ),
    ],
  );
}
