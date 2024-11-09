import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categoria.dart';

class CategoriaService {
  final String baseUrl = 'http://localhost:3000'; 

  Future<List<Categoria>> fetchCategorias() async {
    final response = await http.get(Uri.parse('$baseUrl/categorias'));

    if (response.statusCode == 200) {
      List<dynamic> categoriasJson = jsonDecode(response.body);
      return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar categorias');
    }
  }
}
