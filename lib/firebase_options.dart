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
    apiKey: 'AIzaSyDarET8J82yZis0KYEYVPhIiJdhHdHJSB4',
    appId: '1:1031631384871:web:a60be4fa19b18c2cd17902',
    messagingSenderId: '1031631384871',
    projectId: 'easy-store-9104a',
    authDomain: 'easy-store-9104a.firebaseapp.com',
    storageBucket: 'easy-store-9104a.appspot.com',
    measurementId: 'G-3NJ1DH55CH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-MYYZrLPCFAfQIxZY5N-jiUEaxMN-SUk',
    appId: '1:1031631384871:android:1546d144d9c32345d17902',
    messagingSenderId: '1031631384871',
    projectId: 'easy-store-9104a',
    storageBucket: 'easy-store-9104a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBU8n_poTGj7hvROiDFtdZbvgNq55IUvKQ',
    appId: '1:1031631384871:ios:d89124ee4e81e2f9d17902',
    messagingSenderId: '1031631384871',
    projectId: 'easy-store-9104a',
    storageBucket: 'easy-store-9104a.appspot.com',
    iosBundleId: 'com.example.easypos',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBU8n_poTGj7hvROiDFtdZbvgNq55IUvKQ',
    appId: '1:1031631384871:ios:3260e27a9a53f162d17902',
    messagingSenderId: '1031631384871',
    projectId: 'easy-store-9104a',
    storageBucket: 'easy-store-9104a.appspot.com',
    iosBundleId: 'com.example.easypos.RunnerTests',
  );
}
