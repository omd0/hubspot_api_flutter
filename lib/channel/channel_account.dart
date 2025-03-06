import 'dart:convert';
import 'package:hubspot_api/util/paging.dart';
import 'package:http/http.dart' as http;

// Define a class to represent the DeliveryIdentifier data structure.
class DeliveryIdentifier {
  final String type;
  final String value;

  DeliveryIdentifier({
    required this.type,
    required this.value,
  });

  // Factory method to create a DeliveryIdentifier instance from a JSON map.
  factory DeliveryIdentifier.fromJson(Map<String, dynamic> json) {
    return DeliveryIdentifier(
      type: json['type'],
      value: json['value'],
    );
  }

  // Method to convert a DeliveryIdentifier instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }
}

// Define a class to represent the ChannelAccount data structure.
class ChannelAccount {
  final String createdAt;
  final String archivedAt;
  final bool archived;
  final bool authorized;
  final String name;
  final bool active;
  final DeliveryIdentifier deliveryIdentifier;
  final String id;
  final String inboxId;
  final String channelId;

  ChannelAccount({
    required this.createdAt,
    required this.archivedAt,
    required this.archived,
    required this.authorized,
    required this.name,
    required this.active,
    required this.deliveryIdentifier,
    required this.id,
    required this.inboxId,
    required this.channelId,
  });

  // Factory method to create a ChannelAccount instance from a JSON map.
  factory ChannelAccount.fromJson(Map<String, dynamic> json) {
    return ChannelAccount(
      createdAt: json['createdAt'],
      archivedAt: json['archivedAt'],
      archived: json['archived'],
      authorized: json['authorized'],
      name: json['name'],
      active: json['active'],
      deliveryIdentifier:
          DeliveryIdentifier.fromJson(json['deliveryIdentifier']),
      id: json['id'],
      inboxId: json['inboxId'],
      channelId: json['channelId'],
    );
  }

  // Method to convert a ChannelAccount instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'archivedAt': archivedAt,
      'archived': archived,
      'authorized': authorized,
      'name': name,
      'active': active,
      'deliveryIdentifier': deliveryIdentifier.toJson(),
      'id': id,
      'inboxId': inboxId,
      'channelId': channelId,
    };
  }
}

class ChannelAccountList {
  final int total;
  final Paging paging;
  final List<ChannelAccount> results;

  ChannelAccountList({
    required this.total,
    required this.paging,
    required this.results,
  });

  factory ChannelAccountList.fromJson(Map<String, dynamic> json) {
    return ChannelAccountList(
      total: json['total'],
      paging: Paging.fromJson(json['paging']?['next']),
      results: (json['results'] as List)
          .map((accountJson) => ChannelAccount.fromJson(accountJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'paging': {'next': paging.toJson()},
      'results': results.map((account) => account.toJson()).toList(),
    };
  }
}

Future<ChannelAccountList?> getChannelAccounts(String accessToken) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/channel-accounts',
  );

  final headers = {
    'accept': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return ChannelAccountList.fromJson(jsonData);
    } else {
      print(
          'Failed to get channel accounts: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error getting channel accounts: $e');
    return null;
  }
}

Future<ChannelAccount?> getChannelAccount(String accessToken) async {
  // Construct the URL.
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/channel-accounts/0',
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
      //create and return a ChannelAccount object
      return ChannelAccount.fromJson(jsonData);
    } else {
      // Handle the error.
      print(
          'Failed to get channel account: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    // Handle any exceptions.
    print('Error getting channel account: $e');
    return null;
  }
}

void main() async {
  // Replace with your actual access token.
  final accessToken = 'YOUR_ACCESS_TOKEN';

  // Call the getChannelAccount function.
  final channelAccount = await getChannelAccount(accessToken);
  final channelAccounts = await getChannelAccounts(accessToken);

  if (channelAccounts != null) {
    print('Channel Accounts: ${channelAccounts.toJson()}');
  } else {
    print('Failed to retrieve channel accounts.');
  }

  // Print the channel account information.
  if (channelAccount != null) {
    print('Channel Account: ${channelAccount.toJson()}');
  } else {
    print('Failed to retrieve channel account.');
  }
}
