// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyCMLKhVFos3OnkoMG_bw9_D02BytYNO4CE",
        authDomain: "uas-native-177e6.firebaseapp.com",
        projectId: "uas-native-177e6",
        storageBucket: "uas-native-177e6.firebasestorage.app",
        messagingSenderId: "475228527649",
        appId: "1:475228527649:web:103a6532a4a44537f11760",
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'AIzaSyCMLKhVFos3OnkoMG_bw9_D02BytYNO4CE',
          appId: '1:475228527649:android:YOUR_ANDROID_APP_ID',
          messagingSenderId: '475228527649',
          projectId: 'uas-native-177e6',
          storageBucket: 'uas-native-177e6.firebasestorage.app',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'AIzaSyCMLKhVFos3OnkoMG_bw9_D02BytYNO4CE',
          appId: '1:475228527649:ios:YOUR_IOS_APP_ID',
          messagingSenderId: '475228527649',
          projectId: 'uas-native-177e6',
          storageBucket: 'uas-native-177e6.firebasestorage.app',
          iosBundleId: 'com.example.yourapp', // Ganti dengan bundle ID iOS Anda
        );
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: 'AIzaSyCMLKhVFos3OnkoMG_bw9_D02BytYNO4CE',
          appId: '1:475228527649:ios:YOUR_MACOS_APP_ID',
          messagingSenderId: '475228527649',
          projectId: 'uas-native-177e6',
          storageBucket: 'uas-native-177e6.firebasestorage.app',
          iosBundleId:
              'com.example.yourapp', // Ganti dengan bundle ID macOS Anda
        );
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for $defaultTargetPlatform - '
          'you can reconfigure this by running the FlutterFire CLI command `flutterfire configure`.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
