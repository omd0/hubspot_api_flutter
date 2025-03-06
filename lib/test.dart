import 'package:hubspot_api/hubspot_api.dart';

Hubspot hubspotClient = Hubspot("");

void main() {
  hubspotClient.getOriginalContent("threadId", "messageId");
}
