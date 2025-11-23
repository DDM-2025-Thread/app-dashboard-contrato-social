import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/chat_service.dart';

class ChatUploadScreen extends StatefulWidget {
  const ChatUploadScreen({super.key});

  @override
  State<ChatUploadScreen> createState() => _ChatUploadScreenState();
}

class _ChatUploadScreenState extends State<ChatUploadScreen> {
  PlatformFile? _selectedPlatformFile;
  String _statusMessage = 'Aguardando seleção de PDF';
  String? _ticketId;
  bool _isUploading = false;

  final primaryColor = Colors.indigo.shade700;

  // 1. Função para escolher o arquivo PDF
  Future<void> _choosePdf() async {
    // Chama o mock (ou o FilePicker real)
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final file = result.files.single;
      setState(() {
        _selectedPlatformFile = file;
        _statusMessage = 'PDF Selecionado: ${file.name}';
        _ticketId = null; // Limpa o ticket se um novo arquivo for escolhido
      });
      _showSnackbar('Arquivo pronto para upload.', color: Colors.green);
    } else {
      setState(() {
        _statusMessage = 'Seleção cancelada.';
      });
    }
  }

  // 2. Função para submeter e iniciar o upload
  Future<void> _submitUpload() async {
    if (_selectedPlatformFile == null) {
      _showSnackbar(
        'Por favor, escolha um arquivo PDF primeiro.',
        color: Colors.red,
      );
      return;
    }
    // Garantia de que o arquivo tem conteúdo para upload
    if (_selectedPlatformFile!.bytes == null &&
        _selectedPlatformFile!.path == null) {
      _showSnackbar(
        'Arquivo inválido: Não foi possível carregar o conteúdo do arquivo.',
        color: Colors.red,
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _statusMessage = 'Iniciando upload de ${_selectedPlatformFile!.name}...';
    });

    try {
      // Chama o serviço de upload, passando o PlatformFile.
      // O ChatService agora lida com a compatibilidade Web/Nativo.
      final String ticket = await ChatService.upload(_selectedPlatformFile!);

      setState(() {
        _ticketId = ticket;
        _statusMessage = 'Upload Concluído! O ticket $ticket foi gerado.';
      });
      _showSnackbar('Ticket $ticket gerado!', color: Colors.green);
    } catch (e) {
      setState(() {
        _statusMessage = 'Falha no Upload. Verifique o console.';
      });
      // Em um app real, você pode querer logar a exceção
      print('Erro de Upload: $e');
      _showSnackbar('Erro: $e', color: Colors.red);
    } finally {
      setState(() {
        _isUploading = false;
        // Opcional: _selectedFile = null; para limpar o estado
      });
    }
  }

  // Função auxiliar para mostrar mensagens
  void _showSnackbar(String message, {Color color = Colors.blue}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise de Contrato (PDF)'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Título
              Text(
                'Upload de PDF para Análise com IA',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // **********************************************
              // Caixa para Visualizar o PDF Escolhido
              // **********************************************
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey.shade50,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        _selectedPlatformFile == null
                            ? Icons.upload_file_outlined
                            : Icons.picture_as_pdf,
                        size: 60,
                        color: _selectedPlatformFile == null
                            ? Colors.grey.shade400
                            : Colors.red.shade700,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _selectedPlatformFile?.name ??
                            'Nenhum arquivo escolhido',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: _selectedPlatformFile == null
                              ? FontStyle.italic
                              : FontStyle.normal,
                          color: _selectedPlatformFile == null
                              ? Colors.grey.shade600
                              : Colors.black87,
                        ),
                      ),

                      const Divider(height: 30),

                      // Botão "Escolher PDF"
                      ElevatedButton.icon(
                        onPressed: _isUploading ? null : _choosePdf,
                        icon: const Icon(Icons.folder_open),
                        label: const Text('ESCOLHER PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // **********************************************
              // Botão de Submeter e Indicador de Status
              // **********************************************
              if (_isUploading)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      'Enviando arquivo...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: _selectedPlatformFile != null && !_isUploading
                      ? _submitUpload
                      : null,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('SUBMETER PARA ANÁLISE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedPlatformFile != null
                        ? Colors.green.shade700
                        : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // **********************************************
              // Caixa de Exibição do Ticket
              // **********************************************
              if (_ticketId != null)
                Card(
                  elevation: 6,
                  color: Colors.amber.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.amber.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TICKET DE PROCESSAMENTO GERADO:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          _ticketId!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Use este ID para acompanhar o status na tela de Tickets.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Status geral
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: _isUploading ? FontStyle.normal : FontStyle.italic,
                  color: _isUploading ? primaryColor : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
