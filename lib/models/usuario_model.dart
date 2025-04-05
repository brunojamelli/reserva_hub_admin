class UsuarioModel {
  final String id;
  final String nome;
  final String email;
  final String senha;
  String? apartamento;
  String? bloco;
  String? tipo;
  String? telefone;
  String? tokenNotificacao;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.apartamento,
    this.bloco,
    this.tipo,
    this.telefone,
    this.tokenNotificacao,
  });

  // factory UsuarioModel.fromJson(Map<String, dynamic> json) {
  //   return UsuarioModel(
  //     id: json['id'],
  //     nome: json['nome'],
  //     email: json['email'],
  //     senha: json['senha'],
  //     apartamento: json['apartamento'],
  //     bloco: json['bloco'],
  //     tipo: json['tipo'],
  //     telefone: json['telefone'],
  //     tokenNotificacao: json['token_notificacao'],
  //   );
  // }
    factory UsuarioModel.fromJson(Map<String, dynamic> json) {
      return UsuarioModel(
        id: json['id']?.toString() ?? '', // garante que nunca será null
        nome: json['nome']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        senha: json['senha']?.toString() ?? '',
        apartamento: json['apartamento'] as String?,
        bloco: json['bloco'] as String?,
        tipo: json['tipo'] as String?,
        telefone: json['telefone'] as String?,
        tokenNotificacao: json['token_notificacao'] as String?,
      );
    }

}
