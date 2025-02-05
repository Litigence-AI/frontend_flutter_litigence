import 'dart:io';
import 'package:Litigence/legal_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'utils/globals.dart';

class LegalInfoPage extends StatelessWidget {
  final String legalType;

  const LegalInfoPage({Key? key, required this.legalType}) : super(key: key);

  String get title =>
      legalType == 'privacy' ? 'Privacy Policy' : 'Terms of Service';

  Future<void> _launchURL(BuildContext context) async {
    final path = legalType == 'privacy' ? 'privacy-policy' : 'terms-of-service';
    final url = Uri.parse('${Globals.legalBaseUrl}/$path');

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        // If primary URL fails, try fallback
        final fallbackUrl = Uri.parse('${Globals.legalFallbackBaseUrl}/$path');
        if (!await launchUrl(fallbackUrl,
            mode: LaunchMode.externalApplication)) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not launch legal document'),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error launching legal document'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the platform is mobile (Android or iOS)
    bool isMobile = false;
    if (!kIsWeb) {
      try {
        isMobile = Platform.isAndroid || Platform.isIOS;
      } catch (_) {
        isMobile = false;
      }
    }

    if (isMobile) {
      // For mobile platforms, launch in browser
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _launchURL(context);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });

      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // For non-mobile platforms, show content in the app
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            legalType == 'privacy'
                ? LegalTexts.privacyPolicy(
                    contactEmail: Globals.contactEmail,
                  )
                : LegalTexts.termsOfService(
                    contactEmail: Globals.contactEmail,
                  ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }
  }
}
