import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gene/pages/blog/blog_page.dart';
import 'package:gene/pages/dashboard/chat_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:gene/pages/dashboard/dashboard.dart';
import 'package:gene/pages/authentication/sign_in_screen.dart';
import 'package:gene/pages/authentication/sign_up_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/dashboard': (context) => const Dashboard(),
        '/signUp': (context) => const SignUp(),
        '/signIn': (context) => const SignUp(),
        '/blog': (context) =>  BlogPage(),
      },
      title: 'Gen-E',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme), // Apply the Inter font
        // TODO: Apply the Inter font offline
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    // void super.initState();
    // FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);

    controller.addListener(() {
      setState(() {
        _pageIndex = controller.page!.round();
      });
    });

    if (_pageIndex != 2) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                allowImplicitScrolling: true,
                children: const <Widget>[
                  Center(child: OnboardingScreen1()),
                  Center(child: OnboardingScreen2()),
                  Center(child: OnboardingScreen3()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0, top: 30, right: 220),
              child: DotsIndicator(
                dotsCount: 3,
                position: _pageIndex,
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeColor: const Color(0xFFE0AC94),
                  color: Colors.white,
                  shape: const CircleBorder(
                    side: BorderSide(
                      width: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          shape: const CircleBorder(),
          backgroundColor: const Color(0xFFE0AC94),
          foregroundColor: const Color(0xFFF5EAE5),
          child: const Icon(Icons.arrow_forward),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              allowImplicitScrolling: true,
              children: const <Widget>[
                Center(child: OnboardingScreen1()),
                Center(child: OnboardingScreen2()),
                Center(child: OnboardingScreen3()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
