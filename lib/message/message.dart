import 'dart:convert';
import 'package:hubspot_api/util/recipient.dart';
import 'package:http/http.dart' as http;

// Define classes for nested objects
class Client {
  final String clientType;
  final int integrationAppId;

  Client({required this.clientType, required this.integrationAppId});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientType: json['clientType'],
      integrationAppId: json['integrationAppId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'clientType': clientType, 'integrationAppId': integrationAppId};
  }
}

class Sender {
  final String actorId;
  final String name;
  final String senderField;
  final DeliveryIdentifier deliveryIdentifier;

  Sender(
      {required this.actorId,
      required this.name,
      required this.senderField,
      required this.deliveryIdentifier});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      actorId: json['actorId'],
      name: json['name'],
      senderField: json['senderField'],
      deliveryIdentifier:
          DeliveryIdentifier.fromJson(json['deliveryIdentifier']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actorId': actorId,
      'name': name,
      'senderField': senderField,
      'deliveryIdentifier': deliveryIdentifier.toJson()
    };
  }
}

class FailureDetails {
  final Map<String, String> errorMessageTokens;
  final String errorMessage;

  FailureDetails(
      {required this.errorMessageTokens, required this.errorMessage});

  factory FailureDetails.fromJson(Map<String, dynamic> json) {
    return FailureDetails(
        errorMessageTokens:
            Map<String, String>.from(json['errorMessageTokens']),
        errorMessage: json['errorMessage']);
  }

  Map<String, dynamic> toJson() {
    return {
      'errorMessageTokens': errorMessageTokens,
      'errorMessage': errorMessage
    };
  }
}

class Status {
  final String statusType;
  final FailureDetails failureDetails;

  Status({required this.statusType, required this.failureDetails});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
        statusType: json['statusType'],
        failureDetails: FailureDetails.fromJson(json['failureDetails']));
  }

  Map<String, dynamic> toJson() {
    return {
      'statusType': statusType,
      'failureDetails': failureDetails.toJson()
    };
  }
}

// Define the Message class
class Message {
  final String type;
  final String id;
  final String conversationsThreadId;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final Client client;
  final List<Sender> senders;
  final List<Recipient> recipients;
  final bool archived;
  final String text;
  final String richText;
  final List<dynamic> attachments;
  final String subject;
  final String truncationStatus;
  final String inReplyToId;
  final Status status;
  final String direction;
  final String channelId;
  final String channelAccountId;

  Message({
    required this.type,
    required this.id,
    required this.conversationsThreadId,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.client,
    required this.senders,
    required this.recipients,
    required this.archived,
    required this.text,
    required this.richText,
    required this.attachments,
    required this.subject,
    required this.truncationStatus,
    required this.inReplyToId,
    required this.status,
    required this.direction,
    required this.channelId,
    required this.channelAccountId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      type: json['type'],
      id: json['id'],
      conversationsThreadId: json['conversationsThreadId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      client: Client.fromJson(json['client']),
      senders:
          (json['senders'] as List).map((i) => Sender.fromJson(i)).toList(),
      recipients: (json['recipients'] as List)
          .map((i) => Recipient.fromJson(i))
          .toList(),
      archived: json['archived'],
      text: json['text'],
      richText: json['richText'],
      attachments: json['attachments'],
      subject: json['subject'],
      truncationStatus: json['truncationStatus'],
      inReplyToId: json['inReplyToId'],
      status: Status.fromJson(json['status']),
      direction: json['direction'],
      channelId: json['channelId'],
      channelAccountId: json['channelAccountId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'conversationsThreadId': conversationsThreadId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'client': client.toJson(),
      'senders': senders.map((e) => e.toJson()).toList(),
      'recipients': recipients.map((e) => e.toJson()).toList(),
      'archived': archived,
      'text': text,
      'richText': richText,
      'attachments': attachments,
      'subject': subject,
      'truncationStatus': truncationStatus,
      'inReplyToId': inReplyToId,
      'status': status.toJson(),
      'direction': direction,
      'channelId': channelId,
      'channelAccountId': channelAccountId,
    };
  }
}

Future<Message?> getMessage(
    String accessToken, String threadId, String messageId) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/threads/$threadId/messages/$messageId',
  );

  final headers = {
    'accept': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Message.fromJson(jsonData);
    } else {
      print('Failed to get message: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error getting message: $e');
    return null;
  }
}

void main() async {
  final accessToken = 'YOUR_ACCESS_TOKEN';
  final threadId = '0';
  final messageId = 'messageId';

  final message = await getMessage(accessToken, threadId, messageId);

  if (message != null) {
    print('Message: ${message.toJson()}');
  } else {
    print('Failed to retrieve message.');
  }
}
