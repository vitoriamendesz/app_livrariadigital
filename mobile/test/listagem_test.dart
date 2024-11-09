import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/livro.dart';

void main() {
  // Teste para verificar a criação do livro
  test('Deve criar um livro corretamente', () {
    final livro = Livro(
      id: '123',
      titulo: 'O Hobbit',
      autor: 'J.R.R. Tolkien',
      preco: 39.90,
      idCategoria: 1,
    );

    // Verificar se os valores foram atribuídos corretamente
    expect(livro.id, '123');
    expect(livro.titulo, 'O Hobbit');
    expect(livro.autor, 'J.R.R. Tolkien');
    expect(livro.preco, 39.90);
    expect(livro.idCategoria, 1);
  });

  // Teste para verificar o método fromJson
  test('Deve criar um livro a partir de um JSON', () {
    final json = {
      'id': '123',
      'titulo': 'O Hobbit',
      'autor': 'J.R.R. Tolkien',
      'preco': 39.90,
      'categoriaId': 1,
    };

    final livro = Livro.fromJson(json);

    // Verificar se o livro foi criado corretamente a partir do JSON
    expect(livro.id, '123');
    expect(livro.titulo, 'O Hobbit');
    expect(livro.autor, 'J.R.R. Tolkien');
    expect(livro.preco, 39.90);
    expect(livro.idCategoria, 1);
  });

  // Teste para verificar o método toJson
  test('Deve converter um livro para JSON corretamente', () {
    final livro = Livro(
      id: '123',
      titulo: 'O Hobbit',
      autor: 'J.R.R. Tolkien',
      preco: 39.90,
      idCategoria: 1,
    );

    final json = livro.toJson();

    // Verificar se o livro foi convertido para o formato JSON correto
    expect(json['titulo'], 'O Hobbit');
    expect(json['autor'], 'J.R.R. Tolkien');
    expect(json['preco'], 39.90);
    expect(json['categoriaId'], 1);
  });
}
