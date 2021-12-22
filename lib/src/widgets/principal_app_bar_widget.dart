import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:monitor_ia/src/providers/image_provider.dart';
import 'package:monitor_ia/src/providers/tutorial_management_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/widgets/user_custom_dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:monitor_ia/src/providers/notifications_provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const String label_titulo_kb1 = 'Nombre y ID de seguimiento';
const String label_mensaje_kb1 = 'Este es el nombre con el que te registraste al crear tu cuenta, además de tu ID de seguimiento para identificarte en la app\n\nToca para continuar el recorrido';
const String label_titulo_kb2 = 'Datos de perfil y cuenta';
const String label_mensaje_kb2 = 'Al tocar aquí, aparecerá un diálogo donde podrás cambiar tu foto de perfil, cerrar sesión, consultar algunos datos de cuenta y más\n\nToca para continuar el recorrido';

class PrincipalAppBar extends StatefulWidget {
  final String title;
  final String subtitle;

  PrincipalAppBar(this.title, this.subtitle);

  @override
  State<PrincipalAppBar> createState() => _PrincipalAppBarState();
}

class _PrincipalAppBarState extends State<PrincipalAppBar> {
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton0 = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getAlldata();
    });
  }

  _getAlldata() async{
    final notificationListProvider = Provider.of<NotificationsProvider>(
        context,
        listen: false
    );

    notificationListProvider.loadLastNotification();

    if(prefs.firstTutAppBar) {
      initTargets();
      showTutorial();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationListProvider = Provider.of<NotificationsProvider>(context);
    final imageProvider = Provider.of<ImageProviderApp>(context);

    return Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [HexColor('#02E8CC'), HexColor('#D9FCF8')],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 5.0),
              stops: [0.0, 0.5],
              tileMode: TileMode.clamp
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: SafeArea(
            child: Column(
              children: [
                _header(context, imageProvider),
                SizedBox(height: 5),
                notificationListProvider.lastNotification == null
                ? Container()
                : _currentNotification(notificationListProvider)
              ],
            ),
          ),
        ));
  }

  Widget _header(BuildContext context, ImageProviderApp imageProvider) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  key: keyButton0,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerTextBig(this.widget.title),
                    _headerTextSmall(this.widget.subtitle)
                  ],
                ),
              ),
              _profilePicture(imageProvider)
            ],
          );
  }

  Widget _headerTextBig(String text) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 19.0)
      ),
    );
  }

  Widget _headerTextSmall(String content) {
    return Container(
      width: 250,
      child: Text(
          content,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          softWrap: true,
          textAlign: TextAlign.justify,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 14.0)
      ),
    );
  }

  Widget _profilePicture(ImageProviderApp imageProvider) {
    return GestureDetector(
      key: keyButton1,
      onTap: () {
        showDialog(context: context,
            builder: (BuildContext context){
              return UserCustomDialog();
            }
        );
      },
      child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.0),
              child: imageProvider.imageFile != null
                  ? Image.file(
                      imageProvider.imageFile,
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/img/avatar_profile.png',
                      scale: 2,
                    ))
            ),
    );
  }

  Widget _currentNotification(NotificationsProvider notificationsProvider){
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      child: notificationsProvider.showNotification ? ClipRect(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.35)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _headerTextBig(notificationsProvider.lastNotification.title),
                  _closeButton(notificationsProvider),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10),
                      _headerTextSmall(notificationsProvider.lastNotification.contenido),
                      SizedBox(height: 10),
                      _headerTextSmall(
                          'Recibido: ${dateConverted(
                              notificationsProvider.lastNotification.fechaDeEntrega
                          )}'),
                    ],
                  ),
                  Container(
                    child: Image(
                        image: AssetImage('assets/img/bell.png'),
                        width: 55,
                        height: 55
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          : Container()
    );
  }

  String dateConverted(String fechaDeEntrega){
    final loadedTime = DateTime.parse(fechaDeEntrega);
    final now = new DateTime.now();
    final difference = now.difference(loadedTime);
    return  timeago.format(now.subtract(difference), locale: 'es');
  }

  Widget _closeButton(NotificationsProvider notificationsProvider) {
    return GestureDetector(
      onTap: () {
        notificationsProvider.showNotification = false;
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: Icon(Icons.close, size: 25, color: Colors.red,),
      ),
    );
  }


  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton0,
        color: Colors.black12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label_titulo_kb1,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      label_mensaje_kb1,
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
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton1,
        color: Colors.purple,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label_titulo_kb2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      label_mensaje_kb2,
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
    final tutorialProvider = Provider.of<TutorialManagementProvider>(context, listen: false);
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      textSkip: 'Saltar',
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        prefs.firstTutAppBar = false;
        tutorialProvider.canInitSecondTutorial = true;
      },
      onClickTarget: (target) {
        prefs.firstTutAppBar = false;
      },
      onSkip: () {
        prefs.firstTutAppBar = false;
        tutorialProvider.canInitSecondTutorial = true;
      },
      onClickOverlay: (target) {
        prefs.firstTutAppBar = false;
      },
    )..show();
  }

}
