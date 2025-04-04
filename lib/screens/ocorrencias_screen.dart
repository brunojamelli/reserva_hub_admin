import 'package:flutter/material.dart';
import '../repositories/ocorrencia_repository.dart';
import '../models/ocorrencia_model.dart';
// import 'nova_ocorrencia_screen.dart';

class OcorrenciaScreen extends StatefulWidget {
  const OcorrenciaScreen({super.key});

  @override
  State<OcorrenciaScreen> createState() => _OcorrenciaScreenState();
}

class _OcorrenciaScreenState extends State<OcorrenciaScreen> {
  final OcorrenciaRepository _repository = OcorrenciaRepository();
  late Future<List<Ocorrencia>> _futureOcorrencias;

  @override
  void initState() {
    super.initState();
    _futureOcorrencias = _repository.fetchOcorrencias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Ocorências'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => NovaOcorrenciaScreen(),
              //   ),
              // );
              setState(() {
                _futureOcorrencias = _repository.fetchOcorrencias();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Ocorrencia>>(
        future: _futureOcorrencias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma ocorrência registrada'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ocorrencia = snapshot.data![index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: _getStatusIcon(ocorrencia.status),
                    title: Text(ocorrencia.tipo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ocorrencia.local),
                        Text(ocorrencia.descricao),
                        Text(
                          'Registrado em: ${_formatDate(ocorrencia.data_registro)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navegar para detalhes
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Icon _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'resolvido':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'em_andamento':
        return const Icon(Icons.build, color: Colors.orange);
      default:
        return const Icon(Icons.error, color: Colors.red);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}