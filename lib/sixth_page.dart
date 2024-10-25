import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart'; 

class SixthPage extends StatefulWidget {
  const SixthPage({super.key});

  @override
  _SixthPageState createState() => _SixthPageState();
}

class _SixthPageState extends State<SixthPage> {
  List<dynamic> _posts = [];
  String _logoUrl = 'https://example.com/logo.png';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    const String apiUrl = 'https://example.com/wp-json/wp/v2/posts'; 

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _posts = data.take(3).toList();
        _errorMessage = '';
      });
    } else {
      setState(() {
        _errorMessage = 'Error retrieving posts';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Últimas Noticias'),
      ),
      body: Center(
        child: _errorMessage.isNotEmpty
            ? Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(_logoUrl, height: 100), 
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(post['title']['rendered']),
                            subtitle: Text(post['excerpt']['rendered'].replaceAll(RegExp(r'<[^>]*>'), '')), 
                            trailing: IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () {
                                final link = post['link'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewPage(url: link),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticia Original'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}