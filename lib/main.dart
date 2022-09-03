import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multiple_login/providers/internet_provider.dart';
import 'package:multiple_login/providers/sign_in_provider.dart';
import 'package:multiple_login/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:((context) => SignInProvider()),),
        ChangeNotifierProvider(create:((context) => InternetProvider()),)

      ],
      child: const MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}