import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/method.dart';
import 'package:flutter_application_1/widgets/roundedButton.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generator.dart';
import 'login.dart';
import 'profile.dart';
import 'scanner.dart';

class Selection extends StatefulWidget {
  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;

  @override
  void initState() {
    getConnectivity();
    checkInternet();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        leading: IconButton(
            onPressed: () async {
              Get.to(() => const Profile());
            },
            icon: const Icon(Icons.person)),
        title: const Text('QR Code'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                FacebookAuth facebookLogin = FacebookAuth.instance;
                bool googleSign = await googleSignIn.isSignedIn();
                var token = await facebookLogin.accessToken;

                if (googleSign) {
                  googleSignIn.signOut();
                }
                if (token != null) {
                  facebookLogin.logOut();
                }
                Get.offAll(() => const Login());
              },
              icon: const Icon(Icons.power_settings_new))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  'assets/scanner.svg',
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  text: 'QR Scanner',
                  press: () {
                    Get.to(() => Scanner());
                  },
                )
              ],
            ),
            Column(
              children: [
                SvgPicture.asset(
                  'assets/generator.svg',
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  text: 'QR Generator',
                  press: () {
                    Get.to(() => Generator());
                  },
                )
              ],
            ),

            // Center(
            //   child: GestureDetector(
            //     onTap: () {
            //       Get.to(() => Scanner());
            //     },
            //     child: Container(
            //       height: MediaQuery.of(context).size.width * 0.5,
            //       width: MediaQuery.of(context).size.width * 0.5,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(30),
            //           color: Colors.grey[850],
            //           boxShadow: [
            //             BoxShadow(
            //                 color: Colors.grey.shade900,
            //                 offset: Offset(4, 4),
            //                 blurRadius: 15,
            //                 spreadRadius: 1.0),
            //             BoxShadow(
            //                 color: Colors.grey.shade800,
            //                 offset: Offset(-4, -4),
            //                 blurRadius: 15,
            //                 spreadRadius: 1.0)
            //           ]),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Center(
            //               child: SvgPicture.asset(
            //             'assets/scanner.svg',
            //             width: MediaQuery.of(context).size.width * 0.3,
            //             height: MediaQuery.of(context).size.width * 0.3,
            //             color: Colors.white,
            //           )),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // GestureDetector(
            //   onTap: () {
            //     Get.to(() => Generator());
            //   },
            //   child: Container(
            //     height: MediaQuery.of(context).size.width * 0.5,
            //     width: MediaQuery.of(context).size.width * 0.5,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(30),
            //         color: Colors.grey[850],
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.grey.shade900,
            //               offset: Offset(4, 4),
            //               blurRadius: 15,
            //               spreadRadius: 1.0),
            //           BoxShadow(
            //               color: Colors.grey.shade800,
            //               offset: Offset(-4, -4),
            //               blurRadius: 15,
            //               spreadRadius: 1.0)
            //         ]),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Center(
            //             child: SvgPicture.asset(
            //           'assets/generator.svg',
            //           width: MediaQuery.of(context).size.width * 0.3,
            //           height: MediaQuery.of(context).size.width * 0.3,
            //           color: Colors.white,
            //         )),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
