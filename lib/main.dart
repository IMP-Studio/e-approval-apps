import 'package:flutter/material.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/screens/create/create_standup.dart';
import 'package:imp_approval/screens/create/emergency_chekout.dart';
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
import 'package:flutter/foundation.dart';

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
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          scrollBehavior: _getScrollBehavior(),
          home: FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Some error has Occurred');
                } else if (snapshot.hasData) {
                  final token = snapshot.data!.getString('token');
                  if (token != null) {
                    return MainLayout();
                  } else {
                    return const SplashScreen();
                  }
                } else {
                  return const LoginScreen();
                }
              }),
        ));
  }

 ScrollBehavior _getScrollBehavior() {
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return NoBounceBehavior();
    case TargetPlatform.android:
      return NoGlowBehavior();
    default:
      return const MaterialScrollBehavior();  // Return the default behavior for other platforms
  }
}


}

class NoBounceBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

