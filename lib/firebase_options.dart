// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyC3Q5dGU3o7TbdHKQAO_4_8thQDCyp41xs',
    appId: '1:807224714326:web:5e5139847d6faa44fdc7f7',
    messagingSenderId: '807224714326',
    projectId: 'bookstoreapp-54481',
    authDomain: 'bookstoreapp-54481.firebaseapp.com',
    storageBucket: 'bookstoreapp-54481.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhE6PZPTxn29fFtWtK8GF5ikjY1mAeRlg',
    appId: '1:807224714326:android:449fd54d1a100cf4fdc7f7',
    messagingSenderId: '807224714326',
    projectId: 'bookstoreapp-54481',
    storageBucket: 'bookstoreapp-54481.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBP41MgDlG-qWsGGxophOt4_rYqqHetwYI',
    appId: '1:807224714326:ios:a0911581ee2dca45fdc7f7',
    messagingSenderId: '807224714326',
    projectId: 'bookstoreapp-54481',
    storageBucket: 'bookstoreapp-54481.firebasestorage.app',
    iosBundleId: 'com.example.bookstoreappEproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBP41MgDlG-qWsGGxophOt4_rYqqHetwYI',
    appId: '1:807224714326:ios:a0911581ee2dca45fdc7f7',
    messagingSenderId: '807224714326',
    projectId: 'bookstoreapp-54481',
    storageBucket: 'bookstoreapp-54481.firebasestorage.app',
    iosBundleId: 'com.example.bookstoreappEproject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC3Q5dGU3o7TbdHKQAO_4_8thQDCyp41xs',
    appId: '1:807224714326:web:efa23d1cbcc5de3efdc7f7',
    messagingSenderId: '807224714326',
    projectId: 'bookstoreapp-54481',
    authDomain: 'bookstoreapp-54481.firebaseapp.com',
    storageBucket: 'bookstoreapp-54481.firebasestorage.app',
  );
}