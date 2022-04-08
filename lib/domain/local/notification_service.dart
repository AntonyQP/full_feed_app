import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService{

  static final _notifications = FlutterLocalNotificationsPlugin();

  static final onNotifications = BehaviorSubject<String?>();

  //WHEN APP IS CLOSED
  static Future init({bool initScheduled = true}) async{
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    final details = await _notifications.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }

    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(details!.payload);
      }
    );


  }


  static Future _notificationDetails() async {

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
      ),
      iOS: const IOSNotificationDetails(),
    );
  }

  static void showScheduledNotification({
    int id =0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          _scheduleDaily(Time(18, 30)),
          await _notificationDetails(),
          payload: payload,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true
      );

  static tz.TZDateTime _scheduleDaily(Time time){
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
          time.hour, time.minute, time.second);
    
    return scheduleDate.isBefore(now) ?
        scheduleDate.add(Duration(days: 1)) : scheduleDate;

  }
}