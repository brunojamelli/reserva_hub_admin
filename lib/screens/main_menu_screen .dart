import 'package:flutter/material.dart';
import 'package:reserva_hub_admin/screens/espacos_screen.dart';
import 'package:reserva_hub_admin/screens/ocorrencias_screen%20.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _currentIndex = 0;
  
  // Lista de telas correspondentes a cada aba
  final List<Widget> _screens = [
    OcorrenciasScreen(),
    EspacosScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administração Condomínio'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implementar busca
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Menu adicional
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      floatingActionButton: _currentIndex == 0 
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                // Adicionar nova ocorrência
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Ocorrências',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Espaços',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.announcement),
          //   label: 'Comunicados',
          // ),
        ],
      ),
    );
  }
}