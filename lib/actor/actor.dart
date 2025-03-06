import 'dart:convert';
import 'package:http/http.dart' as http;

// Define a class to represent the response data structure.
class Actor {
  final String type;
  final String id;
  final String name;
  final String email;
  final String avatar;

  Actor({
    required this.type,
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  // Factory method to create an Actor instance from a JSON map.
  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      type: json['type'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  // Method to convert an Actor instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }
}

Future<Actor?> getActor(String actorId, String accessToken) async {
  // Construct the URL.
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/actors/$actorId',
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
      //create and return an actor object
      return Actor.fromJson(jsonData);
    } else {
      // Handle the error.
      print('Failed to get actor: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    // Handle any exceptions.
    print('Error getting actor: $e');
    return null;
  }
}

class BatchReadResponse {
  final String completedAt;
  final String requestedAt;
  final String startedAt;
  final Map<String, String> links;
  final List<Actor> results;
  final String status;

  BatchReadResponse({
    required this.completedAt,
    required this.requestedAt,
    required this.startedAt,
    required this.links,
    required this.results,
    required this.status,
  });

  factory BatchReadResponse.fromJson(Map<String, dynamic> json) {
    return BatchReadResponse(
      completedAt: json['completedAt'],
      requestedAt: json['requestedAt'],
      startedAt: json['startedAt'],
      links: Map<String, String>.from(json['links']),
      results: (json['results'] as List)
          .map((actorJson) => Actor.fromJson(actorJson))
          .toList(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedAt': completedAt,
      'requestedAt': requestedAt,
      'startedAt': startedAt,
      'links': links,
      'results': results.map((actor) => actor.toJson()).toList(),
      'status': status,
    };
  }
}

Future<BatchReadResponse?> batchReadActors(
    String accessToken, List<String> actorIds) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/actors/batch/read',
  );

  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  final body = json.encode({'inputs': actorIds});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return BatchReadResponse.fromJson(jsonData);
    } else {
      print(
          'Failed to batch read actors: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error batch reading actors: $e');
    return null;
  }
}

void main() async {
  // Replace with your actual actor ID and access token.
  final actorId = 'actorId';
  final accessToken = 'YOUR_ACCESS_TOKEN';

  // Call the getActor function.
  final actor = await getActor(actorId, accessToken);

  // Print the actor information.
  if (actor != null) {
    print('Actor: ${actor.toJson()}');
  } else {
    print('Failed to retrieve actor.');
  }
}
