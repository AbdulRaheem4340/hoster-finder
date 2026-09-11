import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBXSkCzvAtiZFIZxBg4DCW2h48JRbY5V9w',
    appId: '1:712127389593:web:42c91b1148a90d276ffd08',
    messagingSenderId: '712127389593',
    projectId: 'hostel-finder-35c0a',
    authDomain: 'hostel-finder-35c0a.firebaseapp.com',
    storageBucket: 'hostel-finder-35c0a.firebasestorage.app',
    measurementId: 'G-0L79QFZMFY',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUMMsC4fnw4bwHPQmtTyTL2XbhtXi6QxQ',
    appId: '1:712127389593:ios:f9ca1782c6d1eae86ffd08',
    messagingSenderId: '712127389593',
    projectId: 'hostel-finder-35c0a',
    storageBucket: 'hostel-finder-35c0a.firebasestorage.app',
    iosBundleId: 'com.example.hostelFinder',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDUMMsC4fnw4bwHPQmtTyTL2XbhtXi6QxQ',
    appId: '1:712127389593:ios:f9ca1782c6d1eae86ffd08',
    messagingSenderId: '712127389593',
    projectId: 'hostel-finder-35c0a',
    storageBucket: 'hostel-finder-35c0a.firebasestorage.app',
    iosBundleId: 'com.example.hostelFinder',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBXSkCzvAtiZFIZxBg4DCW2h48JRbY5V9w',
    appId: '1:712127389593:web:fadaddacf06705d46ffd08',
    messagingSenderId: '712127389593',
    projectId: 'hostel-finder-35c0a',
    authDomain: 'hostel-finder-35c0a.firebaseapp.com',
    storageBucket: 'hostel-finder-35c0a.firebasestorage.app',
    measurementId: 'G-Q1FJ69CKCV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCMdflEtK3pDSq-cxmxFwx4MqAHq3FQeR0',
    appId: '1:712127389593:android:3a6b21dd3b0ccbaa6ffd08',
    messagingSenderId: '712127389593',
    projectId: 'hostel-finder-35c0a',
    storageBucket: 'hostel-finder-35c0a.firebasestorage.app',
  );
}
