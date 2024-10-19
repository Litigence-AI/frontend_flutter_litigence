import 'package:flutter/material.dart';

import 'package:lexmachina/src/dashboard/dashboard.dart';
import 'package:lexmachina/src/onboarding/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DecisionPage extends StatefulWidget {
  const DecisionPage({super.key});

  @override
  State<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  Future<bool> _checkOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkOnboardingComplete(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.hasData && snapshot.data == true) {
            return const Dashboard(); // Navigate to HomePage
          } else {
            return const OnboardScreen(); // Show Onboarding Page 1
          }
        }
      },
    );
  }
}
