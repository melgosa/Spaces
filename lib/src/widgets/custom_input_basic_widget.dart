import 'package:flutter/material.dart';

class CustomInputBasic extends StatelessWidget {
  final String placeHolder;
  final TextEditingController textController;
  final TextInputType textInputType;
  final bool isPassword;

  const CustomInputBasic(
      {
        @required this.placeHolder,
        @required this.textController,
        this.textInputType = TextInputType.text,
        this.isPassword = false
      });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          obscureText: this.isPassword,
          controller: this.textController,
          autocorrect: false,
          keyboardType: this.textInputType,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              label: Text(this.placeHolder)),
        ));
  }
}
