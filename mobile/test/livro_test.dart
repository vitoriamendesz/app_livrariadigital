import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/livro.dart';
import 'package:mobile/models/categoria.dart';

void main() {
  test('Deve criar um livro com dados válidos', () {
    // Criando uma categoria mock para o teste
    final categoria = Categoria(id: 1, nome: 'Ficção');

    // Criando um livro válido
    final livro = Livro(
      id: '123', // Passando um id válido
      titulo: 'Livro de Teste',
      autor: 'Autor Teste',
      preco: 29.99,
      idCategoria: categoria.id, // Passando um idCategoria válido
    );

    // Verificando se o livro foi criado corretamente
    expect(livro.titulo, 'Livro de Teste');
    expect(livro.autor, 'Autor Teste');
    expect(livro.preco, 29.99);
    expect(livro.idCategoria, categoria.id);
  });

  test('Deve criar um livro com dados vazios e verificar valores default', () {
    // Criando um livro com dados vazios
    final livro = Livro(
      id: '123',
      titulo: '',
      autor: '',
      preco: 0.0,
      idCategoria: 0, // Passando um idCategoria padrão (pode ser 0 ou algum valor válido)
    );

    // Verificando se os valores padrão são passados corretamente
    expect(livro.titulo, '');
    expect(livro.autor, '');
    expect(livro.preco, 0.0);
    expect(livro.idCategoria, 0);
  });


}
