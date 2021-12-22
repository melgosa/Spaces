import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_ia/src/pages/encuesta_page.dart';

import 'package:monitor_ia/src/utils/icono_by_string_util.dart';

class CardOptionForSurvey extends StatelessWidget {

  final String nameSurvey;
  final int idSurvey;

  const CardOptionForSurvey(this.nameSurvey, this.idSurvey);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 25),
      child: Card(
        elevation: 5.0,
        color: Colors.blue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Colors.white, width: 2)),
        child: InkWell(
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EncuestaPage(this.idSurvey, this.nameSurvey)
                )
            );
          },
          splashColor: Colors.blue,
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                getIcon('note'),
                Expanded(
                  child: Text(
                    this.nameSurvey,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
