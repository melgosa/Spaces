import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget AppBarCustom(String title, String subtitle) {
  return AppBar(
    foregroundColor: Colors.blue[900],
    backgroundColor: Colors.blue[900],
      centerTitle: false,
      title: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
          ],
        ),
      ));
}
