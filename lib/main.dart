import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart'; // Import AuthScreen

// KHÔNG import firebase_options.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Cấu hình cho WEB
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDjjxFUUqm6GciQnV3c16NI-RP4p5RZ7TA",
            authDomain: "quancaphe-ed527.firebaseapp.com",
            projectId: "quancaphe-ed527",
            storageBucket: "quancaphe-ed527.firebasestorage.app",
            messagingSenderId: "632863077312",
            appId: "1:632863077312:web:b082030afe3f5800870e25",
            measurementId: "G-TSXV5TMTS5"));
  } else {
    // Cấu hình cho ANDROID (hoặc iOS)
    // Thay thế bằng giá trị thật từ file google-services.json (Android)
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "YOUR_ANDROID_API_KEY", // Lấy từ google-services.json
        appId: "YOUR_ANDROID_APP_ID", // Lấy từ google-services.json
        messagingSenderId: "YOUR_MESSAGING_SENDER_ID", // Lấy từ google-services.json
        projectId: "YOUR_PROJECT_ID", // Lấy từ google-services.json
      ),
    );

    // HOẶC, cấu hình cho iOS (thay thế bằng giá trị từ GoogleService-Info.plist)
    // await Firebase.initializeApp(
    //   options: FirebaseOptions(
    //     apiKey: "YOUR_IOS_API_KEY",       // Lấy từ GoogleService-Info.plist
    //     appId: "YOUR_IOS_APP_ID",           // Lấy từ GoogleService-Info.plist
    //     messagingSenderId: "YOUR_MESSAGING_SENDER_ID", // Lấy từ GoogleService-Info.plist
    //     projectId: "YOUR_PROJECT_ID",         // Lấy từ GoogleService-Info.plist
    //     iosBundleId: "YOUR_IOS_BUNDLE_ID",   // Lấy từ GoogleService-Info.plist
    //   ),
    // );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quán Cà Phê',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      // Thay đổi home:
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Đang kết nối hoặc đã kết nối
            if (snapshot.hasData) {
              // Đã đăng nhập -> HomeScreen
              return HomeScreen();
            } else {
              // Chưa đăng nhập -> AuthScreen
              return AuthScreen();
            }
          }
          // Đang loading -> hiển thị loading indicator (tùy chọn)
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      
      debugShowCheckedModeBanner: false,
    );
  }
}