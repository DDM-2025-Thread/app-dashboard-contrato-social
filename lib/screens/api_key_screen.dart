import 'package:dashboard_application/models/api_key_model.dart';
import 'package:dashboard_application/services/apikey_service.dart';
import 'package:dashboard_application/utils/functions.dart';
import 'package:dashboard_application/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApiKeyScreen extends StatefulWidget {
  const ApiKeyScreen({Key? key}) : super(key: key);

  @override
  State<ApiKeyScreen> createState() => _ApiKeyScreenState();
}

class _ApiKeyScreenState extends State<ApiKeyScreen> {
  final _apiKeyNameController = TextEditingController();
  List<ApiKeyModel> _apiKeys = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchApiKeys();
  }

  Future<void> _fetchApiKeys() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final keys = await ApiKeyService.getApiKeys();
      setState(() {
        _apiKeys = keys;
      });
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Erro ao carregar chaves: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createApiKey(String name) async {
    setState(() => _isLoading = true);
    try {
      final newApiKey = await ApiKeyService.createApiKey(name);
      setState(() {
        _apiKeys.add(newApiKey);
      });
      if (mounted) {
        _showSuccessDialog(newApiKey);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Erro ao criar chave: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteApiKey(ApiKeyModel apiKey) async {
    setState(() => _isLoading = true);
    try {
      await ApiKeyService.deleteApiKey(apiKey.id!);
      setState(() {
        _apiKeys.removeWhere((key) => key.id == apiKey.id);
      });
      if (mounted) {
        showSnackBar(context, 'Chave removida com sucesso');
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Erro ao deletar chave: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddApiKeyDialog,
        child: const Icon(Icons.add),
      ),
      body: _isLoading && _apiKeys.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchApiKeys,
              child: _apiKeys.isEmpty
                  ? const Center(
                      child: Text('Nenhuma chave de API encontrada.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _apiKeys.length,
                      itemBuilder: (context, index) {
                        final apiKey = _apiKeys[index];
                        return Card(
                          color: Colors.grey[200],
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.vpn_key_outlined),
                            title: Text(
                              apiKey.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Criado em: ${formatDate(apiKey.createdAt)}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => _confirmDeleteDialog(apiKey),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  @override
  void dispose() {
    _apiKeyNameController.dispose();
    super.dispose();
  }

  void _showAddApiKeyDialog() {
    String? localErrorText;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nova Chave de API'),
              content: TextField(
                controller: _apiKeyNameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Nome da Chave',
                  hintText: 'Ex: Meu App Android',
                  errorText: localErrorText,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (localErrorText != null) {
                    setDialogState(() {
                      localErrorText = null;
                    });
                  }
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    _apiKeyNameController.clear();
                    Navigator.of(context).pop();
                  },
                ),
                CustomButton(
                  text: 'Salvar',
                  width: 100,
                  onPressed: () {
                    final String apiKeyName = _apiKeyNameController.text.trim();
                    if (apiKeyName.isNotEmpty) {
                      Navigator.of(context).pop();
                      _createApiKey(apiKeyName);
                      _apiKeyNameController.clear();
                    } else {
                      setDialogState(() {
                        localErrorText = 'Por favor, insira um nome';
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(ApiKeyModel apiKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chave Criada!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Copie sua chave agora. Você não poderá vê-la novamente!',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SelectableText(
                  apiKey.key ?? 'Chave indisponível',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Courier',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            CustomButton(
              text: 'Copiar',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: apiKey.key!));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Chave copiada para a área de transferência!',
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteDialog(ApiKeyModel apiKey) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar exclusão"),
          content: Text(
            "Tem certeza que deseja apagar a chave '${apiKey.name}'?",
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Excluir", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteApiKey(apiKey);
              },
            ),
          ],
        );
      },
    );
  }
}
