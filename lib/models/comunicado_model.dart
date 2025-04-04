class Comunicado {
  final String? id;
  final String titulo;
  final String mensagem;
  final DateTime dataEnvio;
  final String prioridade;
  final String categoria;
  String? anexo;

  Comunicado({
    this.id,
    this.anexo,
    required this.titulo,
    required this.mensagem,
    required this.dataEnvio,
    required this.prioridade,
    required this.categoria,
  });

  factory Comunicado.fromJson(Map<String, dynamic> json) {
    return Comunicado(
      id: json['id'].toString(),
      titulo: json['titulo'] as String,
      mensagem: json['mensagem'] as String,
      dataEnvio: DateTime.parse(json['data_envio'] as String),
      prioridade: json['prioridade'] as String,
      categoria: json['categoria'] as String,
      anexo: json['anexo'] as String 
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'titulo': titulo,
    'mensagem': mensagem,
    'data_envio': dataEnvio.toIso8601String(), // <- importante!
    'id_remetente': 1,
    'prioridade': prioridade,
    'categoria': categoria,
    'anexo': anexo
  };
}
}