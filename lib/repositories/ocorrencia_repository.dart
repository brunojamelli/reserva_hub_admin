import 'package:dio/dio.dart';
import '../models/ocorrencia_model.dart';

class OcorrenciaRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.1.66:3000'));

  Future<List<Ocorrencia>> fetchOcorrencias() async {
    try {
      final response = await _dio.get('/ocorrencias?_sort=data_registro&_order=desc');
      return (response.data as List)
          .map((json) => Ocorrencia.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Falha ao carregar ocorrências: ${e.message}');
    }
  }

  Future<Ocorrencia> createOcorrencia(Ocorrencia ocorrencia) async {
    try {
      final response = await _dio.post(
        '/ocorrencias',
        data: ocorrencia.toJson(),
      );
      return Ocorrencia.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Falha ao criar ocorrência: ${e.message}');
    }
  }
}