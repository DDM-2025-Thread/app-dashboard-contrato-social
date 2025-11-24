import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Importa os serviços e modelos necessários
import '../models/chat_model.dart';
import '../services/chat_service.dart';

// Importa as telas de destino
import 'chat_visualize_screen.dart'; // Tela de visualização (detalhes)
import 'chat_upload_screen.dart'; // Tela de upload (botão FAB)

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  final Color primaryColor = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Chats'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Floating Action Button para ir para a tela de Upload
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
        // Chama o método para buscar todos os chats do usuário
        future: ChatService.findByUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar o histórico: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'Você ainda não possui nenhum chat. Clique no botão "Novo Upload" para começar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          // Constrói a lista de cards
          final List<ChatModel> chats = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return _buildChatListItem(context, chat);
            },
          );
        },
      ),
    );
  }

  // Constrói o widget de Card para cada item da lista
  Widget _buildChatListItem(BuildContext context, ChatModel chat) {
    final bool isError =
        chat.errorMessage != null && chat.errorMessage!.isNotEmpty;
    final bool isCompleted = chat.status == 'Completed';

    // Define estilos visuais baseados no status
    Color statusColor = isError
        ? Colors.red.shade700
        : (isCompleted ? Colors.green.shade700 : Colors.orange.shade700);
    IconData statusIcon = isError
        ? Icons.cancel
        : (isCompleted ? Icons.check_circle : Icons.pending_actions);
    String formattedDate = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(chat.createdAt.toLocal());
    String displayUuid = chat.ticketUuid.substring(
      0,
      8,
    ); // Exibe apenas os primeiros 8 caracteres

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: statusColor.withOpacity(0.4), width: 1),
      ),

      // Envolve o Card com InkWell para permitir o clique
      child: InkWell(
        onTap: () {
          // Navega para a tela de visualização, passando o UUID do ticket
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
              // Linha do Status e Data
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status com Ícone
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

                  // Data de Criação
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

              // UUID do Ticket (destacado)
              Text(
                'Ticket:',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Text(
                '#$displayUuid...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),

              // Se houver erro, exibe um pequeno aviso
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
