// providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// StreamProvider that listens for changes in the Firebase user.
/// This is great for keeping track of login/logout events in real time.
final firebaseUserProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

/// FutureProvider that retrieves the onboarding complete flag from SharedPreferences.
final onboardingCompleteProvider = FutureProvider<bool>(
  (ref) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  },
);

