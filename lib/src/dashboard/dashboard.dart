import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User? userInfo;

  @override
  void initState() {
    super.initState();
    try {
      userInfo = FirebaseAuth.instance.currentUser;
    } on Exception catch (_) {
      // TODO
    }
  }

  Future<void> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) => {
                if (mounted)
                  {Navigator.of(context).pushReplacementNamed('/signIn')}
              }
          // Guard navigation with 'mounted' check

          );
    } on Exception catch (_) {
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                signOutFromGoogle();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome ${userInfo?.displayName}'),
              Text('Your email is ${userInfo?.email}'),
              Text('Your email is ${userInfo?.photoURL}'),
            ],
          ),
        ));
  }
}
