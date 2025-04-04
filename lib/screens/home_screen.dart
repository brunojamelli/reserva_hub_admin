import 'package:flutter/material.dart';
import 'package:reserva_hub_admin/screens/ocorrencias_screen.dart';
import '../models/ocorrencia_model.dart';
import '../repositories/ocorrencia_repository.dart';
import '../widgets/ocorrencia_card.dart'; // caminho do seu widget de card

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OcorrenciaRepository _repository = OcorrenciaRepository();
  late Future<List<Ocorrencia>> _ocorrenciasFuture;

  @override
  void initState() {
    super.initState();
    _ocorrenciasFuture = _repository.fetchOcorrencias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Início'),
      //   centerTitle: true,
      // ),
      body: FutureBuilder<List<Ocorrencia>>(
        future: _ocorrenciasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma ocorrência encontrada.'));
          }

          final top3 = snapshot.data!
          .where((o) => o.dataRegistro != null)
          .toList()
          ..sort((a, b) =>b.dataRegistro!.compareTo(a.dataRegistro!))
          ..take(3);

          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Últimas Ocorrências',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ...top3.map((ocorrencia) => OcorrenciaCard(ocorrencia: ocorrencia)).take(3).toList(),
              // TextButton(
              //   onPressed: () {
              //     // Navega pra tela completa de ocorrências
              //     // Navigator.pushNamed(context, '/ocorrencias'); // ou use Navigator.push com OcorrenciaScreen()
              //     // Navigator.push(OcorrenciaScreen());
              //   },
              //   child: const Text('Ver todas'),
              // ),
            ],
          );
        },
      ),
    );
  }
}
