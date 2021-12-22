import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 66.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.blueAccent, Colors.green[400]],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 8.0),
              stops: [0.0, 0.5],
              tileMode: TileMode.clamp),
        ),
        padding: new EdgeInsets.only(top: statusBarHeight),
        height: statusBarHeight + barHeight,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: new Center(
            child: Align(
              alignment: Alignment.centerLeft,
              child: new Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0)),
            )
          ),
        ));
  }
}
