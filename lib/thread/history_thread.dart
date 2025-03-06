import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hubspot_api/util/paging.dart';

class MessageList {
  final Paging paging;
  final List<dynamic> results;

  MessageList({
    required this.paging,
    required this.results,
  });

  factory MessageList.fromJson(Map<String, dynamic> json) {
    return MessageList(
      paging: Paging.fromJson(json['paging']?['next']),
      results: json['results'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paging': {'next': paging.toJson()},
      'results': results,
    };
  }
}

Future<MessageList?> getThread(String accessToken, String threadId) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/threads/$threadId/messages',
  );

  final headers = {
    'accept': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return MessageList.fromJson(jsonData);
    } else {
      print('Failed to get messages: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error getting messages: $e');
    return null;
  }
}

void main() async {
  final accessToken = 'YOUR_ACCESS_TOKEN';
  final threadId = '0';

  final messages = await getThread(accessToken, threadId);

  if (messages != null) {
    print('Messages: ${messages.toJson()}');
  } else {
    print('Failed to retrieve messages.');
  }
}
