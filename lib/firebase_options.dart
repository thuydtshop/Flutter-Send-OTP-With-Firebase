import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCrPpuGyUh7UfnOpPIgzvu9fp9H951yyHU',
    appId: '1:1011463063189:web:d86aeebebea4580cafbd9c',
    messagingSenderId: '1011463063189',
    projectId: 'phi-test-sms-otp',
    authDomain: 'phi-test-sms-otp.firebaseapp.com',
    storageBucket: 'phi-test-sms-otp.appspot.com',
    measurementId: 'G-G4JS91S6QG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrPpuGyUh7UfnOpPIgzvu9fp9H951yyHU',
    appId: '1:406099696497:android:21d5142deea38dda3574d0',
    messagingSenderId: '1011463063189',
    projectId: 'phi-test-sms-otp',
    storageBucket: 'phi-test-sms-otp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCrPpuGyUh7UfnOpPIgzvu9fp9H951yyHU',
    appId: '1:1011463063189:ios:21376e74705ec74eafbd9c',
    messagingSenderId: '1011463063189',
    projectId: 'phi-test-sms-otp',
    storageBucket: 'phi-test-sms-otp.appspot.com',
    iosClientId: '1011463063189-svf91j994ak42c27mfuqdavcgc6q1ap7.apps.googleusercontent.com',
    iosBundleId: 'com.example.phiapp',
  );
}