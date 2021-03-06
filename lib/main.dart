import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:untitled/models/app_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:untitled/services/oauth_service.dart';
import 'dart:async';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  _firebaseMessaging.getToken().then((token) {
    print("---------------------------------------------");
    print("token = " + token);
    print("---------------------------------------------");
    OAuthService().updateDeviceToken(token).then((result) {
      print("---------------------------------------------");
      print(result);
      print("---------------------------------------------");
    });
  });
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: AppState(),
        child: MaterialApp(
          title: 'Flutter Demo',
          home: HomePage(),
        ));
  }
}
