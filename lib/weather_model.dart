class WeatherResponse {
  final String city;
  final double latitude;
  final double longitude;
  final int temperature;
  final int feelsLike;
  final String condition;
  final int riskFactor;
  final int precipitationProbability;
  final int windSpeed;
  final String windDirection;
  final int atmPressure;
  final int humidity;

  WeatherResponse({
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.riskFactor,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.windDirection,
    required this.atmPressure,
    required this.humidity,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      city: json['location']['city'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
      temperature: json['weather']['temperature'],
      feelsLike: json['weather']['feels_like'],
      condition: json['weather']['condition'],
      riskFactor: json['weather']['risk_factor'],
      precipitationProbability: json['weather']['precipitation_probability'],
      windSpeed: json['weather']['wind_speed'],
      windDirection: json['weather']['wind_direction'],
      atmPressure: json['weather']['atm_pressure'],
      humidity: json['weather']['humidity'],
    );
  }
}
