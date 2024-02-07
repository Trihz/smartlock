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
    apiKey: 'AIzaSyCl9QpSI1nf9eA6zgM0dBFPqW-Wy3Crd1g',
    appId: '1:995300314773:web:fe335fdc25a07404c8959c',
    messagingSenderId: '995300314773',
    projectId: 'smartlock-d7efb',
    authDomain: 'smartlock-d7efb.firebaseapp.com',
    databaseURL: 'https://smartlock-d7efb-default-rtdb.firebaseio.com',
    storageBucket: 'smartlock-d7efb.appspot.com',
    measurementId: 'G-8W7K84CV5L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7xWq2DlknOsChnn-OF1Mb7M54iraPZEg',
    appId: '1:995300314773:android:b8b1296aaddad345c8959c',
    messagingSenderId: '995300314773',
    projectId: 'smartlock-d7efb',
    storageBucket: 'smartlock-d7efb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBw1ujeLYBne8wLfKX7T8PBXK3M6pxsB3w',
    appId: '1:995300314773:ios:2871c86b35f93bbbc8959c',
    messagingSenderId: '995300314773',
    projectId: 'smartlock-d7efb',
    databaseURL: 'https://smartlock-d7efb-default-rtdb.firebaseio.com',
    storageBucket: 'smartlock-d7efb.appspot.com',
    iosBundleId: 'com.example.smartlock',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBw1ujeLYBne8wLfKX7T8PBXK3M6pxsB3w',
    appId: '1:995300314773:ios:d881fe5e5fdcba48c8959c',
    messagingSenderId: '995300314773',
    projectId: 'smartlock-d7efb',
    databaseURL: 'https://smartlock-d7efb-default-rtdb.firebaseio.com',
    storageBucket: 'smartlock-d7efb.appspot.com',
    iosBundleId: 'com.example.smartlock.RunnerTests',
  );
}