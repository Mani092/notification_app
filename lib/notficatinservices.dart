import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificationservices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initlocalnoti() async {
    var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInit = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? response) {
        if (response != null) {
          print("Notification tapped with payload: ${response.payload}");
        }
      },
    );
  }

  void firebaseinit() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title ?? ''} - ${message.notification?.body ?? ''}");
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    // Define a consistent, non-random channel ID for important notifications
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Use a fixed ID for easier tracking
      'High Importance Notifications',
      description: "This channel is used for important notifications",
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Display the notification
    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        notificationDetails,
      );
    });
  }

  void requestnotificationpermission() async {
    NotificationSettings setting = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (setting.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission granted');
    } else if (setting.authorizationStatus == AuthorizationStatus.provisional) {
      print('Provisional permission granted');
    } else {
      AppSettings.openAppSettings();
      print('Permission denied');
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token ?? '';
  }
  void tokenrefresh()async{
    messaging.onTokenRefresh.listen((event){
      event.toString();
    });
  }

}


