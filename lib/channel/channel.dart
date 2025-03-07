import 'dart:convert';
import 'package:http/http.dart' as http;

// Define a class to represent the Channel data structure.
class Channel {
  final String name;
  final String id;

  Channel({
    required this.name,
    required this.id,
  });

  // Factory method to create a Channel instance from a JSON map.
  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      name: json['name'],
      id: json['id'],
    );
  }

  // Method to convert a Channel instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}

Future<Channel?> getChannel(String accessToken) async {
  // Construct the URL.
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/channels/0',
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
      //create and return a Channel object
      return Channel.fromJson(jsonData);
    } else {
      // Handle the error.
      print('Failed to get channel: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    // Handle any exceptions.
    print('Error getting channel: $e');
    return null;
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

class ChannelList {
  final int total;
  final Paging paging;
  final List<Channel> results;

  ChannelList({
    required this.total,
    required this.paging,
    required this.results,
  });

  factory ChannelList.fromJson(Map<String, dynamic> json) {
    return ChannelList(
      total: json['total'],
      paging: Paging.fromJson(json['paging']?['next']),
      results: (json['results'] as List)
          .map((channelJson) => Channel.fromJson(channelJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'paging': {'next': paging.toJson()},
      'results': results.map((channel) => channel.toJson()).toList(),
    };
  }
}

Future<ChannelList?> getChannels(String accessToken) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/channels',
  );

  final headers = {
    'accept': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return ChannelList.fromJson(jsonData);
    } else {
      print('Failed to get channels: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error getting channels: $e');
    return null;
  }
}

void main() async {
  // Replace with your actual access token.
  final accessToken = 'YOUR_ACCESS_TOKEN';

  // Call the getChannel function.
  final channel = await getChannel(accessToken);

  final channels = await getChannels(accessToken);

  if (channels != null) {
    print('Channels: ${channels.toJson()}');
  } else {
    print('Failed to retrieve channels.');
  }
  // Print the channel information.
  if (channel != null) {
    print('Channel: ${channel.toJson()}');
  } else {
    print('Failed to retrieve channel.');
  }
}
