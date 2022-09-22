import 'package:flutter/material.dart';
import 'package:multiple_login/providers/sign_in_provider.dart';
import 'package:multiple_login/screens/login_screen.dart';
import 'package:multiple_login/utils/next_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    //watch can get data  again and again and read can't do this.
    final sp = context.watch<SignInProvider>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage("${sp.imageUrl}"),
              radius: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Welcome ${sp.name}",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "email: ${sp.email}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "user id: ${sp.uid}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Provider:"),
                const SizedBox(
                  width: 5,
                ),
                Text("${sp.provider}".toUpperCase(),
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  sp.userSignOut();
                  nextScreenReplace(context, const LoginScreen());
                },
                child: const Text("Sign out",
                    style: TextStyle(
                      color: Colors.white,
                    )))
          ],
        ),
      ),
    );
  }
}
