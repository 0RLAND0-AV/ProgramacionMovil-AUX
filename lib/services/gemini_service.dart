import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  GeminiService();

  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  /// Sends a message to Gemini. To keep requests efficient, provide a short
  /// summary or only the last few messages in [recentMessages].
  ///
  /// [recentMessages] should be a list of maps with keys: 'isUser' and 'text'.
  Future<String> sendMessage(
    String message, {
    String aiName = 'AmigoIA',
    String userName = 'Usuario',
    List<Map<String, String>> recentMessages = const [],
  }) async {
    try {
      final key = _apiKey;
      if (key.isEmpty) return 'API key no encontrada en .env';

      final url = Uri.parse('$_baseUrl?key=$key');

      // Build a compact prompt: system instructions + recent messages + new message
      final buffer = StringBuffer();
      buffer.writeln('Eres $aiName, un asistente virtual conversacional.');
      buffer.writeln('El nombre del usuario es $userName. Responde de manera amable y breve.');
      if (recentMessages.isNotEmpty) {
        buffer.writeln('\nContexto reciente:');
        for (final m in recentMessages) {
          final who = m['isUser'] == '1' ? userName : aiName;
          buffer.writeln('$who: ${m['text']}');
        }
      }
      buffer.writeln('\n$userName: $message');

      final payload = {
        'contents': [
          {
            'parts': [
              {'text': buffer.toString()}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 512,
        }
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        try {
          final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
          return text;
        } catch (e) {
          return 'Respuesta inesperada del servidor';
        }
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }
}
