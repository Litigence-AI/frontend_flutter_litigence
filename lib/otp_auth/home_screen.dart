import 'package:easy_container/easy_container.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import '../otp_auth/authentication_screen.dart';
import '/utils/globals.dart';
import '/utils/helpers.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    child: Text('Logged in user UID'),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FittedBox(
                  child: Text(Globals.firebaseUser!.uid),
                ),
              ),
              EasyContainer(
                onTap: () async {
                  await FirebasePhoneAuthHandler.signOut(context);
                  showSnackBar('Logged out successfully!');

                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AuthenticationScreen.id,
                      (route) => false,
                    );
                  }
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
