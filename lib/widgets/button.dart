import 'package:flutter/material.dart';

class NeuButton extends StatelessWidget {
  NeuButton({this.widget});
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey[850],
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade900,
                  offset: const Offset(4, 4),
                  blurRadius: 15,
                  spreadRadius: 1.0),
              BoxShadow(
                  color: Colors.grey.shade800,
                  offset: const Offset(-4, -4),
                  blurRadius: 15,
                  spreadRadius: 1.0)
            ]),
        child: widget);
  }
}
