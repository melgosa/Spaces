import 'dart:async';

import 'package:monitor_ia/src/blocs/registro_validators.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordREgistroBloc with RegistroValidators{
  final _passwordControler = BehaviorSubject<String>();

  Stream<String> get passwordStream => _passwordControler.stream.transform(validarPasswordComplete);

  Function(String) get changePassword => _passwordControler.sink.add;

  String get password => _passwordControler.value;

  dispose(){
    _passwordControler?.close();
  }
}