import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class PdfUploadScreen extends StatefulWidget {
  const PdfUploadScreen({Key? key}) : super(key: key);

  @override
  State<PdfUploadScreen> createState() => _PdfUploadScreenState();
}

class _PdfUploadScreenState extends State<PdfUploadScreen> {
  File? _selectedPdf;
  String? _fileName;
  int? _fileSize;
  bool _isLoading = false;

  // Função para selecionar o arquivo PDF
  Future<void> _pickPdfFile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        
        setState(() {
          _selectedPdf = file;
          _fileName = result.files.single.name;
          _fileSize = result.files.single.size;
          _isLoading = false;
        });

        _showSnackBar('PDF selecionado com sucesso!', Colors.green);
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Nenhum arquivo selecionado', Colors.orange);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Erro ao selecionar arquivo: $e', Colors.red);
    }
  }

  // Função para preparar o upload (aqui você adicionará a lógica da API depois)
  Future<void> _uploadPdf() async {
    if (_selectedPdf == null) {
      _showSnackBar('Por favor, selecione um PDF primeiro', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Aqui você irá implementar a chamada para sua API
      // Por exemplo:
      // final bytes = await _selectedPdf!.readAsBytes();
      // await suaAPI.uploadPdf(bytes, _fileName);

      await Future.delayed(const Duration(seconds: 2)); // Simulação

      setState(() {
        _isLoading = false;
      });

      _showSnackBar('PDF pronto para envio!', Colors.green);
      
      // Aqui você pode retornar os dados ou fazer o que precisar
      print('Arquivo: $_fileName');
      print('Tamanho: $_fileSize bytes');
      print('Caminho: ${_selectedPdf!.path}');
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Erro no upload: $e', Colors.red);
    }
  }

  // Função para limpar a seleção
  void _clearSelection() {
    setState(() {
      _selectedPdf = null;
      _fileName = null;
      _fileSize = null;
    });
  }

  // Exibir SnackBar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Formatar tamanho do arquivo
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload de PDF'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ícone
            Icon(
              Icons.picture_as_pdf,
              size: 100,
              color: _selectedPdf != null ? Colors.deepPurple : Colors.grey,
            ),
            const SizedBox(height: 30),

            // Informações do arquivo selecionado
            if (_selectedPdf != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.insert_drive_file, color: Colors.deepPurple),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _fileName ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tamanho: ${_formatFileSize(_fileSize ?? 0)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Botão para selecionar PDF
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickPdfFile,
              icon: const Icon(Icons.folder_open),
              label: Text(_selectedPdf == null ? 'Selecionar PDF' : 'Escolher Outro PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 15),

            // Botão para fazer upload
            if (_selectedPdf != null)
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _uploadPdf,
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Preparar Upload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            
            // Botão para limpar
            if (_selectedPdf != null) ...[
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _isLoading ? null : _clearSelection,
                icon: const Icon(Icons.clear),
                label: const Text('Limpar Seleção'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],

            // Indicador de loading
            if (_isLoading) ...[
              const SizedBox(height: 30),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Para usar, adicione isso no seu MaterialApp:
// home: PdfUploadScreen(),