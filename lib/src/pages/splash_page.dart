import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:monitor_ia/src/pages/login_page.dart';
import 'package:monitor_ia/src/pages/principal_page.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/utils/utils.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{
  final dataProvider = new B2WProvider();
  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getAlldata();
    });
  }

  _getAlldata() async{
    if(prefs.userId != 0){
      String info = await dataProvider.login(prefs.email, prefs.password);
      if(info == 'OK'){
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new PrincipalPage()));
      }else if(info == 'BasalNull'){
        print('BASAL NULLL');
      }else if(info == 'colorNotOK'){
        print('RIESGO ALTO');
      }else{
        mostrarAlerta(context, 'Error en la petición', info);
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new LoginPage()));
      }
    }else{
      print('entrando a login page');
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new LoginPage()));
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _cargarFondo(),
          _cargarVistaSplash(),
          _showLabelDerechosRes(),
        ],
      ),
    );
  }

  Widget _cargarFondo() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(Color.fromRGBO(52, 92, 106 , 0.9), BlendMode.srcOver),
        child: Image(
          fit: BoxFit.fill,
          image: AssetImage('assets/img/splash.png'),
        ),
      ),
    );
  }

  Widget _cargarVistaSplash() {
    return SafeArea(
      child: Center(
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/img/b2w_2021.png'),
              ),
              SizedBox(height: 20),
              _showLabelCargando(),
              SizedBox(height: 10),
              _showLabelUnMomento(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showLabelCargando() {
    return Text('Cargando',
      style: GoogleFonts.roboto(
        fontSize: 28,
        color: Colors.white,
      ),);
  }

  Widget _showLabelUnMomento() {
    return Text('solo un momento...',
      style: GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.white38,
      ),);
  }

  Widget _showLabelDerechosRes() {
    return Positioned(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(bottom: 50),
            child: Text(
              'Derechos reservados 2021',
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
    );
  }
}
