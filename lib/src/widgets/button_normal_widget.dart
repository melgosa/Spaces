import 'package:flutter/material.dart';

class ButtonNormal extends StatelessWidget {
  final String text;
  ButtonNormal(this.text);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.red;
        }
        if (states.contains(MaterialState.dragged)) {
          return Colors.black;
        }
        if (states.contains(MaterialState.focused)) {
          return Colors.green;
        }
        if (states.contains(MaterialState.hovered)) {
          return Colors.yellow;
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.pink;
        }
        if (states.contains(MaterialState.disabled)) {
          return Colors.white;
        }
        return null; // Use the component's default.
      })),
      child: Text(text),
      onPressed: () {},
    );
  }
}
