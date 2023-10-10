import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Splash.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'QR Scanner & Generator',
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
