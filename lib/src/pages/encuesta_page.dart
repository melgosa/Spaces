import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:monitor_ia/src/widgets/background.dart';
import 'package:monitor_ia/src/widgets/background_polygons_widget.dart';
import 'package:monitor_ia/src/widgets/header_common_widget.dart';
import 'package:provider/provider.dart';

import 'package:monitor_ia/src/providers/survey_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/utils/constants_utils.dart';
import 'package:monitor_ia/src/widgets/app_bar_principal.dart';
import 'package:monitor_ia/src/widgets/custom_background_widget.dart';
import 'package:monitor_ia/src/widgets/multi_options_widget.dart';
import 'package:monitor_ia/src/widgets/snack_message_widget.dart';

const String img_asset_path = 'assets/img/sala1.png';
const String label_encuesta = 'Encuesta';
const String label_boton_continuar = 'Continuar';
const String label_title_ocurrio_un_error = 'Ocurrió un error';
const String label_content_ocurrio_un_error = 'Ocurrió un error al registrar la encuesta, inténtalo nuevamente';
const String label_title_registro_correcto = 'Registro correcto';
const String label_content_registro_correcto = 'Se registro la encuesta correctamente';
const String label_title_app_bar_encuesta = 'Encuesta';
const String label_contesta_la_siguiente_encuesta = 'Contesta la siguiente encuesta por favor';

class EncuestaPage extends StatefulWidget {
  final int idSurvey;
  final String surveyName;

  const EncuestaPage(this.idSurvey, this.surveyName);

  @override
  _EncuestaPageState createState() => _EncuestaPageState();
}

class _EncuestaPageState extends State<EncuestaPage> {
  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
      surveyProvider.clearAllValues();
      surveyProvider.getSurvey(widget.idSurvey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundPolygons(
            HexColor('#0B1467'),
            HexColor('#182FF7'),
            HexColor('#DA05DC'),
            HexColor('#DFA6E0'),
          ),
          Column(
            children: [
              HeaderCommon(widget.surveyName),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox( height: 15),
                    _info(),
                    SizedBox( height: 15),
                  ],
                ),
              ),
              _showSurvey()
            ],
          ),
          _botonContinuar()
        ],
      ),
    );
  }

  Container _info() {
    return Container(
        margin: EdgeInsets.only(left: 10),
        child: Text(
            label_contesta_la_siguiente_encuesta,
            style: TextStyle(fontSize: 20, color: Colors.white)));
  }

  Widget _showSurvey(){
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _showFormForSurvey(),
              SizedBox(height: 80,)
            ]
        ),
      ),
    );
  }

  Widget _showFormForSurvey() {
    List<Widget> widgets = [];
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);

    if(surveyProvider.surveyResponse == null){
      widgets.add(Center(child: CircularProgressIndicator()));
    }else{
      //Los ordena  por un atributo, en este caso el id de menor a mayor
      surveyProvider.surveyResponse.questions.sort((a,b)
      => a.idCatQuestion.compareTo(b.idCatQuestion));

      int totalQuestions = surveyProvider.surveyResponse.questions.length;
      int index = 0;

      surveyProvider.surveyResponse.questions.forEach((question) {
        index++;
        widgets.add(MultiOptionsWidget(
          question.question,
          question.answers,
          question.idCatQuestion,
          totalQuestions,
          index
        ));
      });
    }

    return Column(
      children: widgets,
    );
  }

  Widget _botonContinuar() {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.all(20),
        width: double.infinity,
        child: MaterialButton(
          child: Container(
            padding: EdgeInsets.symmetric( vertical: 20.0),
            child: surveyProvider.isConnectingToServer
                ? Center(child: CircularProgressIndicator())
                : Text(label_boton_continuar, style: TextStyle(fontSize: 20)),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 0.0,
          color: Color.fromRGBO(236, 98, 188, 1),
          textColor: Colors.white,
          onPressed: surveyProvider.isConnectingToServer
              ? null
              : _recordSurveyAnswered,
        ),
      ),
    );
  }

  _recordSurveyAnswered() async {
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);

    surveyProvider.isConnectingToServer = true;

    if (surveyProvider.allSurveyOK()) {
      String responseFromServer = await surveyProvider.registerSurveyAnswered(
          this.widget.idSurvey,
          prefs.userId
      );
      if (responseFromServer.length == 0 || responseFromServer == 'NOTOK') {
        showMessageError(
            context,
            label_title_ocurrio_un_error,
            label_content_ocurrio_un_error
        );
      } else {
        String responseFromWS = await surveyProvider.registerQuestionsAnswered();
        if (responseFromWS == 'OK') {
          Navigator.pop(context);
          showMessageOK(
              context,
              label_title_registro_correcto,
              label_content_registro_correcto
          );
        } else {
          showMessageError(
              context,
              label_title_ocurrio_un_error,
              label_content_ocurrio_un_error
          );
        }
      }
    } else {
      showMessageError(
          context,
          label_title_ocurrio_un_error,
          surveyProvider.descriptionErrorInSurvey
      );
    }
    surveyProvider.isConnectingToServer = false;
  }
}
