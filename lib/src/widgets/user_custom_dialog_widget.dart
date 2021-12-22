import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monitor_ia/src/pages/login_page.dart';
import 'package:monitor_ia/src/providers/image_provider.dart';

import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:provider/provider.dart';


const String label_title = 'Selecciona el intervalo';
const String label_description = 'Este intervalo sera el periodo de tiempo, en minutos, en el cual se enviará tu geolocalización';
const String label_possitive_button = 'Establecer';
const String label_negative_button = 'Cancelar';
const String label_cambios_guardados = 'Cambios guardados correctamente';
const String label_todo_bien = '¡Todo bien!';

const String path_asset = 'assets/img/profile.jpg';

class UserCustomDialog extends StatefulWidget {

  @override
  _UserCustomDialogState createState() => _UserCustomDialogState();
}

class _UserCustomDialogState extends State<UserCustomDialog> {
  static const double padding =20;
  static const double avatarRadius =45;


  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageProviderApp>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, imageProvider),
    );
  }

  contentBox(context, ImageProviderApp imageProviderApp){
    //if(imageProviderApp.path.length > 0)
      //_file = File(imageProviderApp.path);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: padding,
              top: avatarRadius + padding,
              right: padding,
              bottom: padding
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: HexColor('#02E8CC'),
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    _userName(),
                  SizedBox(height: 20),
                    _dataUserRow(
                      Icon(Icons.mail, color: Colors.black, size: 25),
                      prefs.email,
                      15
                  ),
                  SizedBox(height: 20),
                  _dataUserRow(
                      Icon(Icons.emoji_transportation, color: Colors.black, size: 25),
                      prefs.empresa,
                      15
                  ),
                  SizedBox(height: 20),
                  _dataUserRow(
                      Icon(Icons.how_to_reg, color: Colors.black, size: 25),
                      prefs.userId.toString(),
                      15
                  ),
                  SizedBox(height: 40),
                  _logout(),
                  SizedBox(height: 30),
                  _changeProfilePhoto(),
                  SizedBox(height: 20),
                  _changePhotoOptions(imageProviderApp),
                ],
              ),
            ),
          )
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: imageProviderApp.imageFile != null
                    ? Image.file(
                        imageProviderApp.imageFile,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      )
                    : Image.asset('assets/img/avatar_profile.png')
                ),
          ),
        ),
      ],
    );
  }

  Text _userName() {
    return Text(prefs.userName,
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500));
  }

  Row _dataUserRow(Icon icon, String text, double textSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: 10),
        Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: textSize,
                fontWeight: FontWeight.w300)
        ),
      ],
    );
  }

  Widget _logout() {
    return GestureDetector(
      onTap: () async{
        await prefs.deletePreferences();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>
            LoginPage()), (Route<dynamic> route) => false
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, size: 40, color: Colors.red,),
          SizedBox(width: 10),
          Text(
              'Cerrar sesión',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600
              )
          ),
        ],
      ),
    );
  }

  Widget _changeProfilePhoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.insert_photo, size: 40, color: Colors.yellow,),
        SizedBox(width: 10),
        Text(
            'Cambiar foto',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600
            )
        ),
      ],
    );
  }

  Widget _changePhotoOptions(ImageProviderApp imageProviderApp){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _boton('Abrir cámara', imageProviderApp, true),
          SizedBox(width: 10),
          _boton('Abrir galería', imageProviderApp, false),
        ],
      ),
    );
  }

  Widget _boton(String text, ImageProviderApp imageProviderApp, bool openCamera) {
    return Expanded(
      child: RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: FittedBox(
              child: Text(
                text,
                style: TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 0.0,
          color: Colors.yellow,
          textColor: HexColor('#02E8CC'),
          onPressed: () {
            if(openCamera)
              imageProviderApp.getImage(ImageSource.camera);
            else
              imageProviderApp.getImage(ImageSource.gallery);
            //Navigator.pop(context);
          },
      ),
    );
  }
}