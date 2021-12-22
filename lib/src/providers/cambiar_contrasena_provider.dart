import 'package:flutter/material.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';

class CambiarContrasenaProvider with ChangeNotifier {
  bool _obscureTextConfContra = true;
  bool _obscureTextContra = true;
  bool _obscureTextContraAct = true;
  bool _hasContraError = true;
  bool _hasConfContraError = true;
  bool _isLoading = false;
  String _textContra = '';
  String _textContraAct = '';
  String _textConfContra = '';
  String _errorTextContra;
  String _errorTextConfContra;
  String _errorTextContraAct;

  bool get obscureTextConfContra => this._obscureTextConfContra;
  bool get obscureTextContra => this._obscureTextContra;
  bool get obscureTextContraAct => this._obscureTextContraAct;
  bool get hasContraError => this._hasContraError;
  bool get hasConfContraError => this._hasConfContraError;
  bool get isLoading => this._isLoading;
  String get textContra => this._textContra;
  String get textConfContra => this._textConfContra;
  String get textContraAct => this._textContraAct;
  String get errorTextContra => this._errorTextContra;
  String get errorTextConfContra => this._errorTextConfContra;
  String get errorTextContraAct => this._errorTextContraAct;

  set obscureTextConfContra( bool value ) {
    this._obscureTextConfContra = value;
    notifyListeners();
  }
  set obscureTextContra( bool value ) {
    this._obscureTextContra = value;
    notifyListeners();
  }
  set obscureTextContraAct( bool value ) {
    this._obscureTextContraAct = value;
    notifyListeners();
  }
  set textContra( String value ) {
    this._textContra = value;
    notifyListeners();
  }
  set textConfContra( String value ) {
    this._textConfContra = value;
    notifyListeners();
  }
  set textContraAct( String value ) {
    this.textContraAct = value;
    notifyListeners();
  }

  final prefs = PreferenciasUsuario();
  final b2wProvider = B2WProvider();

  repoInfoContra(String text){
    this._textContra = text;
    print('Texto contra : ${this._textContra}');
    if(this._textContra.length < 4){
      this._hasContraError = true;
      this._errorTextContra = 'No menor a 4 caracteres';
    }else{
      this._hasContraError = false;
      this._errorTextContra = null;
    }
    notifyListeners();
  }

  repoInfoConfContra(String text){
    this._textConfContra = text;
    if(this._textConfContra != this._textContra){
      this._hasConfContraError = true;
      this._errorTextConfContra = 'Las contraseñas son diferentes';
    }else{
      this._hasConfContraError = false;
      this._errorTextConfContra = null;
    }
    notifyListeners();
  }

  repoInfoContraAct(String text){
    this._textContraAct = text;
    notifyListeners();
  }

  Future<bool> cambiarContrasena() async{
    bool allOK = false;
    this._isLoading = true;
    String contraActual = prefs.password;
    if(contraActual != this._textContraAct){
      this._errorTextContraAct = 'La contraseña actual ingresada no es la correcta';
    }else{
      this._errorTextContraAct = null;
      if(this.hasContraError){
        this._errorTextContra = 'Campo vacío';
      }else if(this.hasConfContraError){
        this._errorTextConfContra = 'Campo vacío';
      }else{
        this._errorTextContra = null;
        this._errorTextConfContra = null;

        final res = await b2wProvider.cambiarContrasena(
            prefs.email,
            prefs.password,
            this._textContra
        );

        if(res == 'OK'){
          prefs.password = this._textContra;
          allOK = true;
        }else{
          this._errorTextContraAct = res;
        }

      }
    }
    this._isLoading = false;
    notifyListeners();
    return allOK;
  }

}
