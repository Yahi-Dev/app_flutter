import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'second_page.dart'; 
import 'third_page.dart';
import 'fourth_page.dart';
import 'fiveth_page.dart';
import 'sixth_page.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de mí'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Foto.jpg', height: 100),
            const SizedBox(height: 20),
            const Text(
              'Yahinniel A. Torres Vasquez',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            const Text('20221996@itla.edu.do'),
            const Text('Phone: +18293408864'),
          ],
        ),
      ),
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
  final TextEditingController _nameController = TextEditingController();
  String _resultMessage = '';
  int? _age;

  Future<void> _predictAge(String name) async {
    final url = Uri.parse('https://api.agify.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _age = data['age'];
        _resultMessage = _getAgeCategoryMessage(_age);
      });
    } else {
      setState(() {
        _resultMessage = 'Error retrieving age data';
      });
    }
  }

  String _getAgeCategoryMessage(int? age) {
    if (age == null) {
      return 'Age not available';
    } else if (age < 18) {
      return 'You are young.';
    } else if (age < 60) {
      return 'You are an adult.';
    } else {
      return 'You are elderly.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/toolbox.png'),
            Text('This app serves multiple purposes!'),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              child: const Text('Acerca de mí'),
            ),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              child: const Text('Ir a la Segunda Página'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThirdPage()),
                );
              },
              child: const Text('Ir a la Tercera Página'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FourthPage()),
                );
              },
              child: const Text('Ir a la Cuarta Página'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FifthPage()),
                );
              },
              child: const Text('Ver Clima en RD'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SixthPage()),
                );
              },
              child: const Text('Novedad'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAgeImage() {
    if (_age == null) return Container();

    if (_age! < 18) {
      return Image.asset('assets/young.jpg', height: 100);
    } else if (_age! < 60) {
      return Image.asset('assets/adult.jpeg', height: 100);
    } else {
      return Image.asset('assets/elderly.jpg', height: 100);
    }
  }
}