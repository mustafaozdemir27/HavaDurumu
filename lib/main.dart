import 'package:flutter/material.dart';
import 'package:hava_durumu/screen/Weather.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
      debugShowCheckedModeBanner: false,
      routes: {
        'WeatherScreen':(context)=> WeatherApp()
      },
    );
  }
}
