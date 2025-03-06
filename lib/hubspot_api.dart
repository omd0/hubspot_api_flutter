import 'package:hubspot_api/message/message.dart' as Message;
import 'package:hubspot_api/message/original_text.dart' as OriginalContent;
import 'package:hubspot_api/channel/channel.dart' as Channel;
import 'package:hubspot_api/channel/channel_account.dart' as ChannelAccount;
import 'package:hubspot_api/conversation/conversation_inbox.dart' as Inbox;
import 'package:hubspot_api/thread/thread.dart' as Thread;
import 'package:hubspot_api/util/recipient.dart';
import 'package:hubspot_api/message/send_to_thread.dart' as SendToThread;
import 'package:hubspot_api/thread/update_thread.dart' as UpdateThread;
import 'package:hubspot_api/thread/archive_thread.dart' as ArchiveThread;
import 'package:hubspot_api/thread/history_thread.dart' as HistoryThread;
import 'package:hubspot_api/actor/actor.dart' as Actor;

class Hubspot {
  final String _accessToken;

  Hubspot(
    this._accessToken,
  );

  Future<bool> deleteThread(String threadId) =>
      ArchiveThread.deleteThread(_accessToken, threadId);

  Future<ChannelAccount.ChannelAccount?> getChannelAccount() =>
      ChannelAccount.getChannelAccount(_accessToken);

  Future<Actor.Actor?> getActor(String actorId) =>
      Actor.getActor(actorId, _accessToken);

  Future<Actor.BatchReadResponse?> batchReadActors(List<String> actorIds) =>
      Actor.batchReadActors(_accessToken, actorIds);

  Future<Channel.Channel?> getChannel() => Channel.getChannel(_accessToken);

  Future<Channel.ChannelList?> getChannelsList() =>
      Channel.getChannels(_accessToken);

  Future<Inbox.Inbox?> getInboxById() => Inbox.getInbox(_accessToken);

  Future<Inbox.InboxList?> getInboxes() => Inbox.getInboxes(_accessToken);

  Future<Thread.ThreadList?> getThreads() => Thread.getThreads(_accessToken);

  Future<Message.Message?> getMessage(String threadId, String messageId) =>
      Message.getMessage(_accessToken, threadId, messageId);

  Future<OriginalContent.OriginalContent?> getOriginalContent(
          String threadId, String messageId) =>
      OriginalContent.getOriginalContent(_accessToken, threadId, messageId);

  Future<HistoryThread.MessageList?> getThreadById(
          String threadId, String messageId) =>
      HistoryThread.getThread(_accessToken, threadId);

  Future<Message.Message?> sendMessageToThread(
          String threadId,
          String text,
          String richText,
          List<Recipient> recipients,
          String senderActorId,
          String channelId,
          String channelAccountId,
          String subject) =>
      SendToThread.sendMessage(_accessToken, threadId, text, richText,
          recipients, senderActorId, channelId, channelAccountId, subject);

  Future<UpdateThread.Thread?> updateThread(
          String threadId, bool archived, String status) =>
      UpdateThread.updateThread(_accessToken, threadId, archived, status);
}
