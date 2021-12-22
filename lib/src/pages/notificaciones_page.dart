import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:monitor_ia/src/providers/notifications_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/widgets/background_polygons_widget.dart';
import 'package:monitor_ia/src/widgets/notifications_tiles_widget.dart';
import 'package:monitor_ia/src/widgets/principal_app_bar_widget.dart';

const String label_aun_no_hay_notificaciones = 'Aún no hay notificaciones';
const String label_id_de_seguimiento = 'ID de Seguimiento:';
const String label_hola = '¡Hola';
const String label_notificaciones = 'Notificaciones';

class NotificacionesPage extends StatefulWidget {

  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  bool isThereResults = false;
  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationListProvider = Provider.of<NotificationsProvider>(context, listen: false);
      notificationListProvider.loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundPolygons(
              HexColor('#ABFCF3'),
              HexColor('#ABFCF3'),
              HexColor('#02E8CC'),
              HexColor('#02E8CC')),
          _cargarVistaNotificaciones()
        ],
      ),
    );
  }

  Widget _cargarVistaNotificaciones() {
    final notificationListProvider = Provider.of<NotificationsProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrincipalAppBar(
            '$label_hola ${prefs.userName}!',
            '$label_id_de_seguimiento ${prefs.userId}'
        ),
        _title(notificationListProvider),
        notificationListProvider.notifications.isEmpty
            ? Center(child: Text(
              label_aun_no_hay_notificaciones,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30
                )))
            : NotificationsTiles()
      ],
    );
  }

  Widget _title(NotificationsProvider notificationListProvider) {
    return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(notificationListProvider.notifications.isEmpty
                ? ''
                : '$label_notificaciones (${notificationListProvider.notifications.length})',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          );
  }

}
