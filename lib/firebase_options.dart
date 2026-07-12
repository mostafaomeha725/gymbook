import 'package:firebase_core/firebase_core.dart';
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAj9eNcHcTwaJqO3tWiYvmk3YzAYLJyCWY',
    appId: '1:1005560059828:web:1efe37355032e0496484e1',
    messagingSenderId: '1005560059828',
    projectId: 'prime-fit-b40d6',
    authDomain: 'prime-fit-b40d6.firebaseapp.com',
    storageBucket: 'prime-fit-b40d6.firebasestorage.app',
    measurementId: 'G-QC0DGG1175',
  );
  // استخدم بيانات Android الموجودة عندك أو أنشئها لاحقًا بواسطة FlutterFire.

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlaXKYqkP1tt_VCQr87RrViTHRHyluS9A',
    appId: '1:1005560059828:android:587e29d49d67fe606484e1',
    messagingSenderId: '1005560059828',
    projectId: 'prime-fit-b40d6',
    storageBucket: 'prime-fit-b40d6.firebasestorage.app',
  );
}
