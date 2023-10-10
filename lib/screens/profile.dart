import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/method.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences? sp;
  String? name = '', email = '', image = '';
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
    name = sp?.getString('name') ?? '';
    email = sp?.getString('email') ?? '';
    image = sp?.getString('image') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        width: Get.width,
        child: Column(
          children: [
            image == ''
                ? const Icon(Icons.person, size: 100)
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    child: Image.network(
                      image!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
            const SizedBox(
              height: 50,
            ),
            infoWidget('Name: ', name!),
            SizedBox(
              height: 10,
            ),
            infoWidget('Email: ', email!),
          ],
        ),
      ),
    );
  }

  infoWidget(String title, String info) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          info,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        )
      ],
    );
  }
}
