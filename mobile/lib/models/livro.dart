class Livro {
  String? id;  
  String titulo;
  String autor;
  double preco;
  int idCategoria;

  Livro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.preco,
    required this.idCategoria,
  });

  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      id: json['id'] as String?,
      titulo: json['titulo'],
      autor: json['autor'],
      preco: json['preco'],
      idCategoria: json['categoriaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'autor': autor,
      'preco': preco,
      'categoriaId': idCategoria,
    };
  }
}
