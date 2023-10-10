import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/method.dart';
import '../widgets/roundedButton.dart';
import '../widgets/textfield.dart';

class Generator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeneratorState();
}

class GeneratorState extends State<Generator> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          centerTitle: true,
          title: Text('Generator'),
          backgroundColor: Colors.grey[850],
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _contentWidget(),
        ));
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes!);
      final success = await GallerySaver.saveImage(file.path);
      log('$success');
      Fluttertoast.showToast(msg: 'Download successfully.');
    } catch (e) {
      log(e.toString());
    }
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
          RoundedButton(
            text: 'Generate QR Code',
            press: () {
              _dataString = jsonEncode({
                'name': _nameController.text,
                'phone': _phoneController.text,
                'address': _addressController.text,
                'email': _emailController.text
              });
              qrDialog();
            },
          ),
        ],
      ),
    );
  }

  qrDialog() {
    Get.defaultDialog(
        backgroundColor: Colors.grey[850],
        titleStyle: const TextStyle(color: Colors.white),
        title: 'QR Code',
        titlePadding: const EdgeInsets.only(bottom: 0, top: 20),
        content: Column(
          children: [
            SizedBox(
              width: Get.width * 0.8,
              height: Get.width * 0.8,
              child: qrcodeWidget(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundedButton(
                text: 'Download',
                press: () {
                  _captureAndSharePng();
                },
              ),
            )
          ],
        ));
  }

  qrcodeWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Center(
        child: RepaintBoundary(
          key: globalKey,
          child: QrImage(
            data: _dataString,
            backgroundColor: Colors.white,
            errorStateBuilder: (c, err) {
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
