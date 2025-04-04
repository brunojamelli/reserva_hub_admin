import 'package:flutter/material.dart';
import 'package:reserva_hub_admin/screens/cadastro_espaco_screen.dart';

class EspacosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('CADASTRAR NOVO ESPAÇO'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastroEspacoScreen()),
              );
            },
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.celebration, color: Colors.green),
                title: Text('Salão de Festas'),
                subtitle: Text('Capacidade: 100 pessoas'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Navegar para detalhes do espaço
                },
              ),
              ListTile(
                leading: Icon(Icons.sports_soccer, color: Colors.green),
                title: Text('Quadra Poliesportiva'),
                subtitle: Text('Capacidade: 30 pessoas'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Navegar para detalhes do espaço
                },
              ),
              // Adicione mais espaços conforme necessário
            ],
          ),
        ),
      ],
    );
  }
}