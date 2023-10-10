import 'package:flutter/material.dart';

import 'textFieldContainer.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final TextEditingController? txt;
  final TextInputType? type;
  final bool isEnable;
  final bool isObscure;
  const RoundedInputField(
      {Key? key,
      this.hintText,
      this.icon = Icons.person,
      this.onChanged,
      this.txt,
      this.type,
      this.isEnable = true,
      this.isObscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        keyboardType: type,
        controller: txt,
        onChanged: onChanged,
        // ignore: deprecated_member_use
        cursorColor: Theme.of(context).accentColor,
        obscureText: isObscure,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Theme.of(context).primaryColorDark,
          ),
          hintText: hintText,
          border: InputBorder.none,
          enabled: isEnable,
        ),
      ),
    );
  }
}
