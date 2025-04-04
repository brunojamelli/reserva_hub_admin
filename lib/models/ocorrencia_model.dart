class Ocorrencia {
  final String? id;
  final int idUsuario;
  String tipo;
  String local;
  String descricao;
  DateTime? dataRegistro;
  final String? status;
  List<String>? fotos;
  final List<Comentario>? comentarios;

  Ocorrencia({
    this.id,
    required this.idUsuario,
    required this.tipo,
    required this.local,
    required this.descricao,
    required this.dataRegistro,
    required this.status,
    required this.fotos,
    required this.comentarios,
  });

  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
  return Ocorrencia(
    id: json['id']?.toString(), // pode ser null
    idUsuario: json['id_usuario'],
    tipo: json['tipo'] ?? '', // default vazio se não vier
    local: json['local'] ?? '',
    descricao: json['descricao'] ?? '',
    dataRegistro: json['data_registro'] != null
        ? DateTime.parse(json['data_registro'])
        : null,
    status: json['status']?.toString(),
    fotos: json['fotos'] != null
        ? List<String>.from(json['fotos'])
        : [],
    comentarios: json['comentarios'] != null
        ? (json['comentarios'] as List)
            .map((c) => Comentario.fromJson(c))
            .toList()
        : [],
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'tipo': tipo,
      'local': local,
      'descricao': descricao,
      'data_registro': dataRegistro?.toIso8601String(),
      'fotos': fotos,
      'status': status

    };
  }
}

class Comentario {
  final int idAdmin;
  final String mensagem;
  final DateTime data;

  Comentario({
    required this.idAdmin,
    required this.mensagem,
    required this.data,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      idAdmin: json['id_admin'],
      mensagem: json['mensagem'],
      data: DateTime.parse(json['data']),
    );
  }
}