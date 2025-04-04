class Ocorrencia {
  final String id;
  final int idUsuario;
  String tipo;
  String local;
  String descricao;
  final DateTime data_registro;
  final String status;
  List<String> fotos;
  final List<Comentario> comentarios;

  Ocorrencia({
    required this.id,
    required this.idUsuario,
    required this.tipo,
    required this.local,
    required this.descricao,
    required this.data_registro,
    required this.status,
    required this.fotos,
    required this.comentarios,
  });

  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
    return Ocorrencia(
      id: json['id'].toString(),
      idUsuario: json['id_usuario'],
      tipo: json['tipo'] as String,
      local: json['local'] as String,
      descricao: json['descricao'] as String,
      data_registro: DateTime.parse(json['data_registro']),
      status: json['status'],
      fotos: List<String>.from(json['fotos']),
      comentarios: (json['comentarios'] as List)
          .map((c) => Comentario.fromJson(c))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'tipo': tipo,
      'local': local,
      'descricao': descricao,
      'fotos': fotos,
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