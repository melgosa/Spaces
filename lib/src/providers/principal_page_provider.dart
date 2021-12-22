import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';

class PrincipalPageProvider with ChangeNotifier{
  final prefs = PreferenciasUsuario();
  bool _canStartApp = false;

  bool get canStartApp => this._canStartApp;

  Future<PermissionStatus> permissionStatus() async {
    var status = await Permission.location.status;

    if(status.isGranted)
      this._canStartApp = true;
    else
      this._canStartApp = false;

    notifyListeners();

    return status;
  }

  validatePermissions() async{
    if(Platform.isAndroid){
      print('ENTRA A PERMISOS PLATAFORMA ANDROID');
      var status = await Permission.location.status;
      if(!status.isGranted){
        //print('Permiso 1');
        var status = await Permission.location.request();
        print('STATUS PERMISSION: ${status.toString()}');
        if(status.isGranted){
          //print('Permiso 2');
          this._canStartApp = true;
          var status = await Permission.locationAlways.request();
          if(status.isGranted){
            //print('Permiso 3');
          }else{
            //print('No aceprto el pemriso always');
          }
        }else{
          this._canStartApp = false;
        }
      }else{
        print('ENTRA PERMISO EN PRIMER PLANO HABILITADO');
        var status = await Permission.locationAlways.status;
        if(!status.isGranted){
          print('SE PIDE PERMISOS EN SEGUNDO PLANO');
          await Permission.locationAlways.request();
          this._canStartApp = true;
        }else{
          print('PUEDE INICIAR LA APP');
          this._canStartApp = true;
        }
      }
    }else{
      //Primero se pide el status del permiso de ubicacion cuando esta en uso
      print('Se pide estatus de permiso in use ios');
      var status = await Permission.locationWhenInUse.status;
      print('STATUS PERMISSION 1: ${status.toString()}');
      if(!status.isGranted){
        print('El permiso in use no estaba habilitado, se pide el permiso ios');
        var status = await Permission.locationWhenInUse.request();
        print('STATUS PERMISSION 2: ${status.toString()}');
        if(status.isGranted){
          print('Se habilito el permiso correctamente in use ios');
          this._canStartApp = true;
          var status = await Permission.locationAlways.request();
          if(status.isGranted){
            print('Permiso en segundo plano always habiltado ios');
          }else{
            print('Permiso en segundo plano always NO habiltado ios');
          }
        }else{
          print('No habilito permiso in Use ios');
          this._canStartApp = false;
        }
        if(status.isPermanentlyDenied){
          bool res = await openAppSettings();
          print('Open app settings : $res');
        }
      }else{
        //El permiso cuando la app esta en uso ya esta habilitado, verificar el always
        print('Se verifica estaus de permiso always en ios');
        var status = await Permission.locationAlways.status;
        if(!status.isGranted){
          print('Permiso no habuiluitado, se solicita permiso al usuario en ios');
          var status = await Permission.locationAlways.request();
          if(status.isGranted){
            print('Se habilito permiso always en ios');
            this._canStartApp = true;
          }else{
            print('NOooo Se habilito permiso always en ios');
            this._canStartApp = true;
          }
        }else{
          print('Ya estaba habilitado el permiso always en ios');
          this._canStartApp = true;
        }
      }
    }
    notifyListeners();
/*      print('ENTRA A PERMISOS PLATAFORMA ANDROID');
      var status = await Permission.location.status;
      if(!status.isGranted){
        //print('Permiso 1');
        var status = await Permission.location.request();
        print('STATUS PERMISSION: ${status.toString()}');
        if(status.isGranted){
          //print('Permiso 2');
          this._canStartApp = true;
          var status = await Permission.locationAlways.request();
          if(status.isGranted){
            //print('Permiso 3');
          }else{
            //print('No aceprto el pemriso always');
          }
        }else{
          this._canStartApp = false;
        }
      }else{
        print('ENTRA PERMISO EN PRIMER PLANO HABILITADO');
        var status = await Permission.locationAlways.status;
        if(!status.isGranted){
          print('SE PIDE PERMISOS EN SEGUNDO PLANO');
          await Permission.locationAlways.request();
          this._canStartApp = true;
        }else{
          print('PUEDE INICIAR LA APP');
          this._canStartApp = true;
        }
      }*/
  }

}