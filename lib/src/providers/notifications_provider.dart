import 'package:flutter/cupertino.dart';
import 'package:monitor_ia/src/database/db_provider.dart';
import 'package:monitor_ia/src/models/push_notification_model.dart';

class NotificationsProvider with ChangeNotifier{
  List<PushNotification> _notifications = [];
  PushNotification _lastNotification;
  bool _showNotification = true;

  List<PushNotification> get notifications => this._notifications;
  PushNotification get lastNotification => this._lastNotification;

  bool get showNotification => this._showNotification;
  set showNotification( bool value ) {
    this._showNotification = value;
    notifyListeners();
  }

  Future<PushNotification> newNotification(PushNotification notification) async {
    final id = await DBProvider.db.insertNotification(notification);
    //Asignar el ID de la base de datos al modelo
    notification.id = id;

    this._notifications.add(notification);
    await loadNotifications();

    return notification;
  }

  loadNotifications() async{
    final notifications = await DBProvider.db.getListOfAllNotifications();
    this._notifications = [...notifications];
    notifyListeners();
  }

  loadLastNotification() async{
    final notifications = await DBProvider.db.getLastNotification();
    this._lastNotification = notifications.isNotEmpty ? notifications.first : null;
    notifyListeners();
  }

  deleteAllNotifications() async{
    await DBProvider.db.deleteAllNotifications();
    this._notifications = [];
    notifyListeners();
  }

  deleteNotificationById(int idNotification) async{
    await DBProvider.db.deleteNotificationById(idNotification);
    await loadNotifications();
  }
}