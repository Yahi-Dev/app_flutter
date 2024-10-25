import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  final TextEditingController _countryController = TextEditingController();
  List<dynamic> _universities = [];
  String _errorMessage = '';

  Future<void> _fetchUniversities(String country) async {
    final url = Uri.parse('http://universities.hipolabs.com/search?country=$country');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _universities = data;
        _errorMessage = '';
      });
    } else {
      setState(() {
        _universities = [];
        _errorMessage = 'Error retrieving university data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuarta Página'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Introduce el nombre del país en inglés:'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _countryController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre del País',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _fetchUniversities(_countryController.text);
              },
              child: const Text('Mostrar Universidades'),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty) 
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            if (_universities.isNotEmpty) 
              Expanded(
                child: ListView.builder(
                  itemCount: _universities.length,
                  itemBuilder: (context, index) {
                    final university = _universities[index];
                    return ListTile(
                      title: Text(university['name'] ?? 'Nombre no disponible'),
                      subtitle: Text(university['domains']?.join(', ') ?? 'Dominio no disponible'),
                      trailing: IconButton(
                        icon: const Icon(Icons.link),
                        onPressed: () {
                          final website = university['web_pages']?.isNotEmpty == true 
                              ? university['web_pages'][0] 
                              : '';
                          if (website.isNotEmpty) {
                            launchUrl(Uri.parse(website));
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
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