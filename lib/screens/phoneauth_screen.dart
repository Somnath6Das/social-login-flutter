import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_login/providers/internet_provider.dart';
import 'package:multiple_login/screens/login_screen.dart';
import 'package:multiple_login/utils/next_screen.dart';
import 'package:multiple_login/utils/snack_bar.dart';
import 'package:provider/provider.dart';
import '../providers/sign_in_provider.dart';
import '../utils/config.dart';
import 'home_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  // formKey is check the form field is empty or not.
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            nextScreenReplace(context, const LoginScreen());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage(
                        Config.app_icon,
                      ),
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(height: 100),
                    const Text(
                      "Phone Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return 'Name cannot be empty';
                        } else {
                          return null;
                        }
                      }),
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.account_circle,
                        ),
                        hintText: "Johny Depp",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.blue)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return 'Email address cannot be empty';
                        } else {
                          return null;
                        }
                      }),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.alternate_email),
                        hintText: "example@xyz.com",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return 'Phone number cannot be empty';
                        } else {
                          return null;
                        }
                      }),
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        hintText: "9830012345",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          login(context, phoneController.text.trim());
                        },
                        color: Colors.black,
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ])),
        ),
      ),
    );
  }

  //phone authentication
  Future login(BuildContext context, String mobile) async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your internet connection", Colors.red);
    } else {
      if (formKey.currentState!.validate()) {
        FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: "+91$mobile",
            verificationCompleted: (AuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              openSnackbar(context, e.message, Colors.red);
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Enter code'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: otpCodeController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.add_box_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              final code = otpCodeController.text.trim();
                              AuthCredential authCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: code);
                              User user = (await FirebaseAuth.instance
                                      .signInWithCredential(authCredential))
                                  .user!;
                              sp.phoneNumberUser(user, emailController.text,
                                  nameController.text);
                              sp.checkUserExists().then((value) async {
                                if (value == true) {
                                  //user exist
                                  await sp
                                      .getUserDataFromFirestore(sp.uid)
                                      .then((value) => sp
                                          .getDataFromSharedPreferences()
                                          .then((value) =>
                                              sp.setSignIn().then((value) {
                                                nextScreenReplace(context,
                                                    const HomeScreen());
                                              })));
                                } else {
                                  //user does not exist
                                  sp.saveDataToFirestore().then((value) => sp
                                      .saveDataToSharedPreferences()
                                      .then((value) =>
                                          sp.setSignIn().then((value) {
                                            nextScreenReplace(
                                                context, const HomeScreen());
                                          })));
                                }
                              });
                            },
                            color: Colors.black,
                            child: const Text(
                              'confirm',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            codeAutoRetrievalTimeout: (String verification) {});
      }
    }
  }
}
