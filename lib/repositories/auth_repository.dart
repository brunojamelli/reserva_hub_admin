import 'package:dio/dio.dart';
import '../models/usuario_model.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.1.66:3000'));

  Future<UsuarioModel?> login(String email, String senha) async {
    try {
      final response = await _dio.get('/usuarios'); 

      if (response.statusCode == 200) {
        final users = List<Map<String, dynamic>>.from(response.data);

        final userMap = users.firstWhere(
          (user) => user['email'] == email && user['senha'] == senha && user['tipo'] == 'admin',
          orElse: () => {},
        );

        if (userMap.isNotEmpty) {
          return UsuarioModel.fromJson(userMap);
        }
      }
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
    return null;
  }
}
