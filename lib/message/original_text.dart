import 'dart:convert';
import 'package:http/http.dart' as http;

class OriginalContent {
  final String text;
  final String richText;

  OriginalContent({
    required this.text,
    required this.richText,
  });

  factory OriginalContent.fromJson(Map<String, dynamic> json) {
    return OriginalContent(
      text: json['text'],
      richText: json['richText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'richText': richText,
    };
  }
}

Future<OriginalContent?> getOriginalContent(
    String accessToken, String threadId, String messageId) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/threads/$threadId/messages/$messageId/original-content',
  );

  final headers = {
    'accept': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return OriginalContent.fromJson(jsonData);
    } else {
      print(
          'Failed to get original content: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error getting original content: $e');
    return null;
  }
}
