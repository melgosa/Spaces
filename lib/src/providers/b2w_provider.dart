import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:monitor_ia/src/models/companies_model.dart';
import 'package:monitor_ia/src/models/contact_tracing_response_model.dart';
import 'package:monitor_ia/src/models/geofence_response_model.dart';
import 'package:monitor_ia/src/models/list_of_topics_response.dart';
import 'package:monitor_ia/src/models/meeting_room_controller_model.dart';
import 'package:monitor_ia/src/models/my_reservations.dart';
import 'package:monitor_ia/src/models/registro_usuario_model.dart';
import 'package:monitor_ia/src/models/reserva_model.dart';
import 'package:monitor_ia/src/models/seat_model.dart';
import 'package:monitor_ia/src/models/survey_by_empresa_response.dart';
import 'package:monitor_ia/src/models/survey_response.dart';
import 'package:monitor_ia/src/models/venue_model.dart';
import 'package:monitor_ia/src/models/work_area.dart';
import 'package:monitor_ia/src/models/work_area_booked_model.dart';
import 'package:monitor_ia/src/models/work_area_types_model.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/utils/constants_utils.dart';

class B2WProvider{
  final prefs = new PreferenciasUsuario();

  //URL Base
  String _urlBase = 'b2w-api.wokko.io:8443';
  //String _urlBaseContactTracing = 'contact-tracing.wokko.io:8441';
  String _urlBaseContactTracing = 'contact-tracing.wokko.io:8443';//Produccion
  String _urlBaseAWS = 'https://sns.us-east-1.amazonaws.com/';

  //Contact tracing
  String _contactTracingPath = '/contact-tracing';
  String _ubicacionPath = '/ubicacion';
  String _geocercas = '/geocercas';

  //AWS Services
  String _method = 'POST';

  //Usuario
  String _crearUsuarioPath = '/b2w/save-b2wuser';
  String _loginPath = '/b2w/login';
  String _changePasswordPath = 'b2w/change-password';
  String _companiesPath = 'b2w/company/companies';
  //Resrvaciones de espacios
  String _checkinMeetingReservationPath = '/b2w/meetingreservation/checkin';
  String _checkoutMeetingReservationPath = '/b2w/meetingreservation/checkout';
  String _checkinSeatReservationPath = '/b2w/seatreservation/checkin';
  String _checkoutSeatReservationPath = '/b2w/seatreservation/checkout';
  String _myReservationsPath = '/b2w/myreservations/';
  String _meetingRoomsByVenue = '/b2w/meetingroom/meetingroomsvenue/';
  String _seatsByWorkAreaPath = '/b2w/seat/seatsworkarea/';
  String _venuesController = '/b2w/venue/venues';
  String _venueAvailable = '/b2w/venue/available/';
  String _venueTotal = '/b2w/venue/total/';
  String _workAreaTypesPath = 'b2w/catWorkAreaType/catWorkAreaTypes';
  String _workAreasByVenuePath = '/b2w/workarea/workareasvenue/';
  String _b2wBookingPath = '/b2w/booking';
  String _saveBookingPath = '/b2w/savebooking';
  String _b2wBooking2Path = '/b2w/booking2';
  String _b2wOccupiedPath = 'b2w/venue/occupied/';
  String _b2wVenuesbyCompany = 'b2w/venue/venuescompany/';

  //Encuestas
  String _getFullSurveyPath = '/b2w/CatFullSurvey/';
  String _recordSurveyAnswered = '/b2w/userSurvey';
  String _recordQuestionsAnswered = '/b2w/userSurveyResponses/lista-respuestas';
  String _surveysByCompanyPath = 'b2w/catSurvey/surveys-by-company/';

  /////////////////////CREACION///////////////////////////////////////////

  Future<RegistroUsuario> registraUsuario(RegistroUsuario usuario) async {
    final url = Uri.https(_urlBase, _crearUsuarioPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(usuario.toJson())
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      }).timeout(const Duration(seconds: 10));
      print(json.encode(usuario.toJson()));
      print(res.body);
      return usuario;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return null;
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return null;
    }
    catch (err) {
      //print(err);
      return null;
    }
  }

  Future<String> cambiarContrasena(String email, String oldPassword, String newPassword) async {
    Map<String,dynamic> bodyReqLogin = {
      "email": email,
      "newPassword": newPassword,
      "password": oldPassword
    };

    print('payload: ${bodyReqLogin.toString()}');

    final url = Uri.https(_urlBase, _changePasswordPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(bodyReqLogin)
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      print(res.body);
      if(res.statusCode == 200){
        return 'OK';
      }else{
        final decodedData = json.decode(res.body);
        if(decodedData['message'] != null){
          return decodedData['message'];
        }else{
          return 'Ocurrió un error al realizar la petición';
        }
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return 'Tiempo excedido';
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
    catch (err) {
      //print(err);
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
  }

  Future<List<Company>> getCompanies() async {
    final url = Uri.https(_urlBase, _companiesPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      final decodedData = json.decode(res.body);
      //print('Data: ${decodedData.toString()}');
      final companies = new Companies.fromJsonList(decodedData);
      return companies.items;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      //print(err);
      return [];
    }
  }


  //404 no hay lugares; 200 OK
  Future<String> createMeetingRoomCheckin(int idMeetingRoomBooking, int idUser) async {
    Map<String,dynamic> bodyReqLogin = {
      "idMeetingRoomBooking": idMeetingRoomBooking,
      "idUser": idUser
    };

    final url = Uri.https(_urlBase, _checkinMeetingReservationPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(bodyReqLogin)
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      if(res.statusCode == 200){
        return 'OK';
      }else{
        final decodedData = json.decode(res.body);
        //print(decodedData.toString());
        if(decodedData['message'] != null){
          return decodedData['message'];
        }else{
          return 'Ocurrió un error al realizar la petición';
        }
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return 'Tiempo excedido';
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
    catch (err) {
      //print(err);
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
  }

  Future<String> createMeetingRoomCheckout(int idMeetingRoomBooking, int idUser) async {
    Map<String,dynamic> bodyReqLogin = {
      "idMeetingRoomBooking": idMeetingRoomBooking,
      "idUser": idUser
    };

    final url = Uri.https(_urlBase, _checkoutMeetingReservationPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(bodyReqLogin)
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      //print(res.body);
      if(res.statusCode == 200){
        //print('Codigo : ${res.statusCode }');
        return 'OK';
      }else{
        //print('Codigo : ${res.statusCode }');
        return 'Ocurrió un error al realizar la petición';
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return 'Tiempo excedido';
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
    catch (err) {
      //print(err);
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
  }

  Future<String> createSeatCheckin(int idSeat, int  idSeatBooking, int idUser) async {
    Map<String,dynamic> bodyReqLogin = {
      "idSeat": idSeat,
      "idSeatBooking": idSeatBooking,
      "idUser": idUser
    };

    final url = Uri.https(_urlBase, _checkinSeatReservationPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(bodyReqLogin)
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      //print(res.body);
      if(res.statusCode == 200){
        return 'OK';
      }else{
        return 'Ocurrió un error al realizar la petición';
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return 'Tiempo excedido';
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
    catch (err) {
      //print(err);
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
  }

  Future<String> createSeatCheckout(int idSeat, int  idSeatBooking, int idUser) async {
    Map<String,dynamic> bodyReqLogin = {
      "idSeat": idSeat,
      "idSeatBooking": idSeatBooking,
      "idUser": idUser
    };

    final url = Uri.https(_urlBase, _checkoutSeatReservationPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(bodyReqLogin)
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      if(res.statusCode == 200){
        return 'OK';
      }else{
        return 'Ocurrió un error al realizar la petición';
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return 'Tiempo excedido';
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
    catch (err) {
      //print(err);
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
  }

  Future<String> saveBooking(DateTime bookingDateTimeStart, DateTime bookingDateTimeEnd,
      int idRoomSeat, int idUser, int idVenue, int idWorkArea, int tipo
      ) async {
    Map<String, dynamic> bodyReq = {
      "bookingDateTimeStart": bookingDateTimeStart.toIso8601String(),
      "bookingDateTimeEnd": bookingDateTimeEnd.toIso8601String(),
      "idRoomSeat": idRoomSeat,
      "idUser": idUser,
      "idVenue": idVenue,
      "idWorkArea": idWorkArea,
      "tipo": tipo
    };

    //print('Body : ${json.encode(bodyReq)}');

    final url = Uri.https(_urlBase, _saveBookingPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(bodyReq)
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      if(res.statusCode == 200){
        final decodedData = json.decode(res.body);
        //print(decodedData.toString());
        if(decodedData['idRoomSeat'] != null){
          return 'OK';
        }else{
          return 'Ocurrió un problema con la petición, intente más tarde';
        }
      }else if(res.statusCode == 409){
        return 'Tienes una reserva previa que entra en conflicto con el horario seleccionado';
      }else{
        return 'Ocurrió un problema con la petición, intente más tarde';
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return 'Tiempo excedido';
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
    catch (err) {
      //print(err);
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
  }

  /////////////////////CONSULTAS///////////////////////////////////////////

  Future<List<Reserva>> getWorkAreasBooked(DateTime bookingDateTimeStart, DateTime bookingDateTimeEnd, int idRoomSeat, int  idUser, int idVenue, int idWorkArea, int tipo) async {
    Map<String,dynamic> body = {
      "bookingDateTimeStart": bookingDateTimeStart.toIso8601String(),
      "bookingDateTimeEnd": bookingDateTimeEnd.toIso8601String(),
      "idRoomSeat": idRoomSeat,
      "idUser": idUser,
      "idVenue": idVenue,
      "idWorkArea": idWorkArea,
      "tipo": tipo
    };

    //print('Request : ${json.encode(body)}');

    final url = Uri.https(_urlBase, _b2wBookingPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(body)
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      //print('Cuerpo : ${res.body}');

      if(res.statusCode == 200){
        final decodedData = json.decode(res.body);
        //print(decodedData.toString());

        final reservas = new Reservas.fromJsonList(decodedData);

        return reservas.items;
      }else{
        //print('Ocurrió un error al realizar la petición getWorkAreasBooked()');
        return [];
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      //print(err);
      return [];
    }
  }

  Future<List<WorkAreaBooked>> getWorkAreasBooked2(DateTime bookingDateTimeBegin, DateTime bookingDateTimeEnd, int idRoomSeat, int  idUser, int idVenue, int idWorkArea, int tipo) async {
    Map<String,dynamic> body = {
      "bookingDateTimeBegin": bookingDateTimeBegin.toIso8601String(),
      "bookingDateTimeEnd": bookingDateTimeEnd.toIso8601String(),
      "idRoomSeat": idRoomSeat,
      "idUser": idUser,
      "idVenue": idVenue,
      "idWorkArea": idWorkArea,
      "tipo": tipo
    };

    print(body.toString());
    //print('FECHAAAAAAAAA : ${bookingDateTimeBegin.toIso8601String()}');

    //print('Request : ${json.encode(body)}');

    print(body.toString());

    final url = Uri.https(_urlBase, _b2wBooking2Path);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(body)
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      print('Cuerpo : ${res.body}');

      if(res.statusCode == 200){
        final decodedData = json.decode(res.body);
        final workAreasBooked = new WorkAreasBooked.fromJsonList(decodedData['availableSeatRespObjList']);

        return workAreasBooked.items;
      }else{
        //print('Ocurrió un error al realizar la petición getWorkAreasBooked()');
        return [];
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      //print(err);
      return [];
    }
  }

  Future<List<WorkAreaType>> getWorkAreaTypes() async {
    final url = Uri.https(_urlBase, _workAreaTypesPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      final decodedData = json.decode(res.body);
      //print(decodedData.toString());
      final workAreaTypes = new WorkAreaTypes.fromJsonList(decodedData);
      return workAreaTypes.items;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      //print(err);
      return [];
    }
  }

  Future<List<MyReservation>> getMyReservations(int idUser) async {
    final url = Uri.https(_urlBase, _myReservationsPath+ idUser.toString());
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      final decodedData = json.decode(res.body);
      //print('Data: ${decodedData.toString()}');
      final myReservations = new MyReservations.fromJsonList(decodedData);
      return myReservations.items;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      //print(err);
      return [];
    }
  }

  Future<List<MeetingRoom>> getMeetingRoomsByVenue(int venueid) async {
    final url = Uri.https(_urlBase, _meetingRoomsByVenue + venueid.toString());
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      final decodedData = json.decode(res.body);
      //print(decodedData);
      final meetingRooms = new MeetingRooms.fromJsonList(decodedData);
      return meetingRooms.items;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      //print(err);
      return [];
    }
  }

  Future<List<Seat>> getSeatsByWorkArea(int workAreaid) async {
    final url = Uri.https(_urlBase, _seatsByWorkAreaPath + workAreaid.toString());
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      final decodedData = json.decode(res.body);
      //print(decodedData);
      final seats = new Seats.fromJsonList(decodedData);
      return seats.items;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      //print(err);
      return [];
    }
  }

  //Obtener todas las sedes
  Future<List<Venue>> getAllVenues() async {
    final url = Uri.https(_urlBase, _venuesController);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      final decodedData = json.decode(res.body);
      //print(decodedData.toString());
      final venues = new VenuesModel.fromJsonList(decodedData);
      return venues.items;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      //print(err);
      return [];
    }
  }

  Future<String> getVenueAvailable(int idVenue) async{
    final url = Uri.https(_urlBase, _venueAvailable + idVenue.toString());
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      //print('Data total: ${res.body.toString()}');
      //final decodedData = json.decode(res.body);
      Map<String, dynamic> decodedData = json.decode(res.body);
      //return res.body.toString();
      //print('RESULT : ${decodedData["resultado"].toString()}');
      return decodedData["resultado"].toString();
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return 'Tiempo excedido';
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
    catch (err) {
      //print(err);
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
  }

  Future<String> getVenueCapTotal(int idVenue) async{
    final url = Uri.https(_urlBase, _venueTotal + idVenue.toString());
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      Map<String, dynamic> decodedData = json.decode(res.body);
      //print('RESULT : ${decodedData["resultado"].toString()}');
      return decodedData["resultado"].toString();
      //return res.body.toString();
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return 'Tiempo excedido';
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
    catch (err) {
      //print(err);
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
  }

  Future<String> getDisponiblesByVenue(int idVenue) async{
    final url = Uri.https(_urlBase, _b2wOccupiedPath + idVenue.toString());
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      //return res.body.toString();
      //final decodedData = json.decode(res.body);
      Map<String, dynamic> decodedData = json.decode(res.body);
      //print('RESULT : ${decodedData["resultado"].toString()}');
      return decodedData["resultado"].toString();
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return 'Tiempo excedido';
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
    catch (err) {
      //print(err);
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }
  }

  //Obtener todas las workAreas para una venue especifica
  Future<List<WorkArea>>  getWorkAreasByVenue(int venueid) async {
    final url = Uri.https(_urlBase, _workAreasByVenuePath + venueid.toString());
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      final decodedData = json.decode(res.body);
      final workAreas = new WorkAreas.fromJsonList(decodedData);
      return workAreas.items;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      //print(err);
      return [];
    }
  }

  Future<List<Venue>> getVenuesByCompanyid(int idcompany) async{
    final url = Uri.https(_urlBase, _b2wVenuesbyCompany + idcompany.toString());
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      final decodedData = json.decode(res.body);
      //print(decodedData.toString());
      final venues = new VenuesModel.fromJsonList(decodedData);
      return venues.items;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      //print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      //print(err);
      return [];    }
  }

  ///////////////////////////////////MONITOR////////////////////////////////////

  Future<String> login(String email, String password) async {
    Map<String, dynamic> bodyReqLogin = {
      "email": email,
      "password": password,
    };
    final url = Uri.https(_urlBase, _loginPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(bodyReqLogin))
          .catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        //print('Tiempo excedido1 $e');
      }).timeout(const Duration(seconds: 10));
      print(res.body);
      if (res.statusCode == 200) {
        final decodedData = json.decode(res.body);
        prefs.email = email;
        prefs.password = password;
        prefs.firstLogin = false;
        prefs.userId = decodedData['datosMonitor']['idMonitor'];
        prefs.userName = decodedData['datosMonitor']['nombre'];
        prefs.empresaid = decodedData['datosMonitor']['idEmpresa'];
        prefs.empresa = decodedData['datosMonitor']['empresa'];
        prefs.fechaRegistro = decodedData['datosMonitor']['fechaRegistro'];
        return 'OK';
      }else {
        final decodedData = json.decode(res.body);
        return '${decodedData['message']}';
      }
    } on TimeoutException catch (e) {
      // Display an alert, no internet
      //print('Tiempo excedido2 $e');
      return 'Tiempo excedido';
    } on SocketException catch (e) {
      //print('Tiempo excedido2 $e');
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    } /*catch (err) {
      print(err);
      return 'Ha ocurrido un error, favor de intentarlo mas tarde';
    }*/
  }

  //Encuesta
  Future<SurveyResponse> getSurvey(int idSurvey) async{
    //final url = Uri.https(_urlBaseB2S, _getFullSurveyPath + idSurvey.toString());
    final url = Uri.https(_urlBase, _getFullSurveyPath + idSurvey.toString());
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url).catchError((e) {
        print('Tiempo excedido1 $e');
      }).timeout(const Duration(seconds: 10));
      //print(res.body);
      if(res.statusCode == 200){
        final surveyResponse = surveyResponseFromJson(res.body);
        return surveyResponse;
      } else{
        print('Ocurrio un error en la peticion');
        return null;
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      print('Tiempo excedido2 $e');
      return null;
    }
    on SocketException catch (e){
      print('Tiempo excedido2 $e');
      return null;
    }
    catch (err) {
      print(err);
      return null;
    }
  }

  Future<String> registerSurveyAnswered(int idCatSurvey, int idUser) async {
    String responseFromServer = '';
    Map<String,dynamic> bodyReq = {
      "idCatSurvey": idCatSurvey,
      "idUser": idUser
    };

    print(bodyReq.toString());

    //final url = Uri.https(_urlBaseB2S, _recordSurveyAnswered);
    final url = Uri.https(_urlBase, _recordSurveyAnswered);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(bodyReq)
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      print(res.body);
      if(res.statusCode == 200){
        final decodedData = json.decode(res.body);
        responseFromServer =  decodedData['idUserSurvey'].toString();
      }else{
        responseFromServer = 'NOTOK';
      }
      return responseFromServer;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      print('Tiempo excedido2 $e');
      return responseFromServer;
    }
    on SocketException catch (e){
      print('Tiempo excedido2 $e');
      return responseFromServer;
    }
    catch (err) {
      print(err);
      return responseFromServer;
    }
  }

  Future<List<SurveyByEmpresaResponse>> getListOfSurveysByEmpresa(int idEmpresa) async{
    final url = Uri.https(_urlBase, _surveysByCompanyPath + idEmpresa.toString());
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url).catchError((e) {
        print('Tiempo excedido1 $e');
      }).timeout(const Duration(seconds: 10));
      //print(res.body);
      if(res.statusCode == 200){
        final decodedData = json.decode(res.body);
        print(decodedData);
        final surveys = new SurveysByEmpresa.fromJsonList(decodedData);
        return surveys.items;
      } else{
        print(res.body);
        print('Ocurrio un error en la peticion');
        return [];
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      print(err);
      return [];
    }
  }


  Future<String> registerQuestionsAnswered(String json) async {
    String responseFromServer = '';

    //final url = Uri.https(_urlBaseB2S, _recordQuestionsAnswered);
    final url = Uri.https(_urlBase, _recordQuestionsAnswered);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      print(res.body);
      if(res.statusCode == 200){
        responseFromServer = 'OK';
      }else{
        responseFromServer = 'NOTOK';
      }
      return responseFromServer;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      print('Tiempo excedido2 $e');
      return responseFromServer;
    }
    on SocketException catch (e){
      print('Tiempo excedido2 $e');
      return responseFromServer;
    }
    catch (err) {
      print(err);
      return responseFromServer;
    }
  }

  Future<String> createEndpoint(Map<String, String> query) async {
    //print('Begin of request create endpoint');

    final request = Constantes.client.request(
        _urlBaseAWS,
        query: query,
        method: _method,
        body: ''
    );

    var response = await http.post(
        request.url,
        headers: request.headers,
        body: request.body
    );

    //print(response.body);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['CreatePlatformEndpointResponse']
      ['CreatePlatformEndpointResult']['EndpointArn'];
    } else {
      //print(response.body);
      return 'error';
    }
  }

  Future<List<Topic>> getListOfTopics(Map<String, String> query) async {
    //print('Begin of request get List of topics');

    final request = Constantes.client.request(
        _urlBaseAWS,
        query: query,
        method: _method,
        body: ''
    );

    var response = await http.post(
        request.url,
        headers: request.headers,
        body: request.body
    );

    //print(response.body);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      //print(decodedData);
      final topics = new Topics.fromJsonList(decodedData['ListTopicsResponse']['ListTopicsResult']['Topics']);
      return topics.items;
    } else {
      //print(response.body);
      return [];
    }
  }

  Future<String> subscribeToTopic(Map<String, String> query) async {
    //print('Begin of request Subscribe to Topic');

    final request = Constantes.client.request(
        _urlBaseAWS,
        query: query,
        method: _method, body: ''
    );

    var response = await http.post(
        request.url,
        headers: request.headers,
        body: request.body
    );

    //print(response.body);

    if (response.statusCode == 200) {
      return 'Subscribed to topic correctly';
    } else {
      //print(response.body);
      return 'error';
    }
  }

  Future<String> registerContactTracing(
      double accuracy,
      double altitude,
      double heading,
      int idEmpresa,
      int idLocationData,
      int idUsuario,
      double latitude,
      double longitude,
      double speed,
      double speedAccuracy,
      String time,
      String uuid) async {

    Map<String,dynamic> body = {
      "accuracy": accuracy,
      "altitude": altitude,
      "heading": heading,
      "idEmpresa": idEmpresa,
      "idLocationData": idLocationData,
      "idUsuario": idUsuario,
      "latitude": latitude,
      "longitude": longitude,
      "processed": true,
      "speed": speed,
      "speedAccuracy": speedAccuracy,
      "time": time,
      "uuid": uuid
    };

    //print('Request : ${json.encode(body)}');

    final url = Uri.https(_urlBaseContactTracing, _contactTracingPath + _ubicacionPath);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(body)
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      //print('Cuerpo : ${res.body}');

      if(res.statusCode == 200){
        final decodedData = json.decode(res.body);
        final contactTracingResponse = new ContactTracingResponse.fromJson(decodedData);

        return contactTracingResponse.idUsuario != null ? 'OK' : 'Error';
      }else{
        print('Ocurrió un error al realizar la petición getWorkAreasBooked()');
        return 'Error';
      }
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      print('Tiempo excedido2 $e');
      return 'Error';
    }
    on SocketException catch (e){
      print('Tiempo excedido2 $e');
      return 'Error';
    }
    catch (err) {
      print(err);
      return 'Error';
    }
  }

  Future<List<Geofence>> getListGeofences(String empresaid) async {
    final queryParameters = {
      'idEmpresa': '$empresaid',
    };
    final url = Uri.https(_urlBaseContactTracing, _contactTracingPath + _ubicacionPath + _geocercas, queryParameters);
    final client = http.Client();
    http.Response res;
    try {
      res = await client
          .get(url,
          headers: {"Content-Type": "application/json"}
      ).catchError((e) {
        // SocketException would show up here, potentially after the timeout.
        print('Tiempo excedido1 $e');
      })
          .timeout(const Duration(seconds: 10));
      print('Geofences: '+res.body);
      final decodedData = json.decode(res.body);
      //print(decodedData.toString());
      final geofences = new Geofences.fromJsonList(decodedData);
      return geofences.items;
    }
    on TimeoutException catch (e) {
      // Display an alert, no internet
      print('Tiempo excedido2 $e');
      return [];
    }
    on SocketException catch (e){
      print('Tiempo excedido2 $e');
      return [];
    }
    catch (err) {
      print(err);
      return [];
    }
  }
}