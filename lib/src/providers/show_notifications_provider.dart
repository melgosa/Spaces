import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ShowNotificationsProvider{
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  initializePushNotifications(){
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );

    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }

  Future<void> showNotification(
      int notificationId,
      String notificationTitle,
      String notificationContent,
      String payload, {
        String channelId = 'B2W Channel',
        String channelTitle = 'B2W Notification Channel',
        String channelDescription = 'Canal utilizado para la recepción de push notifications de la app B2W.',
        Priority notificationPriority = Priority.high,
        Importance notificationImportance = Importance.max,
      }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: true,
      importance: notificationImportance,
      priority: notificationPriority,
      styleInformation: BigTextStyleInformation(notificationContent)
    );
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(presentSound: true);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }

}