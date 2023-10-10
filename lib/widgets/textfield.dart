import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NeuTextField extends StatelessWidget {
  TextEditingController? txt = TextEditingController();
  NeuTextField({this.txt, this.hint, this.icon});
  IconData? icon;
  String? hint;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe6dfd8), Color(0xFFf7f5ec)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4],
          tileMode: TileMode.clamp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      child: TextField(
        controller: txt,
        expands: false,
        style: TextStyle(fontSize: 20.0, color: Colors.black54),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          prefixIcon: Icon(
            icon,
            color: Colors.black54,
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black54),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(32.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }
}
