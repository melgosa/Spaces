import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:monitor_ia/src/models/background_colors.dart';
import 'package:monitor_ia/src/pages/encuesta_page.dart';
import 'package:monitor_ia/src/providers/static_data_provider.dart';
import 'package:monitor_ia/src/utils/icono_by_string_util.dart';


class CardIconItem extends StatefulWidget {
  final String title;
  final int idSurvey;

  const CardIconItem(
      this.title,
      this.idSurvey
      );

  @override
  State<CardIconItem> createState() => _CardIconItemState();

}

class _CardIconItemState extends State<CardIconItem> {
  BackgroundColors _backgroundColors;
  int indexRandom;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getAlldata();
    });

  }

  _getAlldata() async{
    final random = Random();
    final backgroundColors = BackgroundColors.fromJsonList(
        await staticDataProvider.loadBackgroundColors()
    );

    setState(() {
      _backgroundColors = backgroundColors;
      indexRandom = random.nextInt(_backgroundColors.items.length);
    });

  }

  @override
  Widget build(BuildContext context) {
    return _backgroundColors == null
        ? Center(child: CircularProgressIndicator())
        : InkWell(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EncuestaPage(widget.idSurvey, widget.title)
            )
        );
      },
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: HexColor(_backgroundColors.items[indexRandom].lightColor)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                    child: Center(
                        child: getIconMeasurement(
                            'content_paste',
                            70,
                            _backgroundColors.items[indexRandom].deepColor)
                    )
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  width: double.maxFinite,
                  color: HexColor(_backgroundColors.items[indexRandom].deepColor),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                          this.widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                          ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}
