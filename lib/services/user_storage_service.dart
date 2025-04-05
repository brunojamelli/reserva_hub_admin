import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_model.dart';

class UserStorageService {
  static const _userKey = 'logged_user';

  Future<void> saveUser(UsuarioModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userKey, jsonEncode({
      'id': user.id,
      'nome': user.nome,
      'email': user.email,
      'senha': user.senha,
      'apartamento': user.apartamento,
      'bloco': user.bloco,
      'tipo': user.tipo,
      'telefone': user.telefone,
      'token_notificacao': user.tokenNotificacao,
    }));
  }

  Future<UsuarioModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);

    if (userData == null) return null;
    return UsuarioModel.fromJson(jsonDecode(userData));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
