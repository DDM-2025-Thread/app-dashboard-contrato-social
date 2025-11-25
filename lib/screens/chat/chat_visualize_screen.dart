import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/chat_service.dart';
import '../../models/chat_model.dart';

class ChatVisualizeScreen extends StatelessWidget {
  final String ticketUuid;
  const ChatVisualizeScreen({super.key, required this.ticketUuid});
  final Color primaryColor = Colors.indigo;

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: FutureBuilder<ChatModel>(
        future: ChatService.getResponse(ticketUuid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Erro ao carregar os detalhes do chat.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Detalhe: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Chat não encontrado.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // Tela principal
          final chat = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Seta para Voltar
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 8),

                    // Título
                    const Expanded(
                      child: Text(
                        'Ver dados do Chat',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                _buildInfoCard(chat),
                const SizedBox(height: 25),

                if (chat.errorMessage != null && chat.errorMessage!.isNotEmpty)
                  _buildErrorMessageBox(chat.errorMessage!),

                const SizedBox(height: 25),

                if (chat.responseJson != null)
                  _buildResponseJsonTile(chat.responseJson!),
              ],
            ),
          );
        },
      ),
    );
  }

  // Card principal
  Widget _buildInfoCard(ChatModel chat) {
    final bool isError =
        chat.errorMessage != null && chat.errorMessage!.isNotEmpty;
    final bool isCompleted = chat.status == 'Completed';

    Color statusColor = isError
        ? Colors.red.shade700
        : (isCompleted ? Colors.green.shade700 : Colors.orange.shade700);
    IconData statusIcon = isError
        ? Icons.cancel
        : (isCompleted ? Icons.check_circle : Icons.pending_actions);
    String formattedDate = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(chat.createdAt.toLocal());

    return Card(
      elevation: 6,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status da Requisição',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const Divider(height: 20),

            _buildInfoRow(
              icon: Icons.description,
              label: 'Nome:',
              content: chat.name,
            ),
            const SizedBox(height: 15),

            _buildInfoRow(
              icon: Icons.vpn_key,
              label: 'Código do Ticket:',
              content: chat.ticketUuid,
            ),
            const SizedBox(height: 15),

            _buildInfoRow(
              icon: statusIcon,
              label: 'Status:',
              content: chat.status,
              contentColor: statusColor,
            ),
            const SizedBox(height: 15),

            _buildInfoRow(
              icon: Icons.access_time,
              label: 'Data/Hora de Criação:',
              content: formattedDate,
            ),
          ],
        ),
      ),
    );
  }

  // (Ícone + Conteúdo)
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String content,
    Color? contentColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SelectableText(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: contentColor ?? Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Caixa de Mensagem de Erro
  Widget _buildErrorMessageBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ERRO DE PROCESSAMENTO:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  // Widget para Response JSON
  Widget _buildResponseJsonTile(String jsonString) {
    String prettyJson;
    try {
      final jsonObject = jsonDecode(jsonString);
      prettyJson = const JsonEncoder.withIndent('  ').convert(jsonObject);
    } catch (e) {
      prettyJson = 'Erro ao formatar JSON. Conteúdo bruto:\n$jsonString';
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.blueGrey.shade50,
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Detalhes da Resposta (JSON)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
            fontSize: 16,
          ),
        ),
        collapsedIconColor: Colors.blueGrey,
        iconColor: primaryColor,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueGrey.shade200),
              ),
              child: SelectableText(
                prettyJson,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
