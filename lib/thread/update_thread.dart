import 'dart:convert';
import 'package:http/http.dart' as http;

class ThreadAssociations {
  final String associatedTicketId;

  ThreadAssociations({required this.associatedTicketId});

  factory ThreadAssociations.fromJson(Map<String, dynamic> json) {
    return ThreadAssociations(associatedTicketId: json['associatedTicketId']);
  }

  Map<String, dynamic> toJson() {
    return {'associatedTicketId': associatedTicketId};
  }
}

class Thread {
  final String associatedContactId;
  final ThreadAssociations threadAssociations;
  final String assignedTo;
  final String createdAt;
  final bool archived;
  final String originalChannelId;
  final String latestMessageTimestamp;
  final String latestMessageSentTimestamp;
  final String originalChannelAccountId;
  final String id;
  final String closedAt;
  final bool spam;
  final String inboxId;
  final String status;
  final String latestMessageReceivedTimestamp;

  Thread({
    required this.associatedContactId,
    required this.threadAssociations,
    required this.assignedTo,
    required this.createdAt,
    required this.archived,
    required this.originalChannelId,
    required this.latestMessageTimestamp,
    required this.latestMessageSentTimestamp,
    required this.originalChannelAccountId,
    required this.id,
    required this.closedAt,
    required this.spam,
    required this.inboxId,
    required this.status,
    required this.latestMessageReceivedTimestamp,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      associatedContactId: json['associatedContactId'],
      threadAssociations:
          ThreadAssociations.fromJson(json['threadAssociations']),
      assignedTo: json['assignedTo'],
      createdAt: json['createdAt'],
      archived: json['archived'],
      originalChannelId: json['originalChannelId'],
      latestMessageTimestamp: json['latestMessageTimestamp'],
      latestMessageSentTimestamp: json['latestMessageSentTimestamp'],
      originalChannelAccountId: json['originalChannelAccountId'],
      id: json['id'],
      closedAt: json['closedAt'],
      spam: json['spam'],
      inboxId: json['inboxId'],
      status: json['status'],
      latestMessageReceivedTimestamp: json['latestMessageReceivedTimestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'associatedContactId': associatedContactId,
      'threadAssociations': threadAssociations.toJson(),
      'assignedTo': assignedTo,
      'createdAt': createdAt,
      'archived': archived,
      'originalChannelId': originalChannelId,
      'latestMessageTimestamp': latestMessageTimestamp,
      'latestMessageSentTimestamp': latestMessageSentTimestamp,
      'originalChannelAccountId': originalChannelAccountId,
      'id': id,
      'closedAt': closedAt,
      'spam': spam,
      'inboxId': inboxId,
      'status': status,
      'latestMessageReceivedTimestamp': latestMessageReceivedTimestamp,
    };
  }
}

Future<Thread?> updateThread(
    String accessToken, String threadId, bool archived, String status) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/threads/$threadId',
  );

  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  final body = json.encode({'archived': archived, 'status': status});

  try {
    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Thread.fromJson(jsonData);
    } else {
      print(
          'Failed to update thread: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error updating thread: $e');
    return null;
  }
}

void main() async {
  final accessToken = 'YOUR_ACCESS_TOKEN';
  final threadId = '0';
  final archived = true;
  final status = 'OPEN'; // Example status

  final thread = await updateThread(accessToken, threadId, archived, status);

  if (thread != null) {
    print('Updated Thread: ${thread.toJson()}');
  } else {
    print('Failed to update thread.');
  }
}
