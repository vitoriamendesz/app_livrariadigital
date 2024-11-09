class Categoria {
  final int id; 
  final String nome;

  Categoria({required this.id, required this.nome});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: int.parse(json['id'].toString()), // Converte id para int
      nome: json['nome'],
    );
  }
}
