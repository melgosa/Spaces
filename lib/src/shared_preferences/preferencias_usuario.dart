import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
  new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    // ignore: invalid_use_of_visible_for_testing_member
    //SharedPreferences.setMockInitialValues({});
    this._prefs = await SharedPreferences.getInstance();
  }

  deletePreferences() async {
    await _prefs?.clear();
  }

  get riskScore{
    return _prefs.getInt('riskScore') ?? 0;
  }

  set riskScore(int value){
    _prefs.setInt('riskScore', value);
  }

  get riskColor{
    return _prefs.getString('riskColor') ?? 'gris';
  }

  set riskColor(String value){
    _prefs.setString('riskColor', value);
  }

  get userId{
    return _prefs.getInt('userId') ?? 0;
  }

  set userId(int value){
    _prefs.setInt('userId', value);
  }

  get firstLogin{
    return _prefs.getBool('firstLogin') ?? true;
  }

  set firstLogin(bool value){
    _prefs.setBool('firstLogin', value);
  }

  get area{
    return _prefs.getString('area') ?? '';
  }

  set area(String value){
    _prefs.setString('area', value);
  }

  get empresa{
    return _prefs.getString('empresa') ?? '';
  }

  set empresa(String value){
    _prefs.setString('empresa', value ?? 'No disponible');
  }

  get empresaid{
    return _prefs.getInt('empresaid') ?? 0;
  }

  set empresaid(int value){
    _prefs.setInt('empresaid', value);
  }

  get userName{
    return _prefs.getString('userName') ?? '';
  }

  set userName(String value) {
    _prefs.setString('userName', value);
  }

  get email{
    return _prefs.getString('correo') ?? '';
  }

  set email(String correo) {
    _prefs.setString('correo', correo);
  }

  get password{
    return _prefs.getString('password') ?? '';
  }

  set password(String password) {
    _prefs.setString('password', password);
  }

  get token{
    return _prefs.getString('token') ?? '';
  }

  set token(String token) {
    _prefs.setString('token', token);
  }

/*  get fechaUltRecord{
    return _prefs.getInt('fechaUltRecord') ?? '';
  }

  set fechaUltRecord(int timeStamp) {
    _prefs.setInt('fechaUltRecord', timeStamp);
  }*/

  get fechaUltRecord{
    return _prefs.getString('fechaUltRecord') ?? '';
  }

  set fechaUltRecord(String date) {
    _prefs.setString('fechaUltRecord', date);
  }

  get fechaRegistro{
    return _prefs.getInt('fechaRegistro') ?? 0;
  }

  set fechaRegistro(int timeStamp) {
    _prefs.setInt('fechaRegistro', timeStamp);
  }
  
  get peso{
    return _prefs.getDouble('peso') ?? 0;
  }

  set peso(double peso){
    _prefs.setDouble('peso', peso);
  }

  get estatura{
    return _prefs.getDouble('estatura') ?? 0;
  }

  set estatura(double estatura){
    _prefs.setDouble('estatura', estatura);
  }

  get firstTutAppBar{
    return _prefs.getBool('firstTutAppBar') ?? true;
  }

  set firstTutAppBar(bool value){
    _prefs.setBool('firstTutAppBar', value);
  }

  get firstTutInicio{
    return _prefs.getBool('firstTutInicio') ?? true;
  }

  set firstTutInicio(bool value){
    _prefs.setBool('firstTutInicio', value);
  }

  get firstTutPerfil{
    return _prefs.getBool('firstTutPerfil') ?? true;
  }

  set firstTutPerfil(bool value){
    _prefs.setBool('firstTutPerfil', value);
  }

  get firstTutMenuReservas{
    return _prefs.getBool('firstTutMenuReservas') ?? true;
  }

  set firstTutMenuReservas(bool value){
    _prefs.setBool('firstTutMenuReservas', value);
  }

  get firstTutBusquedaArea{
    return _prefs.getBool('firstTutBusquedaArea') ?? true;
  }

  set firstTutBusquedaArea(bool value){
    _prefs.setBool('firstTutBusquedaArea', value);
  }

  get firstTutReservas{
    return _prefs.getBool('firstTutReservas') ?? true;
  }

  set firstTutReservas(bool value){
    _prefs.setBool('firstTutReservas', value);
  }

  int get idCatVaccineCountry{
    return _prefs.getInt('idCatVaccineCountry') ?? 0;
  }

  set idCatVaccineCountry(int idCatVaccineCountry){
    _prefs.setInt('idCatVaccineCountry', idCatVaccineCountry);
  }

  int get tickTime{
    return _prefs?.getInt('tickTime') ?? 1;
  }

  set tickTime(int timeStamp) {
    _prefs?.setInt('tickTime', timeStamp);
  }

  String get profilePicPath{
    return _prefs.getString('profilePicPath') ?? '';
  }

  set profilePicPath(String profilePicPath) {
    _prefs.setString('profilePicPath', profilePicPath);
  }
}