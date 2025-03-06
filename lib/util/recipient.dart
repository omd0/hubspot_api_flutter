class DeliveryIdentifier {
  final String type;
  final String value;

  DeliveryIdentifier({required this.type, required this.value});

  factory DeliveryIdentifier.fromJson(Map<String, dynamic> json) {
    return DeliveryIdentifier(type: json['type'], value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'value': value};
  }
}

class Recipient {
  final List<DeliveryIdentifier> deliveryIdentifiers;
  final String actorId;
  final String name;
  final DeliveryIdentifier deliveryIdentifier;
  final String recipientField;

  Recipient({
    required this.deliveryIdentifiers,
    required this.actorId,
    required this.name,
    required this.deliveryIdentifier,
    required this.recipientField,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      deliveryIdentifiers: (json['deliveryIdentifiers'] as List)
          .map((e) => DeliveryIdentifier.fromJson(e))
          .toList(),
      actorId: json['actorId'],
      name: json['name'],
      deliveryIdentifier:
          DeliveryIdentifier.fromJson(json['deliveryIdentifier']),
      recipientField: json['recipientField'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryIdentifiers':
          deliveryIdentifiers.map((e) => e.toJson()).toList(),
      'actorId': actorId,
      'name': name,
      'deliveryIdentifier': deliveryIdentifier.toJson(),
      'recipientField': recipientField,
    };
  }
}
