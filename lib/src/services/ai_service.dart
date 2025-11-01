import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String baseUrl;
  
  AIService({required this.baseUrl});

  Future<Map<String, dynamic>> extractReceipt({
    required String extractedText,
    String? attachmentId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/extract_receipt'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'extracted_text': extractedText,
        'attachment_id': attachmentId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to extract receipt: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> summarizeVisit({
    required Map<String, dynamic> pet,
    required Map<String, dynamic> visit,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/summarize_visit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pet': pet,
        'visit': visit,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to summarize visit: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
