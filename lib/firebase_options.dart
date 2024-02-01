// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyANVsGI-pcfImTIQjK6ose8qetXlrPyyyg',
    appId: '1:1021838572230:web:6d799bd676436843e9b5c7',
    messagingSenderId: '1021838572230',
    projectId: 'gen-e-sustainathon',
    authDomain: 'gen-e-sustainathon.firebaseapp.com',
    storageBucket: 'gen-e-sustainathon.appspot.com',
    measurementId: 'G-2H34NG1YKB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAhNRYe8ZzjOmrvPFC-G1EiAAQFE2E3Eo4',
    appId: '1:1021838572230:android:8ec1c59f01788489e9b5c7',
    messagingSenderId: '1021838572230',
    projectId: 'gen-e-sustainathon',
    storageBucket: 'gen-e-sustainathon.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpS7rpnfw372vKqMP5EvyD0yUcTZROZN4',
    appId: '1:1021838572230:ios:9d425a6df4a74137e9b5c7',
    messagingSenderId: '1021838572230',
    projectId: 'gen-e-sustainathon',
    storageBucket: 'gen-e-sustainathon.appspot.com',
    androidClientId: '1021838572230-3ngl3107gd3u7obn576n8bsa277s85ha.apps.googleusercontent.com',
    iosClientId: '1021838572230-favtuvhmcf3dg2i5icbjenbam5s4dtki.apps.googleusercontent.com',
    iosBundleId: 'com.example.gene',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDpS7rpnfw372vKqMP5EvyD0yUcTZROZN4',
    appId: '1:1021838572230:ios:42cb7be97aca4d40e9b5c7',
    messagingSenderId: '1021838572230',
    projectId: 'gen-e-sustainathon',
    storageBucket: 'gen-e-sustainathon.appspot.com',
    androidClientId: '1021838572230-3ngl3107gd3u7obn576n8bsa277s85ha.apps.googleusercontent.com',
    iosClientId: '1021838572230-htkkdo3sp6qaalj250t830hjodh7pgff.apps.googleusercontent.com',
    iosBundleId: 'com.example.gene.RunnerTests',
  );
}
