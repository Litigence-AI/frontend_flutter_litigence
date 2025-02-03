// providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// StreamProvider that listens for changes in the Firebase user.
/// This is great for keeping track of login/logout events in real time.
final firebaseUserProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);


class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _initOnboardingState();
  }

  Future<void> _initOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    final complete = prefs.getBool('onboarding_complete') ?? false;
    // Update the state once the value is retrieved.
    state = complete;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    // Update the state.
    state = true;
  }
}

// Expose this as a provider.
final onboardingCompleteProvider =
    StateNotifierProvider<OnboardingNotifier, bool>(
  (ref) => OnboardingNotifier(),
);
