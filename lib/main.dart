import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 50, 194, 230)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Weather Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Map<String, dynamic>> fetchWeatherData() async {
    final url = Uri.parse('https://mr-api-three.vercel.app/weather');

    try {
      final response = await http.get(url);

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Weather Data: $data");
        return data;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date
    DateTime now = DateTime.now();

    // Format the date to display in "Friday, 6 December" format
    String formattedDate = DateFormat('EEEE, d MMMM').format(now);

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Map<String, dynamic>>(
          future: fetchWeatherData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final weatherData = snapshot.data!;
              String condition =
                  weatherData['weather']['condition'] ?? 'Unknown';
              Color startColor;
              Color endColor;
              IconData weatherIcon;

              // Set gradient and icon based on the weather condition
              switch (condition.toLowerCase()) {
                case 'sunny':
                  startColor = Color.fromRGBO(255, 184, 113, 1);
                  endColor = Colors.white;
                  weatherIcon = Icons.sunny; // Sunny icon
                  break;
                case 'rainy':
                  startColor = Color.fromRGBO(121, 121, 121, 1);
                  endColor = Colors.white;
                  weatherIcon = WeatherIcons
                      .rain; // Rainy icon from the weather_icons package
                  break;
                case 'snowy':
                  startColor = Color(0x001970e5);
                  endColor = Colors.white;
                  weatherIcon = Icons.ac_unit; // Snowy icon
                  break;
                default:
                  startColor = Colors.grey.shade300;
                  endColor = Colors.grey.shade600;
                  weatherIcon =
                      Icons.help; // Default icon for unknown condition
              }
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [startColor, endColor],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // first row for location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_pin),
                        Text('${weatherData['location']['city']}',
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),

                    // 2econd row for temp and other
                    Row(
                      children: [
                        Container(
                          child: Text('${weatherData['weather']['temprature']}',
                              style: const TextStyle(fontSize: 20)),
                        ),

                        //CONTAINER FOR condition and date
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('${weatherData['weather']['condition']}',
                                      style: const TextStyle(fontSize: 20)),
                                  Icon(
                                      weatherIcon), // Display weather icon based on condition
                                ],
                              ),
                              Text(
                                formattedDate, // Display the formatted date
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Text("Feels Like ${weatherData['weather']['feels_like']}"),

                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoCard(
                                    WeatherIcons.cloud_down, " ${weatherData['weather']['precipitation_probability']}", "Precipitation"),
                                _buildInfoCard(
                                    Icons.air, "${weatherData['weather']['wind_speed']}", "Wind speed"),
                              ],
                            ),
                            Row(
                              children: [
                                 _buildInfoCard(
                                    Icons.speed, " ${weatherData['weather']['atm_pressure']}", "Atm Pressure"),
                                _buildInfoCard(
                                    WeatherIcons.humidity, "${weatherData['weather']['Humidity']}", "Humidity"),
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No Data Available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.blue),
        SizedBox(height: 8),
        Text(value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
