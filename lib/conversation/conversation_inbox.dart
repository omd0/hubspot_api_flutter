import 'dart:convert';
import 'package:http/http.dart' as http;

// Define a class to represent the Inbox data structure.
class Inbox {
  final String createdAt;
  final String archivedAt;
  final bool archived;
  final String name;
  final String id;
  final String type;
  final String updatedAt;

  Inbox({
    required this.createdAt,
    required this.archivedAt,
    required this.archived,
    required this.name,
    required this.id,
    required this.type,
    required this.updatedAt,
  });

  // Factory method to create an Inbox instance from a JSON map.
  factory Inbox.fromJson(Map<String, dynamic> json) {
    return Inbox(
      createdAt: json['createdAt'],
      archivedAt: json['archivedAt'],
      archived: json['archived'],
      name: json['name'],
      id: json['id'],
      type: json['type'],
      updatedAt: json['updatedAt'],
    );
  }

  // Method to convert an Inbox instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'archivedAt': archivedAt,
      'archived': archived,
      'name': name,
      'id': id,
      'type': type,
      'updatedAt': updatedAt,
    };
  }
}

class InboxList {
  final int total;
  final Paging paging;
  final List<Inbox> results;

  InboxList({
    required this.total,
    required this.paging,
    required this.results,
  });

  factory InboxList.fromJson(Map<String, dynamic> json) {
    return InboxList(
      total: json['total'],
      paging: Paging.fromJson(json['paging']?['next']),
      results: (json['results'] as List)
          .map((inboxJson) => Inbox.fromJson(inboxJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'paging': {'next': paging.toJson()},
      'results': results.map((inbox) => inbox.toJson()).toList(),
    };
  }
}

class Paging {
  final String? link;
  final String? after;

  Paging({
    required this.link,
    required this.after,
  });

  factory Paging.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Paging(link: null, after: null);
    }
    return Paging(
      link: json['link'],
      after: json['after'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'after': after,
    };
  }
}

Future<Inbox?> getInbox(String accessToken) async {
  // Construct the URL.
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/inboxes/0',
    {'archived': 'false'},
  );

  // Set the headers.
  final headers = {
    'accept': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  try {
    // Make the GET request.
    final response = await http.get(url, headers: headers);

    // Check the response status code.
    if (response.statusCode == 200) {
      // Parse the JSON response.
      final Map<String, dynamic> jsonData = json.decode(response.body);
      //create and return an Inbox object
      return Inbox.fromJson(jsonData);
    } else {
      // Handle the error.
      print('Failed to get inbox: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    // Handle any exceptions.
    print('Error getting inbox: $e');
    return null;
  }
}

Future<InboxList?> getInboxes(String accessToken) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/inboxes',
  );

  final headers = {
    'accept': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return InboxList.fromJson(jsonData);
    } else {
      print('Failed to get inboxes: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error getting inboxes: $e');
    return null;
  }
}

void main() async {
  // Replace with your actual access token.
  final accessToken = 'YOUR_ACCESS_TOKEN';

  // Call the getInbox function.
  final inbox = await getInbox(accessToken);

  // Print the inbox information.
  if (inbox != null) {
    print('Inbox: ${inbox.toJson()}');
  } else {
    print('Failed to retrieve inbox.');
  }
}
