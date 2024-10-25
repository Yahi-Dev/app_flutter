import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';

class FifthPage extends StatefulWidget {
  const FifthPage({super.key});

  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  String _weatherDescription = '';
  String _temperature = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    const String apiKey = 'YOUR_API_KEY'; 
    const String city = 'Santo Domingo, DO'; 
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    final response = await http.get(url);
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); 

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _weatherDescription = data['weather'][0]['description'];
        _temperature = '${data['main']['temp']} °C';
        _errorMessage = '';
      });
    } else {
      setState(() {
        _weatherDescription = '';
        _temperature = '';
        _errorMessage = 'Error retrieving weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en RD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            if (_weatherDescription.isNotEmpty && _temperature.isNotEmpty) ...[
              Text('Clima: $_weatherDescription', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              Text('Temperatura: $_temperature', style: const TextStyle(fontSize: 24)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}