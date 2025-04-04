class Comunicado {
  final String? id;
  final String titulo;
  final String mensagem;
  final DateTime dataEnvio;
  final int idRemetente;
  final String prioridade;
  final String categoria;
  final List<int>? lidoPor;
  final String? anexo;

  Comunicado({
    this.id,
    required this.titulo,
    required this.mensagem,
    required this.dataEnvio,
    required this.idRemetente,
    this.prioridade = 'normal',
    this.categoria = 'geral',
    this.lidoPor = const [],
    this.anexo,
  });

  factory Comunicado.fromJson(Map<String, dynamic> json) {
    return Comunicado(
      id: json['id'],
      titulo: json['titulo'],
      mensagem: json['mensagem'],
      dataEnvio: DateTime.parse(json['data_envio']),
      idRemetente: json['id_remetente'],
      prioridade: json['prioridade'],
      categoria: json['categoria'],
      lidoPor: List<int>.from(json['lido_por']),
      anexo: json['anexo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'mensagem': mensagem,
      'data_envio': dataEnvio.toIso8601String(),
      'id_remetente': idRemetente,
      'prioridade': prioridade,
      'categoria': categoria,
      'lido_por': lidoPor,
      'anexo': anexo,
    };
  }
}