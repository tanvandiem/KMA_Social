import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/responsive/mobile_screen_layout.dart';
import 'package:flutter_app/responsive/responsive_layout.dart';
import 'package:flutter_app/responsive/web_screen_layout.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/utils/colors.dart';

import 'package:provider/provider.dart';

void main() async {
  //Đầu tiên là điều khiển tiến trình liên quan đến việc xử lý khi có sự kiện cấu trúc của Widget bị thay đổi.
  //Thứ hai là trigger việc render của tầng Engine.
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAjtJJS-9Oa7xT8DxVR-X_Rkz1xi6bLF6I",
          authDomain: "appflutter-83d43.firebaseapp.com",
          projectId: "appflutter-83d43",
          storageBucket: "appflutter-83d43.appspot.com",
          messagingSenderId: "740928572497",
          appId: "1:740928572497:web:f73973916cccf32db5bc70"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: NewApp(),
    );
  }
}

class NewApp extends StatelessWidget {
  const NewApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KMA Socical',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Checking if the snapshot has any data or not
            if (snapshot.hasData) {
              // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
              return const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }

          // means connection to future hasnt been made yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
