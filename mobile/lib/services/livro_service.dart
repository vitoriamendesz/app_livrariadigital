import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/livro.dart';

class LivroService {
  final String _baseUrl = 'http://localhost:3000/livros'; 

  Future<List<Livro>> fetchLivros() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Livro.fromJson(json)).toList(); 
    } else {
      throw Exception('Erro ao carregar livros');
    }
  }

  Future<void> addLivro(Livro livro) async {
    final livroSemId = Livro(
      id: null, 
      titulo: livro.titulo,
      autor: livro.autor,
      preco: livro.preco,
      idCategoria: livro.idCategoria,
    );

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(livroSemId.toJson()), 
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      livro.id = data['id'];  
    } else {
      throw Exception('Erro ao adicionar livro');
    }
  }

  Future<void> updateLivro(Livro livro) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${livro.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(livro.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar livro');
    }
  }

  Future<void> deleteLivro(String id) async {  
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir livro');
    }
  }
}
