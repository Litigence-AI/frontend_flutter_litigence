import 'package:flutter/material.dart';

class LegalInfoPage extends StatelessWidget {
  final String legalType; // expects "tos" or "privacy"

  const LegalInfoPage({Key? key, required this.legalType}) : super(key: key);

  String get title =>
      legalType == 'privacy' ? 'Privacy Policy' : 'Terms of Service';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '$title content placeholder.\n\n'
          'Replace this placeholder with your actual content. '
          'You can include rich formatting, images, and more. '
          'This text is scrollable.',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
