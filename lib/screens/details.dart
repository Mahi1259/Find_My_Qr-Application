import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../utils/method.dart';
import '../widgets/textfield.dart';

// ignore: must_be_immutable
class Details extends StatefulWidget {
  String? data;
  Details({this.data});
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  late StreamSubscription subscription;
  bool isDeviceConnected = false;

  @override
  void initState() {
    getConnectivity();
    checkInternet();
    super.initState();

    decode();
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

  decode() {
    if (widget.data != null && widget.data != '') {
      var details = jsonDecode(widget.data!);
      _nameController.text = details['name'];
      _phoneController.text = details['phone'];
      _emailController.text = details['email'];
      _addressController.text = details['address'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.grey[850],
          elevation: 0,
          title: const Text('Scanned Result'),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _contentWidget()));
  }

  _contentWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/icon.png',
            width: Get.width * 0.4,
          ),
          const SizedBox(
            height: 20,
          ),
          NeuTextField(
            icon: Icons.person,
            txt: _nameController,
            hint: 'Full name',
          ),
          const SizedBox(
            height: 20,
          ),
          NeuTextField(
            icon: Icons.mail,
            txt: _emailController,
            hint: 'Email address',
          ),
          const SizedBox(
            height: 20,
          ),
          NeuTextField(
            icon: Icons.phone,
            txt: _phoneController,
            hint: 'Phone number',
          ),
          const SizedBox(
            height: 20,
          ),
          NeuTextField(
            icon: Icons.pin_drop,
            txt: _addressController,
            hint: 'Address',
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
