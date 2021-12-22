import 'package:flutter/material.dart';

class PhotoAppBarWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String pathToAsset;
  final Color color;

  PhotoAppBarWidget(this.title, this.subtitle, this.pathToAsset, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          _background(context),
          _appBarContent(context)
        ],
      ),
    );
  }

  Container _background(BuildContext context) {
    //final barHeight = MediaQuery.of(context).size.height * 0.3;
    final barHeight = 200.0;
    return Container(
      height: barHeight,
      width: double.infinity,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
            this.color, BlendMode.srcOver),
        child: Image(
          fit: BoxFit.fill,
          image: AssetImage(this.pathToAsset),
        ),
      ),
    );
  }

  Widget _appBarContent(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 170,
        child: Column(
          children: [
            _botonBack(context),
            Spacer(),
            _appBarInfo(),
          ],
        ),
      ),
    );
  }

  Widget _botonBack(BuildContext context){
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Align(
            alignment: Alignment.topLeft,
            child: Icon(Icons.arrow_back, color: Colors.white,size: 25)
        ),
      ),
    );
  }

  Widget _appBarInfo() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(this.title,
                style: TextStyle(fontSize: 40, color: Colors.white)),
            Text(this.subtitle,
              style: TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

}