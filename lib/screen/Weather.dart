import 'package:flutter/material.dart';
import 'package:hava_durumu/services/WeatherServiceHelper.dart';
import 'package:hava_durumu/services/WeatherService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  var minTemperatureForecast = new List(7);
  var maxTemperatureForecast = new List(7);
  var abbreviationForecast = new List(7);
  var temperature;
  var location = 'edirne';
  var weather = '';
  var abbreviation = '';
  var errorMessage = '';

  Future<int> getWeather() async {
    try {
      http.Response response = await WeatherServiceHelper.getWeather(location);
      WeatherService weather = new WeatherService(jsonDecode(response.body));
      setState(() {
        this.temperature = double.parse(weather.temperature).round().toString();
        this.weather = weather.weather;
        this.abbreviation = weather.abbreviation;
        this.errorMessage='';
        for (int i = 0; i < 7; i++) {
          this.minTemperatureForecast[i] =
              double.parse(weather.minTemperatureForecast[i])
                  .round()
                  .toString();
          this.maxTemperatureForecast[i] =
              double.parse(weather.maxTemperatureForecast[i])
                  .round()
                  .toString();
          this.abbreviationForecast[i] = weather.abbreviationForecast[i];
        }
      });
      return 1;
    } catch (error) {
      setState(() {
        errorMessage = "Aradığınız şehire ait bilgiler bulunamadı...";
        this.temperature = "-";
        this.weather = "-";
        this.abbreviation = "-";

        for (int i = 0; i < 7; i++) {
          this.minTemperatureForecast[i] = '-';
          this.maxTemperatureForecast[i] = '-';
          this.abbreviationForecast[i] = '-';
        }
      });
      return -1;
    }
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  void onTextFieldSubmitted(String input) async {
    location = input;
    int result = await getWeather();
    if (result == -1) {
      location = "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
          child: temperature == null
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  backgroundColor: Colors.black,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Center(
                              child: SvgPicture.network(
                            abbreviation,
                            width: 100,
                          )),
                          Center(
                            child: Text(
                              temperature + ' °C',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 60.0),
                            ),
                          ),
                          Center(
                            child: Text(
                              location[0].toUpperCase() +
                                  location.substring(1).toString(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 40.0),
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            for (var i = 0; i < 7; i++)
                              forecastElement(
                                i,
                                abbreviationForecast[i],
                                minTemperatureForecast[i],
                                maxTemperatureForecast[i],
                              )
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: 300,
                            child: TextField(
                              onSubmitted: (String input) {
                                onTextFieldSubmitted(input);
                              },
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              decoration: InputDecoration(
                                hintText: 'Farklı bir şehir arayın...',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 32.0, left: 32.0),
                            child: Text(errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize:
                                        Platform.isAndroid ? 15.0 : 20.0)),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
    );
  }
}

Widget forecastElement(
    daysFromNow, abbreviation, minTemperature, maxTemperature) {
  Intl.defaultLocale = 'tr';
  initializeDateFormatting();
  var now = new DateTime.now();
  var oneDayFromNow = now.add(new Duration(days: daysFromNow));
  return Padding(
    padding: const EdgeInsets.only(left: 16.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(205, 212, 228, 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              new DateFormat.E('tr').format(oneDayFromNow),
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              new DateFormat.MMMd('tr').format(oneDayFromNow),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: SvgPicture.network(
                  abbreviation,
                  width: 50,
                )),
            Text(
              'Yüksek: ' + maxTemperature.toString() + ' °C',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            Text(
              'Düşük: ' + minTemperature.toString() + ' °C',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ],
        ),
      ),
    ),
  );
}
