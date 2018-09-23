import 'package:flutter/material.dart';
import 'package:untitled/home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:untitled/models/app_state.dart';

void main() => runApp(MyApp());

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
