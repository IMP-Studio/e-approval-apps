import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imp_approval/screens/login.dart';
import 'dart:math' as math;

import 'package:imp_approval/screens/standup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance!.addObserver(this);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _shrinkAnimation;
  late Animation<double> _expandAnimation;
  late Animation<double> _borderRadiusAnimation;
  late Animation<double> _textOpacityAnimation;

  bool _isTextVisible = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _animationController = AnimationController(
      duration: Duration(
          milliseconds: 2500), // Adjusted duration for all three phases
      vsync: this,
    );

    _borderRadiusAnimation = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 20.0, end: 20.0),
        weight: 66,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 20.0, end: 0.0),
        weight: 34,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _sizeAnimation = Tween<double>(begin: 100.0, end: 134.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.33, curve: Curves.easeInOut),
      ),
    );

    _rotateAnimation = TweenSequence([TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: math.pi / 4),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: math.pi / 4, end: math.pi / 4),
        weight: 67,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: math.pi / 4, end: math.pi / 4),
        weight: 67,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: math.pi / 4, end: math.pi / 4),
        weight: 67,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: math.pi / 4, end: math.pi / 4),
        weight: 67,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: math.pi / 4, end: math.pi / 4),
        weight: 67,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: math.pi / 4, end: math.pi / 4),
        weight: 67,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: math.pi / 4, end: math.pi / 4),
        weight: 67,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: math.pi / 4, end: math.pi / 4),
        weight: 67,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: math.pi / 4, end: math.pi / 4),
        weight: 67,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: math.pi / 4, end: 0),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0),
        weight: 33,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _shrinkAnimation = Tween<double>(begin: 134.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.33, 0.66, curve: Curves.easeInOut),
      ),
    );

    _expandAnimation = Tween<double>(begin: 0.0, end: 500.0).animate(
      // Adjust the end value as needed
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.66, 1.0, curve: Curves.easeInOut),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.9, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start the animation
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isTextVisible = true;
      });

      _expandAnimation =
          Tween<double>(begin: 0.0, end: MediaQuery.of(context).size.height)
              .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.66, 1.0, curve: Curves.easeInOut),
        ),
      );

      _animationController.forward().then((_) {
        Future.delayed(Duration(seconds: 1), () {
          // Updated to match the new animation duration
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  LoginScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = 0.0;
                const end = 1.0;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return FadeTransition(
                  opacity: animation.drive(tween),
                  child: child,
                );
              },
              transitionDuration:
                  Duration(milliseconds: 500), // Customize the duration here
            ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode()); 
  SystemChannels.textInput.invokeMethod('TextInput.hide'); 

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              double currentSize;

              if (_animationController.value < 0.33) {
                currentSize = _sizeAnimation.value;
              } else if (_animationController.value < 0.66) {
                currentSize = _shrinkAnimation.value;
              } else {
                currentSize = _expandAnimation.value;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: currentSize,
                            width: currentSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  _borderRadiusAnimation.value),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff246DC1),
                                  Color(0xff246DC1).withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ... (omitting the rest of the code for brevity)
}