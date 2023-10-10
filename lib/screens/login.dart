import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/selection.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/method.dart';
import '../widgets/roundedButton.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  SharedPreferences? sp;
  GoogleSignIn googleSignIn = GoogleSignIn();
  late StreamSubscription subscription;
  bool isDeviceConnected = false;

  @override
  void initState() {
    getConnectivity();
    checkInternet();
    super.initState();
    initSP();
  }

  checkInternet() async {
    ConnectivityResult status = await Connectivity().checkConnectivity();
    if (status == ConnectivityResult.none) {
      Method.getSimpleToast('No Internet');
    }
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected) {
            Method.getSimpleToast('No Internet');
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  initSP() async {
    sp = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Generator'),
          backgroundColor: Colors.grey[850],
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: body(),
        ));
  }

  body() {
    return Column(
      children: [
        Image.asset(
          'assets/icon.png',
          width: Get.width * 0.4,
        ),
        const SizedBox(
          height: 20,
        ),
        RoundedButton(
          text: 'Google Sign in',
          press: () {
            googleSignIn.signIn().then((value) {
              sp?.setString('name', value!.displayName!);
              sp?.setString('email', value!.email);
              sp?.setString('image', value!.photoUrl ?? '');
              Get.offAll(() => Selection());
            }).catchError((e) {
              log('$e');
            });
          },
        ),
        const SizedBox(
          height: 20,
        ),
        RoundedButton(
          text: 'Facebook Login',
          press: () {
            // facebookLogin();
            onPressedFacebookLogin();
          },
        )
      ],
    );
  }

  onPressedFacebookLogin() async {
    final facebookLogin =
        await FacebookAuth.instance.login(loginBehavior: LoginBehavior.webOnly);

    if (facebookLogin.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();

      sp?.setString('name', userData['name']!);
      sp?.setString('email', userData['email']);
      sp?.setString('image', userData['picture']['data']['url'] ?? '');

      Get.offAll(() => Selection());
    } else {
      log('${facebookLogin.status}');
      log('${facebookLogin.message}');
    }
  }
}
