import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils/globals.dart'; 

class LegalLinksRow extends StatelessWidget {
  const LegalLinksRow({Key? key}) : super(key: key);

  Future<void> _launchWithFallback(String url, String fallbackUrl) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      final Uri fallbackUri = Uri.parse(fallbackUrl);
      if (!await launchUrl(fallbackUri, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch fallback URL: $fallbackUrl');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Privacy Policy Button
        TextButton(
          onPressed: () {
            if (kIsWeb) {
              // Navigate internally on web
              context.go('/privacy-policy');
            } else {
              // Build URLs using the global base and appended path
              final String primaryUrl = '${Globals.legalBaseUrl}/privacy-policy/';
              final String fallbackUrl = '${Globals.legalFallbackBaseUrl}/privacy-policy/';
              _launchWithFallback(primaryUrl, fallbackUrl);
            }
          },
          child: const Text(
            'Privacy policy',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        // Terms of Service Button
        TextButton(
          onPressed: () {
            if (kIsWeb) {
              context.go('/terms-of-service');
            } else {
              final String primaryUrl = '${Globals.legalBaseUrl}/terms-of-service/';
              final String fallbackUrl = '${Globals.legalFallbackBaseUrl}/terms-of-service/';
              _launchWithFallback(primaryUrl, fallbackUrl);
            }
          },
          child: const Text(
            'Terms of service',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}
