import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monitor_ia/src/pages/inicio_page.dart';
import 'package:monitor_ia/src/pages/notificaciones_page.dart';
import 'package:monitor_ia/src/pages/perfil_page.dart';
import 'package:monitor_ia/src/providers/ui_provider.dart';
import 'package:monitor_ia/src/widgets/custom_navigatorbar.dart';

const String label_prominent_disclosure_title = 'prominent_disclosure_title';
const String label_prominent_disclosure_description = 'prominent_disclosure_description';
const String label_accept = 'accept';
const String label_channel_id = 'Spaces Channel';
const String label_channel_name = 'Spaces Notification Channel';
const String label_channel_description = 'Canal utilizado para la recepción de push notifications de la app Spaces.';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _PrincipalPageBody(),
    bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

class _PrincipalPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Obtener el selected menu opt
    final uiProvider = Provider.of<UiProvider>(context);

    //Cambiar para mostrar la pagina respectiva
    final currentIndex = uiProvider.selectedMenuOption;

    switch (currentIndex) {
      case 0:
        return InicioPage();
      case 1:
        return NotificacionesPage();
      case 2:
        return PerfilPage();
      default:
        return PerfilPage();
    }
  }
}
