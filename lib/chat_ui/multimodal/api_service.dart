// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'file_data.dart';
import '../constants.dart';

class ApiService {
  Future<String> askMultimodal({
    required String question,
    required String userId,
    required String chatTitle,
    required List<FileData> files,
  }) async {
    final url = Uri.parse('$baseUrl/ask_multimodal');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'question': question,
      'user_id': userId,
      'chat_title': chatTitle,
      'files': files.map((file) => file.toJson()).toList(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
          'API Error: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
