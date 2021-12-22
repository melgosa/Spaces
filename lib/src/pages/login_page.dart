import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:monitor_ia/src/blocs/login_bloc.dart';
import 'package:monitor_ia/src/pages/principal_page.dart';
import 'package:monitor_ia/src/pages/registro_page.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';
import 'package:monitor_ia/src/providers/login_provider.dart';
import 'package:monitor_ia/src/utils/utils.dart';
import 'package:monitor_ia/src/widgets/gradient_app_bar_widget.dart';

const String label_no_tienes_cuenta = '¿No tienes una cuenta? ';
const String label_registrate_ahora = 'Regístrate ahora';
const String label_error_al_iniciar_sesion = 'Error al iniciar de sesión';
const String label_ingresar =  'Ingresar';
const String label_iniciando = 'Iniciando...';
const String label_contrasena = 'Contraseña';
const String label_ingresa_tu_correo = 'Ingresa tu correo';
const String label_b2w_login = 'Spaces Login';

const String path_asset_image = 'assets/img/spaces.png';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dataProvider = new B2WProvider();
  bool _obscureText = true;
  bool _ischarginDataLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _cargarFondo(),
          _cargarVistaLogin(),
        ],
      ),
    );
  }

  Widget _cargarFondo() {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _cargarVistaLogin() {
    final bloc = LoginProvider.of(context);
    return SafeArea(
      child: Center(
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GradientAppBar(label_b2w_login),
                SizedBox(height: 40),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: 125,
                  child: Image(
                    image: AssetImage(path_asset_image),
                    width: 200,
                    height: 200
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0
                  ),
                  child: Column(
                    children: [
                      _crearEmail(bloc),
                      SizedBox(height: 10),
                      _crearPassword(bloc),
                      SizedBox(height: 40),
                      _crearBotonLogin(bloc),
                      SizedBox(height: 40),
                      _labelRegistrateAhora(),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: TextField(
              cursorColor: Colors.blueAccent,
              cursorWidth: 5,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
              onChanged: bloc.changeEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.email_outlined,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  filled: true,
                  focusColor: Colors.white,
                  fillColor: Colors.white,
                  label: Text(
                    label_ingresa_tu_correo,
                    style: TextStyle(color: Colors.grey)
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  errorStyle: TextStyle(color: Colors.red),
                  errorText: snapshot.error),
            ));
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: TextField(
              cursorColor: Colors.blueAccent,
              cursorWidth: 5,
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscureText,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock_outline,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.blueAccent,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  filled: true,
                  focusColor: Colors.white,
                  fillColor: Colors.white,
                  label: Text(
                    label_contrasena,
                    style: TextStyle(color: Colors.grey)
                  ),
                  errorStyle: TextStyle(color: Colors.red),
                  errorText: snapshot.error),
              onChanged: bloc.changePassword,
            ));
      },
    );
  }

  Widget _crearBotonLogin(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: new LinearGradient(
                colors: [Colors.blueAccent, Colors.green[400]],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.5, 8.0),
                stops: [0.0, 0.5],
                tileMode: TileMode.clamp),
          ),
          child: InkWell(
            onTap: (snapshot.hasData && !_ischarginDataLogin)
                ? () =>  _login(bloc, context)
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 80.0,
                        vertical: 15.0
                    ),
                    child: _ischarginDataLogin
                        ? Text(
                      label_iniciando,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),)
                        : Text(
                      label_ingresar,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),)
                ),
                Visibility(
                    visible: _ischarginDataLogin,
                    child: CircularProgressIndicator()
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    _ischarginDataLogin = true;
    setState(() {
    });

    String info = await dataProvider.login(bloc.email, bloc.password);

    if (info == 'OK') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PrincipalPage()));
    }else if(info == 'BasalNull'){
      print('BASAL NULL');
    } else if(info == 'colorNotOK'){
      print('RIESGO ALTO');
    }else {
      mostrarAlerta(context, label_error_al_iniciar_sesion, info);
    }

    setState(() {
      _ischarginDataLogin = false;
    });
  }

  Widget _labelRegistrateAhora(){
    return RichText(
      text: new TextSpan(
        style: new TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(text: label_no_tienes_cuenta),
          TextSpan(
              text: label_registrate_ahora,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
              recognizer: TapGestureRecognizer()..onTap = (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegistroPage())
                );
              }),
        ],
      ),
    );

  }
}
