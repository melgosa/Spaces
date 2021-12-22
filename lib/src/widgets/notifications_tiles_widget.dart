import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:monitor_ia/src/models/push_notification_model.dart';
import 'package:monitor_ia/src/providers/notifications_provider.dart';
import 'package:provider/provider.dart';

const String label_eliminar = 'Eliminar';

class NotificationsTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationListProvider =
        Provider.of<NotificationsProvider>(context);
    final notifications = notificationListProvider.notifications;

    return Expanded(
      child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (_, index) => _notificationItem(
              notificationListProvider, notifications, index, context)),
    );
  }

  Widget _notificationItem(NotificationsProvider notificationListProvider,
      List<PushNotification> notifications, int index, BuildContext context) {
    final loadedTime = DateTime.parse(notifications[index].fechaDeEntrega);
    final now = new DateTime.now();
    final difference = now.difference(loadedTime);
    String timeAgo = timeago.format(now.subtract(difference), locale: 'es');
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (DismissDirection direction) {
        notificationListProvider
            .deleteNotificationById(notifications[index].id);
      },
      background: _backgroundDissmisableLeft(),
      secondaryBackground: _backgroundDissmisable(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: notifications[index].prioridad == 'Alta'
              ? HexColor('#FCE0DC')
              : notifications[index].prioridad == 'Normal'
                  ? HexColor('#FEFAAB')
                  : HexColor('#DCF0FC'),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _customIcon(notifications[index].prioridad),
            _notificationContent(notifications, index, context, timeAgo)
          ],
        ),
      ),
    );
  }

  Container _backgroundDissmisable() {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 50),
            Text(label_eliminar, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Container _backgroundDissmisableLeft() {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.white, size: 50),
            Text(label_eliminar, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _notificationContent(List<PushNotification> notifications, int index,
      BuildContext context, String timeAgo) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerTextBig(notifications[index].title),
            SizedBox(height: 5),
            _headerTextSmall(notifications[index].contenido, context),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image(
                  image: AssetImage('assets/img/calendar.png'),
                  height: 25,
                  width: 25,
                ),
                _headerTextSmall(timeAgo, context)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _customIcon(String priority) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: priority == 'Alta'
                ? Colors.purple[300]
                : priority == 'Normal'
                    ? Colors.green[300]
                    : Colors.blue[300],
          ),
          child: Image(
              image: AssetImage(
                priority == 'Alta'
                    ? 'assets/img/priority_high.png'
                    : priority == 'Normal'
                        ? 'assets/img/priority_medium.png'
                        : 'assets/img/priority_low.png',
              ),
              width: 35,
              height: 35),
        ),
      ),
    );
  }

  Widget _headerTextBig(String text) {
    return Text(text,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 19.0));
  }

  Widget _headerTextSmall(String content, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Text(
          content,
          textAlign: TextAlign.justify,
          style: const TextStyle(
              color: Colors.black45,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 12.0)),
    );
  }
}
