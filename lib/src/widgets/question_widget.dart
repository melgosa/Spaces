import 'package:flutter/material.dart';


class Question extends StatelessWidget {
  final String question;

  const Question(this.question);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        question,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19.0,
            color: Colors.white
        )
      ),
    );
  }
}
