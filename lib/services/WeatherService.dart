class WeatherService{

  var minTemperatureForecast = new List(7);
  var maxTemperatureForecast = new List(7);
  var abbreviationForecast = new List(7);
  var temperature;
  var weather = '';
  var abbreviation = '';

  WeatherService(dynamic data){
    this.temperature = data['result'][0]['degree'];
    this.weather = data['result'][0]['description'];
    this.abbreviation = data['result'][0]['icon'];

    for (int i = 0; i < 7; i++) {
      this.minTemperatureForecast[i] = data['result'][i]['min'];
      this.maxTemperatureForecast[i] = data['result'][i]['max'];
      this.abbreviationForecast[i] = data['result'][i]['icon'];
    }
  }


}