import 'package:flutter/material.dart';
import 'package:SSI/login.dart';
void main() => runApp(new AquaApp());

class AquaApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new LoginPage(),
        theme: new ThemeData(
            primarySwatch: Colors.blue
        )
    );
  }

}