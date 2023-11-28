import 'package:flutter/material.dart';
import 'package:imp_approval/dependency_injection.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/screens/login.dart';
import 'package:imp_approval/controller/network_controller.dart';
import 'package:imp_approval/splash_screen/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get/get.dart';
import 'controller/store_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("d0249df4-3456-48a0-a492-9c5a7f6a875e");

  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
  await StoreManager.getInstance();

  DependencyInjection.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        },
        child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            scrollBehavior: _getScrollBehavior(),
            home: Stack(
              children: [
                FutureBuilder(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final token = (snapshot.data as SharedPreferences)
                            .getString('token');
                        if (token != null && token.isNotEmpty) {
                          return MainLayout();
                        } else {
                          return const LoginScreen();
                        }
                      } else if (snapshot.hasError) {
                        print(snapshot.error); // Debugging
                        return const Text('Some error has Occurred');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                Obx(() {
                  if (!Get.find<NetworkController>().isConnected.value) {
                    return Container(
                      color: Colors.black.withOpacity(0.5),
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            )));
  }

  ScrollBehavior _getScrollBehavior() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return NoBounceBehavior();
      case TargetPlatform.android:
        return NoGlowBehavior();
      default:
        return const MaterialScrollBehavior();
    }
  }
}

class NoBounceBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class NoGlowBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
