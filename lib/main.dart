import 'package:flutter/material.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/screens/cuti.dart';
import 'package:imp_approval/screens/detail/detail_request_cuti.dart';
import 'package:imp_approval/screens/detail/detail_request_perjadin.dart';
import 'package:imp_approval/screens/face_recognition.dart';
import 'package:imp_approval/screens/home.dart';
import 'package:imp_approval/screens/detail/detail_infoapp.dart';
import 'package:imp_approval/screens/login.dart';
import 'package:imp_approval/screens/map_wfo.dart';
import 'package:imp_approval/screens/notification_page.dart';
import 'package:imp_approval/screens/request.dart';
import 'package:imp_approval/screens/standup.dart';
import 'package:imp_approval/splash_screen/splash.dart';
import 'package:imp_approval/screens/history_attedance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // Wrap the entire content with GestureDetector
        onTap: () {
          // Reset system UI when user taps the screen
          FocusManager.instance.primaryFocus?.unfocus();

          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HistoryAttendance(
              // future: SharedPreferences.getInstance(),
              // builder: (context, snapshot) {
              //   if (snapshot.connectionState == ConnectionState.waiting) {
              //     return const Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   } else if (snapshot.hasError) {
              //     return Text('Some error has Occurred');
              //   } else if (snapshot.hasData) {
              //     final token = snapshot.data!.getString('token');
              //     if (token != null) {
              //       return MainLayout();
              //     } else {
              //       return SplashScreen();
              //     }
              //   } else {
              //     return LoginScreen();
              //   }
              // }
              ),
        ));
  }
}
