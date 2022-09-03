import 'dart:async';
import 'package:multiple_login/providers/sign_in_provider.dart';
import 'package:multiple_login/screens/home_screen.dart';
import 'package:multiple_login/screens/login_screen.dart';
import 'package:multiple_login/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:multiple_login/utils/config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();
    Timer(const Duration(seconds: 2), () {
      sp.isSignedIn == false
          ? nextScreenReplace(context, const LoginScreen())
          : nextScreenReplace(context, const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Image(
          image: AssetImage(Config.app_icon),
          height: 80,
          width: 80,
        )),
      ),
    );
  }
}
