import 'dart:math';

import 'package:flutter/material.dart';

class BackgroundPolygons extends StatelessWidget {
  final Color backgroundDeepColor;
  final Color backgroundLightColor;
  final Color polygonDeepColor;
  final Color polygonLightColor;

  const BackgroundPolygons(
      this.backgroundDeepColor,
      this.backgroundLightColor,
      this.polygonDeepColor,
      this.polygonLightColor
      );

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.8],
            colors: [backgroundDeepColor, backgroundLightColor]
        )
    );

    return Stack(
      children: [
        Container(decoration: boxDecoration),
        Positioned(
            top: -100,
            left: -30,
            child: Polygon(polygonDeepColor, polygonLightColor)
        ),
        Positioned(
            bottom: -100,
            right: -30,
            child: Polygon(polygonDeepColor, polygonLightColor)
        ),
      ],
    );
  }
}

class Polygon extends StatelessWidget {
  final Color deepColor;
  final Color lightColor;

  const Polygon(this.deepColor, this.lightColor);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            gradient: LinearGradient(
                colors: [deepColor, lightColor]
            )
        ),
      ),
    );
  }
}

