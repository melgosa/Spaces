import 'dart:ui';

import 'package:flutter/material.dart';


class HeaderCommon extends StatelessWidget {
  final String title;

  const HeaderCommon(this.title);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur( sigmaX: 5, sigmaY: 5 ),
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromRGBO(62, 66, 107, 0.7),
            ),
            child: Row(
              children: [
                _botonBack(context),
                _title(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Text(
        this.title,
        maxLines: 2,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _botonBack(BuildContext context){
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Align(
            alignment: Alignment.center,
            child: Icon(Icons.arrow_back, color: Colors.white,size: 30)
        ),
      ),
    );
  }
}
