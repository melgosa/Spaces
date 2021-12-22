import 'package:monitor_ia/src/blocs/registro_validators.dart';
import 'package:rxdart/rxdart.dart';

class RegistroBloc with RegistroValidators{
  final _nombreControler = BehaviorSubject<String>();
  final _apellidoPControler = BehaviorSubject<String>();
  final _apellidoMControler = BehaviorSubject<String>();
  final _nacimientoControler = BehaviorSubject<String>();
  final _sexoControler = BehaviorSubject<String>();
  final _telefonoControler = BehaviorSubject<String>();
  final _emailControler = BehaviorSubject<String>();
  final _passwordControler = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get nombreStream => _nombreControler.stream.transform(validarNombre);
  Stream<String> get apellidoPStream => _apellidoPControler.stream.transform(validarApellidoP);
  Stream<String> get apellidoMStream => _apellidoMControler.stream.transform(validarApellidoM);
  Stream<String> get nacimientoStream => _nacimientoControler.stream.transform(validarNacimiento);
  Stream<String> get sexoStream => _sexoControler.stream.transform(validarSexo);
  Stream<String> get telefonoStream => _telefonoControler.stream.transform(validarTelefono);
  Stream<String> get emailStream => _emailControler.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordControler.stream.transform(validarPassword);
  Stream<bool> get formValidStream => Rx.combineLatest8(nombreStream,apellidoPStream,apellidoMStream,nacimientoStream,sexoStream,telefonoStream,emailStream,passwordStream, (n,ap,am,na,s,t,e,p) => true);

  //Insertar valores al Stream
  Function(String) get changeNombre => _nombreControler.sink.add;
  Function(String) get changeApellidoP => _apellidoPControler.sink.add;
  Function(String) get changeApellidoM => _apellidoMControler.sink.add;
  Function(String) get changeNacimiento => _nacimientoControler.sink.add;
  Function(String) get changeSexo => _sexoControler.sink.add;
  Function(String) get changeTelefono => _telefonoControler.sink.add;
  Function(String) get changeEmail => _emailControler.sink.add;
  Function(String) get changePassword => _passwordControler.sink.add;

  //obtener el ultimo valor ingresado a los streams
  String get nombre => _nombreControler.value;
  String get apellidoP => _apellidoPControler.value;
  String get apellidoM => _apellidoMControler.value;
  String get nacimiento => _nacimientoControler.value;
  String get sexo => _sexoControler.value;
  String get telefono => _telefonoControler.value;
  String get email => _emailControler.value;
  String get password => _passwordControler.value;

  dispose(){
    _nombreControler?.close();
    _apellidoPControler?.close();
    _apellidoMControler?.close();
    _nacimientoControler?.close();
    _sexoControler?.close();
    _telefonoControler?.close();
    _emailControler?.close();
    _passwordControler?.close();
  }
}