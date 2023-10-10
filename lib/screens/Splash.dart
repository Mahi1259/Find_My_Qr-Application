import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/selection.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  @override
  void initState() {
    super.initState();

    checkLocation();
  }

  Future<void> checkLocation() async {
    Future.delayed(const Duration(seconds: 4), () {});

    bool isSignedIn = await _googleSignIn.isSignedIn();
    var accessToken = await facebookAuth.accessToken;
    if (isSignedIn || accessToken != null) {
      Get.off(() => Selection());
    } else {
      Get.off(() => const Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/icon.svg',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          )
        ],
      ),
    );
  }
}
