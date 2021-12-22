import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:monitor_ia/src/models/companies_model.dart';
import 'package:monitor_ia/src/models/registro_usuario_model.dart';
import 'package:monitor_ia/src/pages/aviso_privacidad_page.dart';
import 'package:monitor_ia/src/pages/login_page.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';
import 'package:monitor_ia/src/widgets/gradient_app_bar_widget.dart';
import 'package:monitor_ia/src/widgets/custom_input_basic_widget.dart';
import 'package:monitor_ia/src/widgets/snack_message_widget.dart';

const String label_registro_b2w = 'Registro Spaces';
const String label_campos_requeridos = '*Campos requeridos';
const String label_registrar = 'Registrar';
const String label_ya_tienes_cuenta = '¿Ya tienes una cuenta? ';
const String label_ingresa_ahora = 'Ingresa ahora';
const String label_nombre = '*Nombre';
const String label_ape_p = '*Apellido Paterno';
const String label_ape_m = '*Apellido Materno';
const String label_telefono = '*Teléfono';
const String label_correo_electronico = '*Correo Electrónico';
const String label_contrasena = '*Contraseña';
const String label_he_leido_y_acepto = '*He leído y acepto el ';
const String label_aviso_de_privacidad = 'Aviso de privacidad ';
const String label_para_el_uso_de_b2w = 'para el uso de B2W';

const String label_registro = 'Registro';
const String label_cancelar = 'Cancelar';
const String label_continuar = 'Continuar';
const String label_title_success_registro = '¡Registro exitoso!';
const String label_message_success_registro =
    'El registro se realizó de manera exitosa';
const String label_title_error = '¡Registro fallido!';
const String label_message_error =
    'Ocurrió un error con el registro, verifica tus datos';
const String label_title_error_form = '¡Error de captura!';
const String label_error_campo_nombre = 'El campo nombre no debe ir vacio';
const String label_error_campo_ape_pat =
    'El campo apellido paterno no debe ir vacio';
const String label_error_campo_ape_mat =
    'El campo apellido materno no debe ir vacio';
const String label_error_campo_fecha_nac =
    'El campo fecha de nacimiento no debe ir vacio';
const String label_error_campo_sexo = 'Seleccione un sexo';
const String label_error_campo_telefono = 'El campo teléfono no debe ir vacio';
const String label_error_campo_usuario = 'Seleccione un tipo de usuario';
const String label_error_campo_email = 'El campo email no debe ir vacio';
const String label_error_campo_contra = 'El campo contraseña no debe ir vacio';
const String label_error_campo_tyc = 'Debe aceptar los terminos y condiciones';

const String path_asset_image = 'assets/img/group_mask.png';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  DateTime _selectedDate;
  Color colorBotonontinuar = HexColor("#BDCDEE");
  bool _isLoadingData = false;

  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoPController = TextEditingController();
  TextEditingController _apellidoMController = TextEditingController();
  TextEditingController _fechaNacimientoController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;

  final dataProvider = new B2WProvider();

  List<Company> _companies;
  Company _company;

  String _sexo;
  String dropDownValueSexo;
  List<String> _listaSexo = ['Femenino', 'Masculino'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getAlldata();
    });
  }

  _getAlldata() async{
    final companies = await dataProvider.getCompanies();
    _companies = companies;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _cargarFondo(),
          _formulario(context),
          _botonRegistrar()
        ],
      ),
    );
  }

  Widget _cargarFondo() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
    );
  }

  Widget _formulario(BuildContext context){
    return Column(
      children: <Widget>[
        GradientAppBar(label_registro_b2w),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 30),
                _camposRequeridosLabel(),
                SizedBox(height: 15),
                CustomInputBasic(
                  placeHolder: label_nombre,
                  textController: _nombreController,
                  textInputType: TextInputType.name,
                ),
                CustomInputBasic(
                  placeHolder: label_ape_p,
                  textController: _apellidoPController,
                  textInputType: TextInputType.name,
                ),
                CustomInputBasic(
                  placeHolder: label_ape_m,
                  textController: _apellidoMController,
                  textInputType: TextInputType.name,
                ),
                _fechaNacimiento(),
                SizedBox(height: 15),
                _telefono(),
                SizedBox(height: 15),
                _companies == null
                    ? CircularProgressIndicator()
                    : _companies.isEmpty
                    ? Center(child: Text('No hay información'),)
                    : _dropDownCompany(_companies),
                SizedBox(height: 15),
                _selectSexo(),
                SizedBox(height: 15),
                CustomInputBasic(
                  placeHolder: label_correo_electronico,
                  textController: _emailController,
                  textInputType: TextInputType.emailAddress,
                ),
                CustomInputBasic(
                  placeHolder: label_contrasena,
                  textController: _passwordController,
                  textInputType: TextInputType.visiblePassword,
                  isPassword: true,
                ),
                _terminos(),
                SizedBox(height: 30),
                _labelIngresaAhora(),
                SizedBox(height: 120),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _camposRequeridosLabel() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Text(
          label_campos_requeridos,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16
          )),
    );
  }


  Widget _fechaNacimiento() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Fecha de nacimiento',
          fillColor: Colors.white,
          filled: true,
        ),
        controller: _fechaNacimientoController,
        onTap: () {
          _selectDate(context);
        },
      ),
    );
  }

  Widget _dropDownCompany(List<Company> companies){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: DropdownButtonFormField(
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30),
        style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.black, fontSize: 19),
          hintText: 'Selecciona empresa',
        ),
        items: companies.map<DropdownMenuItem<Company>>(
                (Company value) {
              return DropdownMenuItem<Company>(
                value: value,
                child: FittedBox(
                  child: Row(
                    children: [
                      Icon(Icons.location_city, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(value.name),
                    ],
                  ),
                ),
              );
            }).toList(),
        value: _company,
        onChanged: (Company value) {
          _company = value;
          setState(() {});
        },
      ),
    );
  }

/*  Widget _sexoTelefono(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: <Widget>[
          _selectSexo(),
          SizedBox(width: 10.0),
          _telefono()
        ],
      ),
    );
  }*/

  Widget _selectSexo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(0.0),
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: "Sexo",
            fillColor: Colors.white),
        value: dropDownValueSexo,
        onChanged: (String Value) {
          setState(() {
            dropDownValueSexo = Value;
          });
        },
        items: _listaSexo
            .map((sexo) => DropdownMenuItem(
            value: sexo, child: Text("$sexo")))
            .toList(),
      ),
    );
  }

  Widget _telefono() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: _telefonoController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: '*Teléfono',
            fillColor: Colors.white,
            filled: true),
      ),
    );
  }


  Widget _terminos() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: [
          Checkbox(
              value: rememberMe,
              checkColor: Colors.red,
              activeColor: Colors.white,
              onChanged: (val) {
                rememberMe = val;
                setState(() {});
              }),
          Expanded(
            child: RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: label_he_leido_y_acepto,
                          style: TextStyle(color: Colors.black, fontSize: 16)
                      ),
                      TextSpan(
                        text: label_aviso_de_privacidad,
                        style: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontSize: 16
                        ),
                        recognizer:  TapGestureRecognizer()..onTap = () {
                          // Single tapped.
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AvisoPrivacidadPage()
                              ));
                        },
                      ),
                      TextSpan(
                          text: label_para_el_uso_de_b2w,
                          style: TextStyle(color: Colors.black, fontSize: 16)
                      ),
                    ]
                )
            ),
          )
        ],
      ),
    );
  }

  Widget _botonRegistrar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.green[400]],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.5, 8.0),
                stops: [0.0, 0.5],
                tileMode: TileMode.clamp),
          ),
          child: InkWell(
            onTap: () => _registerUser(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 80.0,
                        vertical: 15.0
                    ),
                    child: _isLoadingData
                        ? Container(
                        height: 20.0,
                        width: 20.0,
                        child: Center(child: CircularProgressIndicator()))
                        : Text(
                      label_registrar,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        locale : const Locale("es","ES"),
        context: context,
        initialDate: _selectedDate != null
            ? _selectedDate
            : DateTime.now().subtract(Duration(days: 5475)),
        firstDate: DateTime(1940),
        lastDate: DateTime.now().subtract(Duration(days: 5475)),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: HexColor('#C70039'),
                onPrimary: Colors.white,
                surface: HexColor('#C70039'),
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      final f = new DateFormat('yyyy-MM-dd');
      _fechaNacimientoController
        ..text = f.format(_selectedDate)
        ..selection = TextSelection.fromPosition(
            TextPosition(
                offset: _fechaNacimientoController.text.length,
                affinity: TextAffinity.upstream
            )
        );
    }
  }

  Widget _labelIngresaAhora(){
    return RichText(
      text: new TextSpan(
        style: new TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(text: label_ya_tienes_cuenta),
          TextSpan(
              text: label_ingresa_ahora,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
              recognizer: TapGestureRecognizer()..onTap = (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage())
                );
              }),
        ],
      ),
    );

  }

  _registerUser(BuildContext context) async {
    if (_nombreController.text.isEmpty) {
      showMessageError(
          context, label_title_error_form, label_error_campo_nombre);
    } else if (_apellidoPController.text.isEmpty) {
      showMessageError(
          context, label_title_error_form, label_error_campo_ape_pat);
    } else if (_apellidoMController.text.isEmpty) {
      showMessageError(
          context, label_title_error_form, label_error_campo_ape_mat);
    }/* else if (_fechaNacimientoController.text.isEmpty) {
      showMessageError(
          context, label_title_error_form, label_error_campo_fecha_nac);
    } else if (dropDownValueSexo!.isEmpty) {
      showMessageError(context, label_title_error_form, label_error_campo_sexo);
    }*/ else if (_telefonoController.text.isEmpty) {
      showMessageError(
          context, label_title_error_form, label_error_campo_telefono);
    } else if (_emailController.text.isEmpty) {
      showMessageError(
          context, label_title_error_form, label_error_campo_email);
    } else if (_passwordController.text.isEmpty) {
      showMessageError(
          context, label_title_error_form, label_error_campo_contra);
    } else if (rememberMe == false) {
      showMessageError(context, label_title_error_form, label_error_campo_tyc);
    } else {
      _isLoadingData = true;
      setState(() {});
      String date = _fechaNacimientoController.text;
      /*String fechaFormateada = date.replaceAll("-", "");
      String dateWithT = fechaFormateada.substring(0, 8) + "T00:00:00.000Z";
      DateTime fechaNacimiento = DateTime.parse(dateWithT);*/
      DateTime fechaNacimiento;
      //print('fecha nacimiento : ${_fechaNacimientoController.text}');
      if(_fechaNacimientoController.text != ''){
        String date =_fechaNacimientoController.text;
        String fechaFormateada = date.replaceAll("-", "");
        String dateWithT = fechaFormateada.substring(0, 8) + 'T' + "00:00:00.000Z";
        fechaNacimiento = DateTime.parse(dateWithT);
      }

      if(dropDownValueSexo != null){
        if (dropDownValueSexo == 'Femenino') {
          _sexo = 'F';
        } else {
          _sexo = 'M';
        }
      }

      RegistroUsuario registroUsuario = new RegistroUsuario(
        birthdate: fechaNacimiento,
        creationDate: DateTime.now(),
        email: _emailController.text,
        gender: _sexo,
        hash: '',
        idCatSource: 1,
        idCatUserType: 1,
        idCompany: _company.idCatCompany,
        idCredential: 0,
        idUser: 0,
        maternalSurname: _apellidoMController.text,
        name: _nombreController.text,
        password: _passwordController.text,
        surname: _apellidoPController.text,
        usuarioMonitor: 0
      );

      RegistroUsuario info =
      await dataProvider.registraUsuario(registroUsuario);
      if (info != null) {
        _isLoadingData = false;
        setState(() {});
        showMessageOK(context, label_title_success_registro,
            label_message_success_registro);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        _isLoadingData = false;
        setState(() {});
        showMessageError(context, label_title_error, label_message_error);
      }
    }
  }
}
