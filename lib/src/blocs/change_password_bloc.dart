import 'dart:async';

import 'package:monitor_ia/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordBloc with Validators{
  final _passwordControler = BehaviorSubject<String>();

  Stream<String> get passwordStream => _passwordControler.stream.transform(validarPasswordComplete);

  Function(String) get changePassword => _passwordControler.sink.add;

  String get password => _passwordControler.value;

  dispose(){
    _passwordControler?.close();
  }
}