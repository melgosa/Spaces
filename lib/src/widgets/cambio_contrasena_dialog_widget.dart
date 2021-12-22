import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:monitor_ia/src/providers/cambiar_contrasena_provider.dart';
import 'package:monitor_ia/src/providers/image_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/widgets/snack_message_widget.dart';


const String label_title = 'Selecciona el intervalo';
const String label_description = 'Este intervalo sera el periodo de tiempo, en minutos, en el cual se enviará tu geolocalización';
const String label_possitive_button = 'Establecer';
const String label_negative_button = 'Cancelar';
const String label_contrasena_actualizada = 'Contraseña actualizada correctamente';
const String label_todo_bien = '¡Todo bien!';

const String path_asset = 'assets/img/profile.jpg';

class CambioContrasenaDialog extends StatefulWidget {

  @override
  _CambioContrasenaDialogState createState() => _CambioContrasenaDialogState();
}

class _CambioContrasenaDialogState extends State<CambioContrasenaDialog> {
  static const double padding =20;
  static const double avatarRadius =45;

  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController confirmarContrasenaController = TextEditingController();
  final TextEditingController contrasenaActController = TextEditingController();


  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageProviderApp>(context);
    final cambiarContrasenaProvider = Provider.of<CambiarContrasenaProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, imageProvider, cambiarContrasenaProvider),
    );
  }

  contentBox(
      context,
      ImageProviderApp imageProviderApp,
      CambiarContrasenaProvider cambiarContrasenaProvider
      ){
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
                    contrasenaActual(cambiarContrasenaProvider),
                    SizedBox(height: 20),
                    contrasena(cambiarContrasenaProvider),
                    SizedBox(height: 20),
                    confirmaContrasena(cambiarContrasenaProvider),
                    SizedBox(height: 20),
                    _changePasswordOptions(cambiarContrasenaProvider)
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

  Widget contrasenaActual(CambiarContrasenaProvider cambiarContrasenaProvider){
    return TextField(
      obscureText: cambiarContrasenaProvider.obscureTextContraAct,
      controller: this.contrasenaActController,
      autocorrect: false,
      keyboardType: TextInputType.text,
      onChanged: cambiarContrasenaProvider.repoInfoContraAct,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              cambiarContrasenaProvider.obscureTextContraAct
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: HexColor('#02E8CC'),
              size: 30,
            ),
            onPressed: () {
              cambiarContrasenaProvider.obscureTextContraAct
              = !cambiarContrasenaProvider.obscureTextContraAct;
            },
          ),
          fillColor: Colors.white,
          filled: true,
          errorStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          errorText: cambiarContrasenaProvider.errorTextContraAct,
          label: Text('Ingresa contraseña actual')),
    );
  }

  Widget contrasena(CambiarContrasenaProvider cambiarContrasenaProvider){
    return TextField(
      obscureText: cambiarContrasenaProvider.obscureTextContra,
      controller: this.contrasenaController,
      autocorrect: false,
      keyboardType: TextInputType.text,
      onChanged: cambiarContrasenaProvider.repoInfoContra,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              cambiarContrasenaProvider.obscureTextContra
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: HexColor('#02E8CC'),
              size: 30,
            ),
            onPressed: () {
                cambiarContrasenaProvider.obscureTextContra
                = !cambiarContrasenaProvider.obscureTextContra;
            },
          ),
          fillColor: Colors.white,
          filled: true,
          errorStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          errorText: cambiarContrasenaProvider.errorTextContra,
          label: Text('Ingresa nueva contraseña')),
    );
  }

  Widget confirmaContrasena(CambiarContrasenaProvider cambiarContrasenaProvider){
    return TextField(
      obscureText: cambiarContrasenaProvider.obscureTextConfContra,
      controller: this.confirmarContrasenaController,
      autocorrect: false,
      keyboardType: TextInputType.text,
      onChanged: cambiarContrasenaProvider.repoInfoConfContra,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              cambiarContrasenaProvider.obscureTextConfContra
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: HexColor('#02E8CC'),
              size: 30,
            ),
            onPressed: () {
              setState(() {
                cambiarContrasenaProvider.obscureTextConfContra
                = !cambiarContrasenaProvider.obscureTextConfContra;
              });
            },
          ),
          fillColor: Colors.white,
          filled: true,
          errorStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          errorText: cambiarContrasenaProvider.errorTextConfContra,
          label: Text('Confirma nueva contraseña')),
    );
  }

  Widget _changePasswordOptions(
      CambiarContrasenaProvider cambiarContrasenaProvider) {
    return cambiarContrasenaProvider.isLoading
        ? CircularProgressIndicator()
        : Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _boton('Cancelar', true, cambiarContrasenaProvider),
                SizedBox(width: 10),
                _boton('Actualizar', false, cambiarContrasenaProvider),
              ],
            ),
          );
  }

  Widget _boton(
      String text,
      bool closeDialog,
      CambiarContrasenaProvider cambiarContrasenaProvider
      ) {
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
        onPressed: () async{
          if(closeDialog){
            Navigator.pop(context);
          }else{
            final res = await cambiarContrasenaProvider.cambiarContrasena();
            if(res){
              Navigator.of(context).pop();
              showMessageOK(context, label_todo_bien, label_contrasena_actualizada);
            }
          }
        },
      ),
    );
  }
}