import 'package:flutter/material.dart';

class TutorialManagementProvider with ChangeNotifier {
  bool _canInitSecondTutorial = false;

  bool get canInitSecondTutorial => this._canInitSecondTutorial;
  set canInitSecondTutorial( bool value ) {
    this._canInitSecondTutorial = value;
    notifyListeners();
  }
}