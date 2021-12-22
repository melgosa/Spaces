import 'dart:async';

class RegistroValidators{
  final validarNombre = StreamTransformer<String, String>.fromHandlers(
      handleData: (nombre, sink){
        if(!nombre.isEmpty){
          sink.add(nombre);
        }
        else{
          sink.addError('Campo requerido');
        }
      }
  );

  final validarApellidoP = StreamTransformer<String, String>.fromHandlers(
      handleData: (apellidoP, sink){
        if(!apellidoP.isEmpty){
          sink.add(apellidoP);
        }
        else{
          sink.addError('Campo requerido');
        }
      }
  );

  final validarApellidoM = StreamTransformer<String, String>.fromHandlers(
      handleData: (apellidoM, sink){
        if(!apellidoM.isEmpty){
          sink.add(apellidoM);
        }
        else{
          sink.addError('Campo requerido');
        }
      }
  );

  final validarNacimiento = StreamTransformer<String, String>.fromHandlers(
      handleData: (nacimiento, sink){
        if(!nacimiento.isEmpty){
          sink.add(nacimiento);
        }
        else{
          sink.addError('Campo requerido');
        }
      }
  );

  final validarSexo = StreamTransformer<String, String>.fromHandlers(
      handleData: (sexo, sink){
        if(sexo.isEmpty){
          sink.add(sexo);
        }
        else{
          sink.addError('Campo requerido');
        }
      }
  );

  final validarTelefono = StreamTransformer<String, String>.fromHandlers(
      handleData: (telefono, sink){
        if(!telefono.isEmpty){
          sink.add(telefono);
        }
        else{
          sink.addError('Campo requerido');
        }
      }
  );

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink){
        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = new RegExp(pattern);
        if(regExp.hasMatch(email)){
          sink.add(email);
        }
        else{
          sink.addError("Email inválido");
        }
      }
  );

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if(password.length>=6){
          sink.add(password);
        }
        else{
          sink.addError('La contraseña debe ser minimo de 6 caracteres');
        }
      }
  );

  final validarPasswordComplete = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        /*Pattern pattern = r'^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[\\w]{8,25}$';
        RegExp regExp = new RegExp(pattern);
        if(regExp.hasMatch(password)){
          sink.add(password);
        }
        else{
          sink.addError("La contraseña no cumple con los parámetros requeridos");
        }*/
        if(password.length>=6){
          sink.add(password);
        }
        else{
          sink.addError('La contraseña no cumple con los parámetros requeridos');
        }
      }
  );
}