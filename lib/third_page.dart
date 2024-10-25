import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  final TextEditingController _nameController = TextEditingController();
  String _resultMessage = '';
  int? _age;
  String _imagePath = '';

  Future<void> _predictAge(String name) async {
    final url = Uri.parse('https://api.agify.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _age = data['age'];
        _resultMessage = _getAgeCategoryMessage(_age);
        _imagePath = _getAgeImagePath(_age);
      });
    } else {
      setState(() {
        _resultMessage = 'Error retrieving age data';
        _age = null;
        _imagePath = '';
      });
    }
  }

  String _getAgeCategoryMessage(int? age) {
    if (age == null) {
      return 'Edad no disponible';
    } else if (age < 18) {
      return 'Eres joven.';
    } else if (age < 60) {
      return 'Eres un adulto.';
    } else {
      return 'Eres anciano.';
    }
  }

  String _getAgeImagePath(int? age) {
    if (age == null) return '';
    if (age < 18) {
      return 'assets/young.jpg';
    } else if (age < 60) {
      return 'assets/adult.jpeg';
    } else {
      return 'assets/elderly.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tercera Página'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Introduce tu nombre:'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _predictAge(_nameController.text);
              },
              child: const Text('Predecir Edad'),
            ),
            const SizedBox(height: 20),
            if (_age != null) ...[
              Text(
                'Edad: $_age',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                _resultMessage,
                style: const TextStyle(fontSize: 20),
              ),
              if (_imagePath.isNotEmpty)
                Image.asset(
                  _imagePath,
                  height: 100,
                ),
            ],
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