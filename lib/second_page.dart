import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController _nameController = TextEditingController();
  String _genderResult = '';
  Color _backgroundColor = Colors.white;

  Future<void> _predictGender(String name) async {
    final url = Uri.parse('https://api.genderize.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        // Comprobar el género y cambiar el color de fondo
        if (data['gender'] == 'male') {
          _genderResult = 'El género predicho es: Masculino';
          _backgroundColor = Colors.blue;
        } else {
          _genderResult = 'El género predicho es: Femenino';
          _backgroundColor = Colors.pink;
        }
      });
    } else {
      setState(() {
        _genderResult = 'Error al recuperar datos de género';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Container(
        color: _backgroundColor, // Cambiar el color de fondo
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Introduce un nombre para predecir el género:'),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Escribe un nombre',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _predictGender(_nameController.text);
                },
                child: const Text('Predecir Género'),
              ),
              const SizedBox(height: 20),
              Text(
                _genderResult,
                style: const TextStyle(fontSize: 20),
              ),
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
      ),
    );
  }
}