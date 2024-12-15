import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'skeleton_widget.dart';

class BlogPage extends StatelessWidget {
  BlogPage({super.key});

  final List<String> blogLinks = [
    'https://restoreprivacy.com/browser/secure/',
    'https://blog.google/technology/ai/google-gemini-ai/',
    'https://9to5google.com/2024/02/01/assistant-driving-mode-bar/',
    'https://devblogs.microsoft.com/azure-sdk/azure-sdk-release-january-2024/',
    'https://itsfoss.com/vs-code-vs-codium/',
    'https://restoreprivacy.com/kaspersky-shares-method-for-detecting-spyware-on-the-iphone/',
    'https://9to5google.com/2024/02/01/verizon-rcs-google-jibe/',
    'https://devblogs.microsoft.com/dotnet/building-ai-powered-bing-chat-with-signalr-and-other-open-source-tools/',
    'https://restoreprivacy.com/best-ad-blocker/',
    'https://blog.google/products/chrome/google-chrome-generative-ai-features-january-2024/',
    'https://spreadprivacy.com/windows-browser-open-beta/',
    'https://9to5google.com/2024/02/01/android-circle-to-search-zoom-search-bar/',
    'https://restoreprivacy.com/password-manager/best-password-manager/',
    'https://9to5google.com/2024/02/01/android-quick-share-direct-share-menu/',
    'https://spreadprivacy.com/privacy-companies-call-for-vote/',
    'https://itsfoss.com/getting-started-with-ubuntu/'
    'https://devblogs.microsoft.com/java/java-on-visual-studio-code-update-january-2024',
    'https://blog.google/technology/ai/google-gemini-pro-imagen-duet-ai-update/',
    'https://spreadprivacy.com/app-tracking-protection-open-beta/',
    'https://spreadprivacy.com/search-engine-market-share-data-two-new-sources-cloudflare-and-wikipedia/',
    'https://restoreprivacy.com/vpn/best/',
    'https://blog.google/technology/ai/google-labs-imagefx-textfx-generative-ai/',
  ];

  Future<String> fetchTitle(String url) async {
    final response = await http.get(Uri.parse(url));
    dom.Document document = parser.parse(response.body);
    dom.Element? titleElement = document.querySelector('title');
    return titleElement?.text ?? 'No title';
  }

  Future<String> fetchImage(String url) async {
    final response = await http.get(Uri.parse(url));
    dom.Document document = parser.parse(response.body);
    dom.Element? metaElement =
        document.querySelector('meta[property="og:image"]');
    return metaElement?.attributes['content'] ??
        'https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('My Intrests'),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.122)),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.122),
      body: ListView.builder(
        itemCount: blogLinks.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 12, right: 12, bottom: 12),
                child: Column(
                  children: [
                    Column(children: [
                      FutureBuilder<String>(
                        future: fetchImage(blogLinks[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return const Skeleton(height: 200, width: double.infinity,);
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<String>(
                        future: fetchTitle(blogLinks[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            );
                          } else {
                            return const Column(
                              children: [
                                Skeleton(height: 20, width: double.infinity),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(child: Skeleton(height: 20, width: 10)),
                                    SizedBox(width: 12),
                                    Expanded(child: Skeleton(height: 20, width:  10)),
                                  ],
                                )
                              ],
                            );
                          }
                        },
                      ),
                    ]),
                  ],
                ),
              ),
              const Divider(
                thickness: 0.5,
              )
            ],
          );
        },
      ),
    );
  }
}


