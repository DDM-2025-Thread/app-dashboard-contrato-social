import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/chat_model.dart';
import '../../services/chat_service.dart';
import 'chat_visualize_screen.dart';
import 'chat_upload_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  final Color primaryColor = Colors.indigo;

  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Meus Chats',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ChatUploadScreen()),
          );
        },
        icon: const Icon(Icons.cloud_upload),
        label: const Text('Novo Upload'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      body: FutureBuilder<List<ChatModel>>(
        future: ChatService.findByUser(),
        builder: (context, snapshot) {
          final List<Widget> children = [];

          children.add(_buildCustomHeader(context));

          if (snapshot.connectionState == ConnectionState.waiting) {
            children.add(const Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            children.add(
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'Erro ao carregar o histórico: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            children.add(
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'Você ainda não possui nenhum chat. Clique no botão "Novo Upload" para começar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            );
          } else {
            final List<ChatModel> chats = snapshot.data!;
            children.addAll(
              chats.map((chat) => _buildChatListItem(context, chat)).toList(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: children,
          );
        },
      ),
    );
  }

  Widget _buildChatListItem(BuildContext context, ChatModel chat) {
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
      'dd/MM/yyyy - HH:mm',
    ).format(chat.createdAt.toLocal());
    String displayUuid = chat.ticketUuid;
    String displayName = chat.name.length > 36
        ? '${chat.name.substring(0, 36)}...'
        : chat.name;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: statusColor.withOpacity(0.4), width: 1),
      ),

      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ChatVisualizeScreen(ticketUuid: chat.ticketUuid),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        chat.status,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.grey.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Divider(height: 15),

              Text(
                'Nome do Arquivo:',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Text(
                displayName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'Ticket:',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Text(
                displayUuid,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),

              if (isError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '❌ Falha no processamento. Clique para ver detalhes.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
