import 'package:flutter/material.dart';
import '../models/livro.dart';
import '../services/livro_service.dart';
import 'formulario_screen.dart';

class ListagemScreen extends StatefulWidget {
  @override
  _ListagemScreenState createState() => _ListagemScreenState();
}

class _ListagemScreenState extends State<ListagemScreen> {
  List<Livro> _livros = [];
  bool _isLoading = false; 
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLivros(); // Carregar os livros ao iniciar a tela
  }

  Future<void> _loadLivros() async {
    setState(() {
      _isLoading = true; 
      _errorMessage = ''; 
    });

    try {
      final livros = await LivroService().fetchLivros(); 
      setState(() {
        _livros = livros; 
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar livros: $e'; 
      });
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  void _atualizarLista(Livro livro) {
    setState(() {
      if (livro.id == null) {
        _livros.add(livro);
      } else {
        final index = _livros.indexWhere((l) => l.id == livro.id);
        if (index != -1) {
          _livros[index] = livro; 
        }
      }
    });
  }

  Future<void> _deletarLivro(Livro livro) async {
    try {
      await LivroService().deleteLivro(livro.id!); 
      setState(() {
        _livros.removeWhere((livroItem) => livroItem.id == livro.id); 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Livro excluído com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir livro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listagem de Livros'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadLivros, 
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) 
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage)) 
              : _livros.isEmpty
                  ? Center(child: Text('Nenhum livro encontrado')) 
                  : ListView.builder(
                      itemCount: _livros.length,
                      itemBuilder: (context, index) {
                        final livro = _livros[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(livro.titulo),
                            subtitle: Text('${livro.autor} - R\$${livro.preco.toStringAsFixed(2)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FormularioScreen(
                                          onSalvar: _atualizarLista,
                                          onExcluir: _deletarLivro,
                                          livro: livro,
                                        ),
                                      ),
                                    );
                                    _loadLivros(); 
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Confirma a exclusão do livro
                                    _deletarLivro(livro);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormularioScreen(
                onSalvar: (livro) {
                  // Atualiza a lista local com o novo livro após a criação
                  _atualizarLista(livro);
                },
                onExcluir: _deletarLivro,
              ),
            ),
          );
          _loadLivros(); 
        },
        child: Icon(Icons.add),
        tooltip: 'Adicionar Livro',
      ),
    );
  }
}
