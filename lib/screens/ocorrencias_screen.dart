import 'package:flutter/material.dart';
import '../repositories/ocorrencia_repository.dart';
import '../models/ocorrencia_model.dart';
import '../widgets/ocorrencia_card.dart';

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
    _refreshOcorrencias();
  }

  Future<void> _refreshOcorrencias() async {
    setState(() {
      _futureOcorrencias = _repository.fetchOcorrencias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Ocorrências'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshOcorrencias,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOcorrencias,
        child: FutureBuilder<List<Ocorrencia>>(
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
                  return OcorrenciaCard(
                    ocorrencia: ocorrencia,
                    onTap: () {
                      // Navegar para detalhes da ocorrência
                      // Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) => OcorrenciaDetailScreen(ocorrencia: ocorrencia),
                      // ));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     // Navegar para tela de nova ocorrência
      //     // Navigator.push(context, MaterialPageRoute(
      //     //   builder: (context) => NovaOcorrenciaScreen(),
      //     // ));
      //   },
      // ),
    );
  }
}