import 'dart:async';

class Validators{
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
        if(password.length > 0){
          sink.add(password);
        }
        else{
          sink.addError("El campo no puede estar vacío");
        }


        //Al menos: 1 mayuscula, 1 minuscula, 1 digito, ! caracter especial( ! @ # $ & * ~)
/*        Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        RegExp regExp = new RegExp(pattern);
        if(regExp.hasMatch(password)){
          sink.add(password);
        }
        else{
          sink.addError("La contraseña no cumple con los parámetros requeridos");
        }*/
      }
  );

/*  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if(password.length>=6){
          sink.add(password);
        }
        else{
          sink.addError('La contraseña debe ser minimo de 6 caracteres');
        }
      }
  );*/

  final validarPasswordComplete = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        RegExp regex = new RegExp(pattern);
        regex.hasMatch(password);
        //print(password);
        if (password.isEmpty) {
          sink.addError('Ingrese una contraseña');
        }
        else if(password.length<6){
          sink.addError('La contraseña debe ser de al menos 6 caracteres');
        }
        else if (!regex.hasMatch(password)){
            sink.addError('La contraseña debe incluir mayúscula, minuscula,\n número y caracter');
        }
        else{
          sink.add(password);
        }
      }
  );
}