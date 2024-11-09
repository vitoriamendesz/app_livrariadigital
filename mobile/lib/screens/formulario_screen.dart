import 'package:flutter/material.dart';
import '../models/livro.dart';
import '../models/categoria.dart';
import '../services/livro_service.dart';
import '../services/categoria_service.dart';

class FormularioScreen extends StatefulWidget {
  final Function(Livro livro) onSalvar;
  final Function(Livro livro) onExcluir;
  final Livro? livro;

  FormularioScreen({required this.onSalvar, required this.onExcluir, this.livro});

  @override
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _precoController = TextEditingController();
  Categoria? _categoriaSelecionada;
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    _loadCategorias();

    if (widget.livro != null) {
      _tituloController.text = widget.livro!.titulo;
      _autorController.text = widget.livro!.autor;
      _precoController.text = widget.livro!.preco.toString();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_categorias.isNotEmpty) {
          _categoriaSelecionada = _categorias.firstWhere(
            (categoria) => categoria.id == widget.livro!.idCategoria,
            orElse: () => _categorias[0], 
          );
          setState(() {});
        }
      });
    }
  }

  Future<void> _loadCategorias() async {
    try {
      final categorias = await CategoriaService().fetchCategorias();
      setState(() {
        _categorias = categorias;
        if (widget.livro != null && _categorias.isNotEmpty) {
          _categoriaSelecionada = _categorias.firstWhere(
            (categoria) => categoria.id == widget.livro!.idCategoria,
            orElse: () => _categorias[0],
          );
        } else if (_categorias.isNotEmpty) {
          _categoriaSelecionada = _categorias[0]; 
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar categorias!')));
    }
  }

  void _salvarLivro() async {
    final titulo = _tituloController.text;
    final autor = _autorController.text;
    final preco = double.tryParse(_precoController.text);

    if (titulo.isEmpty || autor.isEmpty || preco == null || _categoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha todos os campos corretamente!')));
      return;
    }

    final livro = Livro(
      id: widget.livro?.id, 
      titulo: titulo,
      autor: autor,
      preco: preco,
      idCategoria: _categoriaSelecionada!.id, 
    );

    try {
      if (livro.id == null) {
        await LivroService().addLivro(livro);
      } else {

        await LivroService().updateLivro(livro);
      }
      widget.onSalvar(livro); 
      Navigator.pop(context); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar o livro!')));
    }
  }

  void _excluirLivro() {
    if (widget.livro != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Você tem certeza que deseja excluir este livro?'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await LivroService().deleteLivro(widget.livro!.id!);
                  widget.onExcluir(widget.livro!); 
                  Navigator.pop(context); 
                  Navigator.pop(context); 
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir o livro!')));
                  Navigator.pop(context);
                }
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () {

                Navigator.pop(context); 
              },
              child: Text('Não'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.livro == null ? 'Adicionar Livro' : 'Editar Livro'),
        actions: [
          if (widget.livro != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _excluirLivro,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _autorController,
              decoration: InputDecoration(labelText: 'Autor'),
            ),
            TextField(
              controller: _precoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Preço'),
            ),
            SizedBox(height: 16),
            DropdownButton<Categoria>(
              value: _categoriaSelecionada,
              hint: Text("Selecione uma Categoria"),
              onChanged: (Categoria? categoria) {
                setState(() {
                  _categoriaSelecionada = categoria;
                });
              },
              items: _categorias.map((categoria) {
                return DropdownMenuItem<Categoria>(
                  value: categoria,
                  child: Text(categoria.nome),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarLivro,
              child: Text(widget.livro == null ? 'Adicionar' : 'Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
