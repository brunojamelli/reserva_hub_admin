import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:reserva_hub_admin/models/comunicado_model.dart';
import 'package:reserva_hub_admin/repositories/comunicado_repository.dart';

class NovoComunicadoScreen extends StatefulWidget {
  final int idRemetente;

  const NovoComunicadoScreen({super.key, required this.idRemetente});

  @override
  _NovoComunicadoScreenState createState() => _NovoComunicadoScreenState();
}

class _NovoComunicadoScreenState extends State<NovoComunicadoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _mensagemController = TextEditingController();
  final _prioridades = ['alta', 'normal', 'baixa'];
  final _categorias = ['manutenção', 'segurança', 'eventos', 'geral'];
  
  String _prioridadeSelecionada = 'normal';
  String _categoriaSelecionada = 'geral';
  bool _isLoading = false;

  late ComunicadoRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = ComunicadoRepository(
      dio: Dio(),
      baseUrl: dotenv.env['API_BASE_URL']!,
    );
  }

  Future<void> _enviarComunicado() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final comunicado = Comunicado(
        titulo: _tituloController.text,
        mensagem: _mensagemController.text,
        dataEnvio: DateTime.now(),
        // idRemetente: widget.idRemetente,
        prioridade: _prioridadeSelecionada,
        categoria: _categoriaSelecionada,
        anexo: ""
      );

      await _repository.enviarComunicado(comunicado);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comunicado enviado com sucesso!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Comunicado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título*',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _prioridadeSelecionada,
                  items: _prioridades.map((prioridade) {
                    return DropdownMenuItem(
                      value: prioridade,
                      child: Text(prioridade.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _prioridadeSelecionada = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Prioridade',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _categoriaSelecionada,
                  items: _categorias.map((categoria) {
                    return DropdownMenuItem(
                      value: categoria,
                      child: Text(categoria.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoriaSelecionada = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mensagemController,
                  decoration: const InputDecoration(
                    labelText: 'Mensagem*',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a mensagem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _enviarComunicado,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('ENVIAR COMUNICADO'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _mensagemController.dispose();
    super.dispose();
  }
}