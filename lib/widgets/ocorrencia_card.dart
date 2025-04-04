import 'package:flutter/material.dart';
import '../models/ocorrencia_model.dart';

class OcorrenciaCard extends StatelessWidget {
  final Ocorrencia ocorrencia;
  final VoidCallback? onTap;

  const OcorrenciaCard({
    super.key,
    required this.ocorrencia,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: _getStatusIcon(ocorrencia.status ?? ""),
        title: Text(
          ocorrencia.tipo,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              ocorrencia.local,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              ocorrencia.descricao,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Registrado em: ${_formatDate(ocorrencia.dataRegistro ?? DateTime.now())}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }

  Icon _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'resolvido':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'em_andamento':
        return const Icon(Icons.build, color: Colors.orange);
      default:
        return const Icon(Icons.error, color: Colors.red);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}