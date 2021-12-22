import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:monitor_ia/src/providers/b2w_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/widgets/background_polygons_widget.dart';
import 'package:monitor_ia/src/widgets/cambio_contrasena_dialog_widget.dart';
import 'package:monitor_ia/src/widgets/principal_app_bar_widget.dart';

const String label_saltar = 'Saltar';
const String label_titulo_kb0 = 'Datos de tu cuenta (Perfil)';
const String label_mensaje_kb0 = 'Aquí encontraras un listado de la información más relevante de tu cuenta, como nombre, correo, empresa o entidad, etc.\n\nToca para finalizar el recorrido en esta pantalla';
const String label_id_de_seguimiento = 'ID de Seguimiento:';
const String label_hola = '¡Hola';
const String label_nombre = 'Nombre';
const String label_correo = 'Correo';
const String label_id_de_usuario = 'ID de usuario';
const String label_empresa_asociada = 'Empresa asociada';
const String label_contrasena = 'Contraseña';
const String label_toca_para_editar = 'Toca para editar';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final prefs = new PreferenciasUsuario();
  final dataProvider = new B2WProvider();
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton0 = GlobalKey();


  @override
  Widget build(BuildContext context) {
    if(prefs.firstTutPerfil) {
      showTutorial();
      initTargets();
    }
    return Scaffold(
      body: Stack(
        children: [
          BackgroundPolygons(
              HexColor('#ABFCF3'),
              HexColor('#ABFCF3'),
              HexColor('#02E8CC'),
              HexColor('#02E8CC')),
          _cargarVistaPerfil(),
        ],
      ),
    );
  }

  Widget _cargarVistaPerfil() {
    return Column(
      children: [
        PrincipalAppBar('$label_hola ${prefs.userName}!', '$label_id_de_seguimiento ${prefs.userId}'),
        SizedBox(height: 20),
        Expanded(
          key: keyButton0,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                _userDataIcon(
                    label_nombre,
                    prefs.userName,
                    false,
                    HexColor('#3498DB'),
                    Icon(Icons.person, color: HexColor('#3498DB'), size: 30)
                ),
                SizedBox(height: 10),
                _userDataIcon(
                    label_correo,
                    prefs.email,
                    false,
                    HexColor('#CD6155'),
                    Icon(Icons.email, color: HexColor('#CD6155'), size: 30)
                ),
                SizedBox(height: 10),
                _userDataIcon(
                    label_id_de_usuario,
                    '${prefs.userId}',
                    false,
                    HexColor('#FFC300'),
                    Icon(Icons.important_devices, color: HexColor('#FFC300'), size: 30)
                ),
                SizedBox(height: 10),
                _userDataIcon(
                    label_empresa_asociada,
                    prefs.empresa,
                    false,
                    HexColor('#1ABC9C'),
                    Icon(Icons.home_work_outlined, color: HexColor('#1ABC9C'), size: 30)
                ),
                SizedBox(height: 10),
                _userDataIcon(
                    label_contrasena,
                    '*****',
                    true,
                    HexColor('#909497'),
                    Icon(Icons.password, color: HexColor('#909497'), size: 30)
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _userDataIcon(
      String title,
      String subtitle,
      bool isEditable,
      Color backgroundColor,
      Icon icon
      ) {
    return GestureDetector(
      onTap: isEditable ? _openDialogChangePassword : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerTextBig(title),
                  SizedBox(height: 5),
                  _headerTextSmall(subtitle, Colors.white),
                  SizedBox(height: 15),
                  isEditable ? _headerTextSmall(label_toca_para_editar, Colors.white) : Container()
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(color: Colors.white),
                  child: icon,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _openDialogChangePassword(){
    showDialog(context: context,
        builder: (BuildContext context){
          return CambioContrasenaDialog();
        }
    );
  }

  Widget _headerTextBig(String text) {
    return Text(
        text,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 19.0)
    );
  }

  Widget _headerTextSmall(String content, Color fontColor) {
    return Container(
      width: 250,
      child: Text(
          content,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          softWrap: true,
          style: TextStyle(
              color: fontColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 14.0)
      ),
    );
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton0,
        color: Colors.deepOrangeAccent,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label_titulo_kb0,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      label_mensaje_kb0,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      textSkip: label_saltar,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        prefs.firstTutPerfil = false;
      },
      onClickTarget: (target) {
        prefs.firstTutPerfil = false;
      },
      onSkip: () {
        prefs.firstTutPerfil = false;
      },
      onClickOverlay: (target) {
        prefs.firstTutPerfil = false;
      },
    )..show();
  }
}
