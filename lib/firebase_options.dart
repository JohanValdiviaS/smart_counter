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
    apiKey: 'AIzaSyCxcTuQ2WcX34gZUcvZQdJl6K-hBJFmGeg',
    appId: '1:1083997311453:web:99249d3c38bb10f2e12634',
    messagingSenderId: '1083997311453',
    projectId: 'smart-counter-db',
    authDomain: 'smart-counter-db.firebaseapp.com',
    storageBucket: 'smart-counter-db.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaOrSkq0FzxNKUej2CQ1cfl8eG2FNr7lU',
    appId: '1:1083997311453:android:a67ca41c076c1c05e12634',
    messagingSenderId: '1083997311453',
    projectId: 'smart-counter-db',
    storageBucket: 'smart-counter-db.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCub3OagKR4NccK0b_ex41OG8gY97CfyhI',
    appId: '1:1083997311453:ios:0edf84b4b3575d3de12634',
    messagingSenderId: '1083997311453',
    projectId: 'smart-counter-db',
    storageBucket: 'smart-counter-db.appspot.com',
    iosBundleId: 'com.cristhianvaldivia.smartCounter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCub3OagKR4NccK0b_ex41OG8gY97CfyhI',
    appId: '1:1083997311453:ios:0edf84b4b3575d3de12634',
    messagingSenderId: '1083997311453',
    projectId: 'smart-counter-db',
    storageBucket: 'smart-counter-db.appspot.com',
    iosBundleId: 'com.cristhianvaldivia.smartCounter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCxcTuQ2WcX34gZUcvZQdJl6K-hBJFmGeg',
    appId: '1:1083997311453:web:614f0fb34278ae97e12634',
    messagingSenderId: '1083997311453',
    projectId: 'smart-counter-db',
    authDomain: 'smart-counter-db.firebaseapp.com',
    storageBucket: 'smart-counter-db.appspot.com',
  );
}