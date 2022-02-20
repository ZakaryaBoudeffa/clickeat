// @dart=2.9

import 'dart:developer';
import 'dart:io';

import 'package:clicandeats/pages/chooseDeliveryLocation.dart';
import 'package:clicandeats/pages/forgetPassword.dart';
import 'package:clicandeats/pages/layout.dart';
import 'package:clicandeats/pages/onBordingPage.dart';
import 'package:clicandeats/pages/permissionDisclosurePage.dart';
import 'package:clicandeats/pages/signUpPage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebaseFirestore/auth.dart';
import 'models/Settings.dart';
import 'models/order.dart';
import 'pages/signInPage.dart';

int counter = 0;
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   IOSInitializationSettings initializationSettingsIOS =
//       new IOSInitializationSettings();
//   InitializationSettings initializationSettings = new InitializationSettings(
//       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//   flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   print('Handling a background message ${message.messageId}');
//   //showNotification(message.data['title'], message.data['body']);
// }
//
// /// Create a [AndroidNotificationChannel] for heads up notifications
// AndroidNotificationDetails channel;

// /// Initialize the [FlutterLocalNotificationsPlugin] package.
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
// void showNotification(String title, String body) async {
//   await _demoNotification(title, body);
// }
//
// Future<void> _demoNotification(String title, String body) async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       '0', 'ClicEats',
//       channelDescription: 'channel description',
//       importance: Importance.high,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound('noti'),
//       showProgress: true,
//       priority: Priority.high,
//       icon: '@mipmap/launcher_icon',
//       ticker: 'test ticker');
//
//   var iOSChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
//
//   await flutterLocalNotificationsPlugin
//       .show(0, title, body, platformChannelSpecifics, payload: 'test');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // // Set the background messaging handler early on, as a named top-level function
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //
  // if (!kIsWeb) {
  //   channel = AndroidNotificationDetails(
  //     'high_importance_channel', // id
  //     'High Importance Notifications', // title
  //     channelDescription:
  //         'This channel is used for important notifications.', // description
  //     importance: Importance.high,
  //   );
  //
  //   //flutterLocalNotificationsPlugin.
  //   /// Update the iOS foreground notification presentation options to allow
  //   /// heads up notifications.
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  // }
  runApp(
      ChangeNotifierProvider(create: (_) => AppStateManager(), child: MyApp()));
}

Color darkAccentColor = Color(0xff393E46);

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool themeLight = true;
  @override
  void initState() {
    super.initState();
    getThemeValueFromSharedPref();
    //getTheme();
    setState(() {});
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    // IOSInitializationSettings initializationSettingsIOS =
    //     new IOSInitializationSettings();
    // InitializationSettings initializationSettings = new InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
    //
    // FirebaseMessaging.instance.subscribeToTopic('cliceatTest').then((value) {
    //   print('subscribed to cliceatTest');
    // });
    //
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage message) {
    //   if (message != null) {
    //     log('Message received: ${message.data}');
    //   }
    // });
    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   log('A new onMessage event was published! body: ${notification.title}');
    //   showNotification(notification.title, notification.body);
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   log('A new onMessageOpenedApp event was published!');
    // });
  }

  getThemeValueFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool themeIsLight = true;
    themeLight = true;
    // if (prefs.containsKey('theme')) themeLight = prefs.getBool('theme');
    //
    // Provider.of<AppStateManager>(context, listen: false)
    //     .switchTheme(themeLight);
    //
    // print("themelight : $themeLight}");
    // print(
    //     "settings.themelight : ${Provider.of<AppStateManager>(context, listen: false).themeLight}");
    //return themeIsLight;
  }

  // void showNotification(String title, String body) async {
  //   await _demoNotification(title, body);
  // }
  //
  // Future<void> _demoNotification(String title, String body) async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       '0', 'ClicEats',
  //       channelDescription: 'channel description',
  //       importance: Importance.high,
  //       playSound: true,
  //       sound: RawResourceAndroidNotificationSound('noti'),
  //       showProgress: true,
  //       priority: Priority.high,
  //       icon: '@mipmap/launcher_icon',
  //       ticker: 'test ticker');
  //
  //   var iOSChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin
  //       .show(0, title, body, platformChannelSpecifics, payload: 'test');
  // }

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return MaterialApp(
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder,
      title: 'Clic&eats',
      debugShowCheckedModeBanner: false,
      // themeMode: _settings.themeLight ? ThemeMode.light : ThemeMode.dark,
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
          //headline5: TextStyle(color: Colors.white)
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        primarySwatch: Colors.grey,
        primaryColor: Color(0xfffc9568),
        accentColor: Color(0xff747474),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 15),
            primary: Color(0xfffc9568),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xfffc9568),
        ),
        scaffoldBackgroundColor: Color(0xff222831),
        dividerColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xff222831),
          brightness: Platform.isIOS ? Brightness.light : Brightness.dark,
          centerTitle: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(
            color: Color(0xfffc9568),
            size: 50.0, //change your color here
          ),
        ),
      ),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Color(0xff747474),
          displayColor: Color(0xff747474),
        ),
        primarySwatch: Colors.grey,
        primaryColor: Color(0xfffc9568),
        accentColor: Color(0xff747474),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 15),
            primary: Color(0xfffc9568),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xfffc9568),
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        dividerColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.grey[100],
          brightness: Platform.isIOS ? Brightness.light : Brightness.dark,
          centerTitle: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(
            color: Color(0xfffc9568),
            size: 50.0, //change your color here
          ),
        ),
      ),
      // onGenerateRoute: router.generateRoute,
      routes: {
        '/landing': (context) => LandingPage(),
        '/': (context) => Layout(),
        '/welcome': (context) => Onbording(),
        '/signin': (context) => SignIn(),
        '/signup': (context) => SignUp(),
        '/reset': (context) => ForgetPassword(),
      },
      initialRoute: '/landing',
    );
  }
}

List<InCartOrder> inCart = [];

class LandingPage extends StatelessWidget {
  bool locationPermissionGranted = false;
  bool permissionsGranted = true;
  Stream<bool> checkPermissions() async* {
    //cameraPermissionGranted = await Permission.camera.isGranted;
    locationPermissionGranted = await Permission.location.isGranted;
    // storagePermissionGranted = await Permission.storage.isGranted;
    if (locationPermissionGranted)
      permissionsGranted = true;
    else
      permissionsGranted = false;
    yield permissionsGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User>(
        stream: Authentication().auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            // var result = user.getIdTokenResult();
            print(
                "user: ${user?.email} : isEmailVerified? ${user?.emailVerified}");
            if (user != null) {
              print("Logged in user id: ${user.uid}");
              return Platform.isIOS
                  ? Layout()
                  : StreamBuilder<bool>(
                      stream: checkPermissions(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data == true
                              ? Layout()
                              : PermissionDisclosurePage();
                        } else
                          return Text('');
                      });
            } else {
              log('User not signed in');
              return Platform.isIOS
                  ? ChooseDeliveryLocation()
                  : StreamBuilder(
                      stream: checkPermissions(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(
                              "SNAPSHOTDATA PERMISSION VAL: ${snapshot.data}");
                          return snapshot.data == true
                              ? ChooseDeliveryLocation()
                              : PermissionDisclosurePage();
                        } else {
                          return Text('');
                        }
                      },
                    );
              // log('User not signed in');
              // return ChooseDeliveryLocation();
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
