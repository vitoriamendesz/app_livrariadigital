import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List livros = [];

  Future<void> fetchLivros() async {
    List<String> generos = ['romance', 'aventura', 'terror', 'ficcao', 'historia'];
    List<dynamic> todosLivros = [];

    for (String genero in generos) {
      final response = await http.get(Uri.parse(
          'https://openlibrary.org/search.json?q=$genero&language=por&limit=10'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        todosLivros.addAll(data['docs']);
      }
    }

    setState(() {
      livros = todosLivros.take(10).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLivros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros mais procurados'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/listagem');
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/formulario');
            },
          ),
        ],
      ),
      body: livros.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: livros.length,
              itemBuilder: (context, index) {
                final livro = livros[index];
                final capaUrl = livro['cover_i'] != null
                    ? 'https://covers.openlibrary.org/b/id/${livro['cover_i']}-L.jpg'
                    : 'https://example.com/default_image.jpg';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: Text(
                      livro['title'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      livro['author_name']?.join(', ') ?? 'Autor desconhecido',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: capaUrl,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.book),
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
