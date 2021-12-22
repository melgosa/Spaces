import 'dart:async';

import 'package:monitor_ia/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{
  final _emailControler = BehaviorSubject<String>();
  final _passwordControler = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get emailStream => _emailControler.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordControler.stream.transform(validarPassword);
  Stream<bool> get formValidStream => Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  //Insertar valores al Stream
  Function(String) get changeEmail => _emailControler.sink.add;
  Function(String) get changePassword => _passwordControler.sink.add;

  //obtener el ultimo valor ingresado a los streams
  String get email => _emailControler.value;
  String get password => _passwordControler.value;

  dispose(){
    _emailControler?.close();
    _passwordControler?.close();
  }

}