import 'package:dio/dio.dart';
import 'package:reserva_hub_admin/models/comunicado_model.dart';

class ComunicadoRepository {
  final Dio dio;
  final String baseUrl;

  ComunicadoRepository({required this.dio, required this.baseUrl});

  Future<Comunicado> enviarComunicado(Comunicado comunicado) async {
    try {
      final response = await dio.post(
        '$baseUrl/comunicados',
        data: comunicado.toJson(),
      );

      if (response.statusCode == 201) {
        return Comunicado.fromJson(response.data);
      }
      throw Exception('Falha ao enviar comunicado');
    } on DioException catch (e) {
      throw Exception('Erro: ${e.response?.data['message'] ?? e.message}');
    }
  }
}