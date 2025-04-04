import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart'; // Para MediaType

class CadastroEspacoScreen extends StatefulWidget {
  @override
  _CadastroEspacoScreenState createState() => _CadastroEspacoScreenState();
}

class _CadastroEspacoScreenState extends State<CadastroEspacoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _tipoController = TextEditingController();
  final _capacidadeController = TextEditingController();
  final _regrasController = TextEditingController();
  final _horarioAberturaController = TextEditingController(text: '08:00');
  final _horarioFechamentoController = TextEditingController(text: '22:00');
  final _recursoController = TextEditingController();
  final _diaIndisponivelController = TextEditingController();

  File? _fotoSelecionada;
  String? _fotoUrl;
  bool _isUploading = false;
  List<String> _recursos = [];
  List<String> _diasIndisponiveis = [];
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL']!,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }

  Future<void> _selecionarFoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _fotoSelecionada = File(result.files.single.path!);
        });
      }
    } catch (e) {
      _mostrarErro('Erro ao selecionar imagem: ${e.toString()}');
    }
  }

  Future<void> _uploadFoto() async {
    if (_fotoSelecionada == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final mimeType = lookupMimeType(_fotoSelecionada!.path);
      final fileName = _fotoSelecionada!.path.split('/').last;

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          _fotoSelecionada!.path,
          filename: fileName,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      });

      final response = await _dio.post(
        'https://api.imgbb.com/1/upload',
        queryParameters: {'key': dotenv.env['IMGBB_API_KEY']},
        data: formData,
        onSendProgress: (sent, total) {
          final progress = (sent / total * 100).round();
          print('Progresso do upload: $progress%');
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _fotoUrl = response.data['data']['url'];
        });
      }
    } on DioException catch (e) {
      String errorMessage = 'Erro no upload';
      if (e.response != null) {
        errorMessage += ': ${e.response?.data['error']['message'] ?? e.response?.statusMessage}';
      } else {
        errorMessage += ': ${e.message}';
      }
      _mostrarErro(errorMessage);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void _adicionarRecurso() {
    if (_recursoController.text.trim().isNotEmpty &&
        !_recursos.contains(_recursoController.text.trim())) {
      setState(() {
        _recursos.add(_recursoController.text.trim());
        _recursoController.clear();
      });
    }
  }

  void _removerRecurso(String recurso) {
    setState(() {
      _recursos.remove(recurso);
    });
  }

  void _adicionarDiaIndisponivel() {
    if (_diaIndisponivelController.text.trim().isNotEmpty &&
        !_diasIndisponiveis.contains(_diaIndisponivelController.text.trim())) {
      setState(() {
        _diasIndisponiveis.add(_diaIndisponivelController.text.trim());
        _diaIndisponivelController.clear();
      });
    }
  }

  void _removerDiaIndisponivel(String dia) {
    setState(() {
      _diasIndisponiveis.remove(dia);
    });
  }

  Future<void> _enviarDados() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isUploading = true;
      });

      // Se tem foto selecionada mas não foi enviada ainda
      if (_fotoSelecionada != null && _fotoUrl == null) {
        await _uploadFoto();
      }

      final espacoData = {
        'nome': _nomeController.text,
        'tipo': _tipoController.text,
        'foto': _fotoUrl,
        'capacidade': int.parse(_capacidadeController.text),
        'recursos': _recursos,
        'regras': _regrasController.text,
        'dias_indisponiveis': _diasIndisponiveis,
        'horario_abertura': _horarioAberturaController.text,
        'horario_fechamento': _horarioFechamentoController.text,
      };

      final response = await _dio.post(
        '/espacos',
        data: espacoData,
      );

      if (response.statusCode == 201) {
        _mostrarSucesso('Espaço cadastrado com sucesso!');
        _limparFormulario();
      }
    } on DioException catch (e) {
      _mostrarErro('Erro ao cadastrar espaço: ${e.response?.data['message'] ?? e.message}');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _limparFormulario() {
    _formKey.currentState?.reset();
    setState(() {
      _fotoSelecionada = null;
      _fotoUrl = null;
      _recursos = [];
      _diasIndisponiveis = [];
    });
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tipoController.dispose();
    _capacidadeController.dispose();
    _regrasController.dispose();
    _horarioAberturaController.dispose();
    _horarioFechamentoController.dispose();
    _recursoController.dispose();
    _diaIndisponivelController.dispose();
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Novo Espaço'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campos do formulário (nome, tipo, capacidade, etc)
              // ... (mantenha os mesmos campos do exemplo anterior)
              
              // Campo de seleção de arquivo
              ElevatedButton(
                onPressed: _isUploading ? null : _selecionarFoto,
                child: Text('Selecionar Foto'),
              ),
              
              if (_fotoSelecionada != null) ...[
                SizedBox(height: 8),
                Text(
                  'Arquivo selecionado: ${_fotoSelecionada!.path.split('/').last}',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 8),
                Image.file(
                  _fotoSelecionada!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ],

              if (_fotoUrl != null) ...[
                SizedBox(height: 8),
                Text('Imagem enviada:'),
                SizedBox(height: 8),
                Image.network(
                  _fotoUrl!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ],

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploading ? null : _enviarDados,
                child: _isUploading
                    ? CircularProgressIndicator()
                    : Text('Cadastrar Espaço'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}