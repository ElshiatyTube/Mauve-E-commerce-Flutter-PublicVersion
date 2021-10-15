import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final Widget startScreen;
  const SplashScreen({Key? key, required this.startScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1000,
      splashIconSize: 320.0,
      splash: Image.asset('assets/images/logoo.png'),
      nextScreen: startScreen,
      splashTransition: SplashTransition.slideTransition,
      backgroundColor: Colors.white,
    );
  }
}
