import 'package:flutter/material.dart';
import 'package:monitor_ia/src/blocs/login_bloc.dart';


class LoginProvider extends InheritedWidget{
  final loginBloc = new LoginBloc();
  static LoginProvider _instancia;

  factory LoginProvider({Key key, Widget child}){
    if(_instancia == null){
      _instancia = new LoginProvider._internal(key: key, child: child,);
    }
    return _instancia;
  }

  LoginProvider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<LoginProvider>().loginBloc;
  }
}