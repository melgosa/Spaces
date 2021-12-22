//SHA1 : FA:1A:8E:16:74:08:16:4C:87:DC:4E:79:D9:C0:2E:4A:E5:FF:C7:2C
//dYwfScnSTFWOZKqGlVNULW:APA91bEFi9QTVwsGtTtIpPtf1021jiGtpfDwZdAuCOMtYZ4OjdDJeLmu7v-X08OvzMvrqxq5OdZZISfGC2Aw3xBzJp6cQqglcCKL0s0CYavg71NN_8Qy5gjaBQfeOA_VOFYfE4VvxqhI

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:monitor_ia/src/models/list_of_topics_response.dart';
import 'package:monitor_ia/src/models/push_notification_model.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';
import 'package:monitor_ia/src/providers/notifications_provider.dart';
import 'package:monitor_ia/src/utils/constants_utils.dart';

class PushNotificationService{
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token;
  static StreamController<RemoteMessage> _messageStream = new StreamController.broadcast();
  static Stream<RemoteMessage> get messagesStream => _messageStream.stream;
  static final dataProvider = new B2WProvider();
  static final notiProvider = NotificationsProvider();

  ///create channel
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'B2W Channel', // id
    'B2W Notification Channel', // title
    'Canal utilizado para la recepción de push notifications de la app B2W.', // description
    importance: Importance.high,
  );

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  static Future _onBackgroundHandler(RemoteMessage message) async{
    print('Push Noti: _onBackgroundHandler');
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _messageStream.add(message);
  }

  static Future _onMessageHandler(RemoteMessage message) async{
    print('Push Noti: _onMessageHandler');
    _messageStream.add(message);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async{
    print('Push Noti: _onMessageOpenApp');
    _messageStream.add(message);
  }

  static Future initializeApp() async{
    //Push Notifications
    await Firebase.initializeApp();
    await requestPermissions();
  }

  static setConfigurationsAmazonSNS(String firebaseToken) async{
    final _queryCreateEndpoint = {
      'Action': 'CreatePlatformEndpoint',
      'PlatformApplicationArn': Constantes.platformApplicationArn,
      'Token': firebaseToken,
    };
    String endpoint = await dataProvider.createEndpoint(_queryCreateEndpoint);

    final _queryListOfTopics = {
      'Action': 'ListTopics',
    };
    List<Topic> topics = await dataProvider.getListOfTopics(_queryListOfTopics);

    if(topics.isNotEmpty){
      for(int i = 0; i< topics.length; i++){
        final _querySubscribeToTopic = {
          'Action': 'Subscribe',
          'TopicArn': topics[i].topicArn,
          'Endpoint': endpoint,
          'Protocol': 'application',
        };
        String response = await dataProvider.subscribeToTopic(_querySubscribeToTopic);
        print(response);
      }
    }else{
      //print('Error while obtaining list of topics');
    }
  }

  static requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      provisional: false,
      sound: true
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      token = await FirebaseMessaging.instance.getToken();
      print('Token Firebase: $token');

      //Handlers
      FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_onMessageHandler);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

      setConfigurationsAmazonSNS(token);
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Map _modifyNotificationJson(Map<String, dynamic> message){
    message['data'] = Map.from(message ?? {});
    message['notification'] = message['aps']['alert'];
    return message;
  }

  static closeStreams(){
    _messageStream.close();
  }



  /*
  *
"GCM": "{\"data\": { \"prioridad\": \"Alta\", \"fechaDeEnvio\":\"2021-08-10 15:15:15.000\" },\"notification\":{\"body\": \"Este próximo 11 de Diciembre acude a la reunion de integración que se realizará en Ajusco.. ¡No faltes!\",\"title\":\"Reunión de integración en Global Hitss\"} }",

"GCM": "{\"data\": { \"prioridad\": \"Normal\", \"fechaDeEnvio\":\"2021-08-10 15:15:15.000\" },\"notification\":{\"body\": \"Recuerda contestar la encuesta de sustentabilidad, el link esta en tu bandeja de entrada\",\"title\":\"Encuesta de sustentabilidad\"} }",

"GCM": "{\"data\": { \"prioridad\": \"Baja\", \"fechaDeEnvio\":\"2021-08-10 15:15:15.000\" },\"notification\":{\"body\": \"La receta para hacerlo, se encuentra disponible en la bandeja de entrada de tu email, ¡No dejes pasar esta oportunidad!\",\"title\":\"Prepara pan de muerto\"} }",

  * */

// P8 : Key ID:GGCPT3GTH7
}