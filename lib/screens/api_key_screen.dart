import 'package:dashboard_application/core/mocks/database.dart';
import 'package:dashboard_application/models/api_key_model.dart';
import 'package:dashboard_application/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyScreen extends StatefulWidget {
  const ApiKeyScreen({Key? key}) : super(key: key);

  @override
  State<ApiKeyScreen> createState() => _ApiKeyScreenState();
}

class _ApiKeyScreenState extends State<ApiKeyScreen> {
  final _apiKeyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddApiKeyDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 8,
            ),
            itemCount: MockDatabase.apiKeys.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.grey[200],
                margin: const EdgeInsets.all(8),
                child: Center(child: Text(MockDatabase.apiKeys[index].name)),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyNameController.dispose();
    super.dispose();
  }

  void _showAddApiKeyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nova Chave de API'),
          content: TextField(
            controller: _apiKeyNameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nome da Chave',
              hintText: 'Ex: Meu App Android',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CustomButton(
              text: 'Salvar',
              onPressed: () async {
                final String apiKeyName = _apiKeyNameController.text;
                if (apiKeyName.isNotEmpty) {
                  Navigator.of(context).pop();
                  await _saveApiKey(apiKeyName);
                  _apiKeyNameController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveApiKey(String name) async {
    final String userId = await _loadUserId();
    final newApiKey = ApiKeyModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      userID: userId,
      status: "active",
      key: _generateApiKey(),
      createdAt: DateTime.now(),
    );

    setState(() {
      MockDatabase.addApiKey(newApiKey);
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Chave de API Gerada'),
            content: SelectableText(
              'Sua nova chave de API é:\n\n${MockDatabase.apiKeys.last.key}\n\nPor favor, copie e guarde-a em um local seguro. Você não poderá vê-la novamente!',
            ),
            actions: <Widget>[
              CustomButton(
                text: 'Copiar',
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: MockDatabase.apiKeys.last.key),
                  );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chave de API "$name" salva com sucesso!')),
      );
    }
  }

  Future<String> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? 'unknown_user';
  }

  String _generateApiKey() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
