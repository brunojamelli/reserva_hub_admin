import 'package:flutter/material.dart';
import 'package:reserva_hub_admin/screens/espacos_screen.dart';
import 'package:reserva_hub_admin/screens/home_screen.dart';
import 'package:reserva_hub_admin/screens/novo_comunicado_screen.dart';
import 'package:reserva_hub_admin/screens/ocorrencias_screen.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // agora é a tela inicial
    OcorrenciaScreen(),
    EspacosScreen(),
    NovoComunicadoScreen(idRemetente: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva Hub Admin'),
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Ocorrências',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Espaços',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Comunicados',
          ),
        ],
      ),
    );
  }
}
