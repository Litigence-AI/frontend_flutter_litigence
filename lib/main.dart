import 'package:Litigence/authentication/auth_screen.dart';
import 'package:Litigence/authentication/otp_auth/otp_auth_screen.dart';
import 'package:Litigence/utils/globals.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat_ui/chat_page.dart';
import 'firebase_options.dart';
import '../onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';
import 'authentication/otp_auth/verify_phone_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
  }

  runApp(ProviderScope(child: FirebasePhoneAuthProvider(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the onboarding status from the provider.
    final onboardingAsync = ref.watch(onboardingCompleteProvider);

    return onboardingAsync.when(
      data: (isOnboardingComplete) {
        // Once we have onboarding status, watch the Firebase auth state.
        final firebaseUserAsync = ref.watch(firebaseUserProvider);
        final firebaseUser = firebaseUserAsync.asData?.value;

        // We'll create the router in the next step.
        // For now, we simply pass these values to our router.
        final router = createRouter(isOnboardingComplete, firebaseUser);

        return MaterialApp.router(      
          scaffoldMessengerKey: Globals.scaffoldMessengerKey,
          title: 'Litigence AI',
          theme: ThemeData.dark(useMaterial3: true).copyWith(
            textTheme: ThemeData.dark(useMaterial3: true).textTheme.apply(
                  fontFamily: 'Roboto',
                ),
            primaryTextTheme: const TextTheme().apply(
              fontFamily: 'Roboto',
            ),
          ),
          routerConfig: router,
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

GoRouter createRouter(bool isOnboardingComplete, User? firebaseUser) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/onboardScreen',
    // redirect: (BuildContext context, GoRouterState state) {
    //   // Not yet onboarded? Always send to onboarding screen.
    //   if (!isOnboardingComplete && state.matchedLocation != '/onboardScreen') {
    //     return '/onboardScreen';
    //   }

    // },
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
