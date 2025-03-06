import 'dart:convert';
import 'package:hubspot_api/util/paging.dart';
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

Future<Thread?> getThread(String accessToken) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/threads/0',
  );

  final headers = {
    'accept': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Thread.fromJson(jsonData);
    } else {
      print('Failed to get thread: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error getting thread: $e');
    return null;
  }
}

void main() async {
  final accessToken = 'YOUR_ACCESS_TOKEN';

  final thread = await getThread(accessToken);

  if (thread != null) {
    print('Thread: ${thread.toJson()}');
  } else {
    print('Failed to retrieve thread.');
  }
}

class ThreadList {
  final Paging paging;
  final List<Thread> results;

  ThreadList({
    required this.paging,
    required this.results,
  });

  factory ThreadList.fromJson(Map<String, dynamic> json) {
    return ThreadList(
      paging: Paging.fromJson(json['paging']?['next']),
      results: (json['results'] as List)
          .map((threadJson) => Thread.fromJson(threadJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paging': {'next': paging.toJson()},
      'results': results.map((thread) => thread.toJson()).toList(),
    };
  }
}

Future<ThreadList?> getThreads(String accessToken) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/threads',
  );

  final headers = {
    'accept': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return ThreadList.fromJson(jsonData);
    } else {
      print('Failed to get threads: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error getting threads: $e');
    return null;
  }
}
