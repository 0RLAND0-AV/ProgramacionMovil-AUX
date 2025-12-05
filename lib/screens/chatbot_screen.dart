import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../services/chat_db.dart';
import '../services/settings_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService();
  final ChatDb _db = ChatDb();
  final SettingsService _settings = SettingsService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _aiName = 'AmigoIA';
  String _userName = 'Tú';

  @override
  void initState() {
    super.initState();
    _loadSettingsAndHistory();
  }

  Future<void> _loadSettingsAndHistory() async {
    final ai = await _settings.getAiName();
    final user = await _settings.getUserName();
    final rows = await _db.getAllMessages();

    setState(() {
      _aiName = ai;
      _userName = user;
      _messages.clear();
      if (rows.isEmpty) {
        _messages.add(ChatMessage(
          text: '¡Hola! Soy $_aiName, tu asistente. Dime tu nombre en ajustes.' ,
          isUser: false,
        ));
      } else {
        for (final r in rows) {
          _messages.add(ChatMessage(
            text: r['text'] as String,
            isUser: (r['isUser'] as int) == 1,
            timestamp: DateTime.parse(r['timestamp'] as String),
          ));
        }
      }
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;
    });
    _messageController.clear();
    await _db.insertMessage(message, true, DateTime.now().toIso8601String());
    _scrollToBottom();

    // Prepare recent context (last 6 messages)
    final recentRows = await _db.getLastNMessages(6);
    final recentMessages = recentRows.map((r) {
      return {
        'isUser': (r['isUser'] as int).toString(),
        'text': r['text'] as String,
      };
    }).toList();

    final response = await _geminiService.sendMessage(
      message,
      aiName: _aiName,
      userName: _userName,
      recentMessages: recentMessages,
    );

    setState(() {
      _messages.add(ChatMessage(text: response, isUser: false));
      _isLoading = false;
    });
    await _db.insertMessage(response, false, DateTime.now().toIso8601String());
    _scrollToBottom();
  }

  Future<void> _clearHistory() async {
    await _db.clearMessages();
    setState(() {
      _messages.clear();
      _messages.add(ChatMessage(text: '¡Hola! Soy $_aiName, tu asistente.', isUser: false));
    });
  }

  Future<void> _openSettings() async {
    final aiController = TextEditingController(text: _aiName);
    final userController = TextEditingController(text: _userName);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajustes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: aiController,
              decoration: const InputDecoration(labelText: 'Nombre de la IA'),
            ),
            TextField(
              controller: userController,
              decoration: const InputDecoration(labelText: 'Tu nombre'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await _settings.saveAiName(aiController.text.trim());
              await _settings.saveUserName(userController.text.trim());
              Navigator.pop(context, true);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result == true) {
      final ai = await _settings.getAiName();
      final user = await _settings.getUserName();
      setState(() {
        _aiName = ai;
        _userName = user;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(children: [
          const Icon(Icons.smart_toy),
          const SizedBox(width: 8),
          Text(_aiName),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
            tooltip: 'Ajustes',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearHistory,
            tooltip: 'Limpiar historial',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 8),
                  Text('Escribiendo...'),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2)),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Escribe tu mensaje...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    mini: true,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(isUser ? Icons.person : Icons.smart_toy, size: 16, color: isUser ? colorScheme.onPrimary : colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(isUser ? 'Tú' : 'IA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isUser ? colorScheme.onPrimary : colorScheme.onSurfaceVariant)),
            ]),
            const SizedBox(height: 4),
            SelectableText(message.text, style: TextStyle(color: isUser ? colorScheme.onPrimary : colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

