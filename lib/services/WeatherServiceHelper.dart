import 'package:http/http.dart';
class WeatherServiceHelper{

  static final String url ="https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=";
  static final String apiKey ="apikey 4P2VO10Txe2XP19FlbVJ62:2jJPSZk5rNBxUkSIobhK6w";

  static Future<Response> getWeather(String location) {
    return get(
      Uri.encodeFull(
          url + location),
      headers: {
        "Authorization": apiKey
      },
    );
  }
}