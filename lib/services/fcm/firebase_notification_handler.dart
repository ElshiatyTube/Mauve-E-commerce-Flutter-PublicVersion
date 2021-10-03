import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import 'notification_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class FirebaseNotifications{
  late FirebaseMessaging _messaging;
  late BuildContext myContext;

  void setUpFirebase(BuildContext context)
  {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessageListener(context);
    myContext = context;

  }

  void firebaseCloudMessageListener(BuildContext context) async{

    final bool? result = await NotificationHandler.flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    print('Setting ${settings.authorizationStatus} LocalPer ${result.toString()}');
    //Get Token
    //Use token to receive notify
    _messaging.getToken().then((token) => print('MyToken: $token'));
    //Subscribe to Topic
    //Will send to topic for group notification
    _messaging.subscribeToTopic("new_notify_nopic")
    .whenComplete(() => print('Subscribe OK'));

    //Handle message
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      print('Receive $remoteMessage');
      if(Platform.isAndroid)
        {
          if(remoteMessage.data['IMAGE_URL'] !=null)
            showNotificationBigStyle(remoteMessage.data['title'],remoteMessage.data['body'],remoteMessage.data['IMAGE_URL']);
          else
            showNotification(remoteMessage.data['title'],remoteMessage.data['body']);
        }

      else if(Platform.isIOS)
        {
          showNotification(remoteMessage.data['title'],remoteMessage.data['body']);
        /*  if(remoteMessage.data['IMAGE_URL'] !=null)
            showNotificationBigStyle(remoteMessage.data['title'],remoteMessage.data['body'],remoteMessage.data['IMAGE_URL']);
          else
            showNotification(remoteMessage.data['title'],remoteMessage.data['body']);*/
        }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print('Receive open app: $remoteMessage');
      print('InOpenAppNotifyBody ${remoteMessage.data['body'].toString()}');
      if(Platform.isIOS) {
        showDialog(context: myContext, builder: (context)=> CupertinoAlertDialog(title: Text(remoteMessage.notification!.title??''),
          content:  Text(remoteMessage.notification!.body??''),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('OK'),
              onPressed: ()=> Navigator.of(context,rootNavigator: true,).pop(),
            )
          ],));
      }
    });
  }

 static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

 static void showNotification(title, body) async{

   print('Title $title body $body' );
    var androidChannel = const AndroidNotificationDetails(
      'com.example.flutter_ecom_block_firebase', 'My Channel', 'Description',
        autoCancel: true,

    ongoing: false,
    importance: Importance.max,
    priority: Priority.high);

    var ios = const IOSNotificationDetails();

    var platform = NotificationDetails(
      android: androidChannel,iOS: ios);
    await NotificationHandler.flutterLocalNotificationPlugin
    .show(Random().nextInt(1000), title, body, platform,payload: 'My Payload');

  }

 static Future<void> showNotificationBigStyle(title, body,image) async{
    String bigPicturePath;
    if(image.toString().contains('http'))
      {
     bigPicturePath = await _downloadAndSaveFile(
            '${image}', 'bigPicture');

     print('forGrawondImsg');
      }
    else{
      bigPicturePath = image;
      print('backGrawondImsg');
    }



   final BigPictureStyleInformation bigPictureStyleInformation =
   BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
       contentTitle: title,
       htmlFormatContentTitle: true,
       summaryText: body,
       htmlFormatSummaryText: true);

    var androidChannel = AndroidNotificationDetails(
        'com.example.flutter_ecom_block_firebase', 'My Channel', 'Description',
        autoCancel: true,
        styleInformation: bigPictureStyleInformation ,
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ongoing: false, //Enable swip dismiss
        importance: Importance.max,
        priority: Priority.high);

    var ios = const IOSNotificationDetails();

    var platform = NotificationDetails(
        android: androidChannel,iOS: ios);
    await NotificationHandler.flutterLocalNotificationPlugin
        .show(Random().nextInt(1000), title, body, platform,payload: 'My Payload');

    print('backGrawondImsg2222');

  }


}