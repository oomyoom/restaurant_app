// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api
import 'package:basictestapp/colors.dart';
import 'package:flutter/material.dart';
import 'screens/home/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Store App",
      theme: ThemeData(
        scaffoldBackgroundColor: cBackgoundColor,
        primaryColor: cMainColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: cTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
