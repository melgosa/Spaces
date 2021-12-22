import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:monitor_ia/src/models/answer_model.dart';
import 'package:monitor_ia/src/providers/survey_provider.dart';
import 'package:monitor_ia/src/utils/constants_utils.dart';
import 'package:monitor_ia/src/widgets/question_widget.dart';

class MultiOptionsWidget extends StatefulWidget {
  final String question;
  final List<Answer> answers;
  final int idQuestion;
  final int total;
  final int currentQuestion;

  MultiOptionsWidget(
      this.question,
      this.answers,
      this.idQuestion,
      this.total,
      this.currentQuestion
      );

  @override
  State<MultiOptionsWidget> createState() => _MultiOptionsWidgetState();
}

class _MultiOptionsWidgetState extends State<MultiOptionsWidget> {
  int _radioValues;
  List<bool> _checkValues = [];

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur( sigmaX: 5, sigmaY: 5 ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color.fromRGBO(62, 66, 107, 0.7),
                borderRadius: BorderRadius.circular(5.0)
            ),
            child: Column(
              children: [
                Question('${widget.currentQuestion}/${widget.total}: ${widget.question}'),
                _answersToQuestion(widget.answers, context)
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _answersToQuestion(List<Answer> answers, BuildContext context) {
    //Ordena por un atributo, en este caso id de menor a mayor
    answers.sort((a,b) => a.idCatResponse.compareTo(b.idCatResponse));
      return Column(
        children: [
          Container(
            height: answers.length * 70.0,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: _answersList(answers, context),
            ),
          ),
        ],
      );
  }

  Widget _inputResponse(int idQuestion, int idResponse) {
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    return Container(
      color: Colors.transparent,
      child: TextField(
        style: TextStyle(color: Colors.white),
        onChanged: (String answer) {
          surveyProvider.onUpdateInput(idQuestion, idResponse, answer);
        },
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 10,
        decoration: InputDecoration(
          hintText: 'Escribe tu respuesta',
          hintStyle: TextStyle(color: Colors.white54),
          fillColor: Colors.transparent,
          filled: true,
        ),
      ),
    );
  }

  List<Widget> _answersList(List<Answer> answers, BuildContext context) {
    List<Widget> preguntas = [];
    var widgetTemp;

      for (int i = 0; i < answers.length; i++) {
        if(answers[i].idCatResponseType == Constantes.SELECT){
          widgetTemp = drawRaddioButton(
              answers[i].response,
              answers[i].idCatQuestion,
              answers[i].idCatResponse,
              context
          );
          preguntas.add(widgetTemp);
        }else if (answers[i].idCatResponseType == Constantes.CHEKBOX){
          this._checkValues.add(false);
          widgetTemp = drawCheckBox(
              answers[i].response,
              answers[i].idCatQuestion,
              answers[i].idCatResponse,
              context,
              i
          );
          preguntas.add(widgetTemp);
        }else{
          widgetTemp = _inputResponse(
              answers[i].idCatQuestion,
              answers[i].idCatResponse
          );
          preguntas.add(widgetTemp);
        }
      }

    return preguntas;
  }

  Widget drawRaddioButton(String label, int idQuestion, int idAnswer, BuildContext context){
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    return Card(
      color: this._radioValues == idAnswer ? HexColor('#D4E1FD') :  Colors.transparent,
      elevation: this._radioValues == idAnswer
      ? 5
      : 0,
      child: Row(
        children: [
          Radio(
            value: idAnswer,
            groupValue: this._radioValues,
            onChanged: (int value) {
              setState(() {
                this._radioValues = value;
                surveyProvider.onUpdateRaddio(idQuestion, idAnswer, value.toString());
                print('idAnswer: $idAnswer , radioValue: ${this._radioValues}');
              });
            },
          ),
          Text(
              label,
              style: TextStyle(
                  fontSize: this._radioValues == idAnswer ? 20 : 16,
                  color: this._radioValues == idAnswer ? Colors.blue[700] : Colors.white,
                fontWeight: this._radioValues == idAnswer ? FontWeight.bold : FontWeight.normal
              )
          )
        ],
      ),
    );
  }

  Widget drawCheckBox(String label, int idQuestion, int idAnswer, BuildContext context, int index) {
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);

    return Card(
      color: this._checkValues[index] == true ? HexColor('#D4E1FD') : Colors.transparent,
      elevation: this._checkValues[index] == true
          ? 5
          : 0,
      child: Row(
        children: [
          Checkbox(
            value: this._checkValues[index],
            onChanged: (bool isCkecked) {
              setState(() {
                this._checkValues[index] = isCkecked;
                  surveyProvider.onUpdateCheckBox(idQuestion, idAnswer, isCkecked);
                });
            },
          ),
          Text(
              label,
              style: TextStyle(
                  fontSize: this._checkValues[index] == true ? 20 : 16,
                  color: this._checkValues[index] == true ? Colors.blue[700] : Colors.white,
                  fontWeight: this._checkValues[index] == true ? FontWeight.bold : FontWeight.normal
              )
          )
        ],
      ),
    );
  }
}
