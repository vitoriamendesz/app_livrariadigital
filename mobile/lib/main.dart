import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/listagem_screen.dart';
import 'screens/formulario_screen.dart';
import 'models/livro.dart'; 

void main() {
  runApp(BibliotecaDigitalApp());
}

class BibliotecaDigitalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca Digital',
      theme: ThemeData(
        primaryColor: Color(0xFFAD8C74),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFB29F8E)),
        scaffoldBackgroundColor: Color(0xFFE5DFDA),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BibliotecaDigitalHome(),
        '/listagem': (context) => ListagemScreen(),
        '/formulario': (context) => FormularioScreen(
              onSalvar: (livro) {
                print("Livro salvo: $livro");
                Navigator.of(context).pop();
              },
              onExcluir: (id) {
                print("Livro excluído: $id");
              },
            ),
      },
    );
  }
}

class BibliotecaDigitalHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biblioteca Digital'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              title: Text('Listagem de Livros'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/listagem');
              },
            ),
            ListTile(
              title: Text('Adicionar Livro'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/formulario');
              },
            ),
          ],
        ),
      ),
      body: DashboardScreen(),
    );
  }
}
