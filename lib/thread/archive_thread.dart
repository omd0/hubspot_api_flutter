import 'package:http/http.dart' as http;

Future<bool> deleteThread(String accessToken, String threadId) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/threads/$threadId',
  );

  final headers = {
    'accept': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 204) {
      // 204 No Content indicates successful deletion
      return true;
    } else {
      print(
          'Failed to delete thread: ${response.statusCode}, ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error deleting thread: $e');
    return false;
  }
}

void main() async {
  final accessToken = 'YOUR_ACCESS_TOKEN';
  final threadId = '0';

  final isDeleted = await deleteThread(accessToken, threadId);

  if (isDeleted) {
    print('Thread deleted successfully.');
  } else {
    print('Failed to delete thread.');
  }
}
