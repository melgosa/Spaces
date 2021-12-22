import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:monitor_ia/src/providers/ui_provider.dart';
import 'package:provider/provider.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    return FancyBottomNavigation(
      tabs: [
        TabData(iconData: Icons.home, title: "Inicio"),
        TabData(iconData: Icons.notifications, title: "Notificaciones"),
        TabData(iconData: Icons.person, title: "Perfil")
      ],
      onTabChangedListener: (position) {
        uiProvider.selectedMenuOption = position;
      },
      barBackgroundColor: HexColor('#ABFCF3'),
      circleColor: HexColor('#02E8CC'),
      textColor: HexColor('#02E8CC'),
      inactiveIconColor: HexColor('#02E8CC'),

    );
  }
}
