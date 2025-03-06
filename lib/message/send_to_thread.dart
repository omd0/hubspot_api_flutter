import 'dart:convert';
import 'package:hubspot_api/message/message.dart';
import 'package:hubspot_api/util/recipient.dart';
import 'package:http/http.dart' as http;

class Client {
  final String clientType;
  final int integrationAppId;

  Client({required this.clientType, required this.integrationAppId});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        clientType: json['clientType'],
        integrationAppId: json['integrationAppId']);
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
            DeliveryIdentifier.fromJson(json['deliveryIdentifier']));
  }

  Map<String, dynamic> toJson() {
    return {
      'actorId': actorId,
      'name': name,
      'senderField': senderField,
      'deliveryIdentifier': deliveryIdentifier.toJson(),
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

Future<Message?> sendMessage(
  String accessToken,
  String threadId,
  String text,
  String richText,
  List<Recipient> recipients,
  String senderActorId,
  String channelId,
  String channelAccountId,
  String subject,
) async {
  final url = Uri.https(
    'api.hubapi.com',
    '/conversations/v3/conversations/threads/$threadId/messages',
  );

  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'authorization': 'Bearer $accessToken',
  };

  final body = json.encode({
    'type': 'MESSAGE',
    'text': text,
    'richText': richText,
    'recipients': recipients.map((e) => e.toJson()).toList(),
    'senderActorId': senderActorId,
    'channelId': channelId,
    'channelAccountId': channelAccountId,
    'subject': subject,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Message.fromJson(jsonData);
    } else {
      print('Failed to send message: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error sending message: $e');
    return null;
  }
}

void main() async {
  final accessToken = 'YOUR_ACCESS_TOKEN';
  final threadId = '0';
  final text = 'string';
  final richText = 'string';
  final recipients = [
    Recipient(
      deliveryIdentifiers: [
        DeliveryIdentifier(type: 'string', value: 'string')
      ],
      actorId: 'string',
      name: 'string',
      deliveryIdentifier: DeliveryIdentifier(type: 'string', value: 'string'),
      recipientField: 'string',
    )
  ];
  final senderActorId = 'string';
  final channelId = 'string';
  final channelAccountId = 'string';
  final subject = 'string';

  final message = await sendMessage(accessToken, threadId, text, richText,
      recipients, senderActorId, channelId, channelAccountId, subject);

  if (message != null) {
    print('Message: ${message.toJson()}');
  } else {
    print('Failed to send message.');
  }
}
