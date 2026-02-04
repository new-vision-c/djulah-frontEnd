import 'package:djulah/datas/local_storage/conversations_storage_service.dart';
import 'package:djulah/datas/local_storage/pending_messages_storage_service.dart';
import 'package:djulah/datas/local_storage/sync_service.dart';
import 'package:djulah/datas/models/pending_message.model.dart';
import 'package:djulah/domain/entities/conversation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../messages/controllers/messages.controller.dart';

class ConversationController extends GetxController {
  String message = "";
  final messageController = TextEditingController();
  final messages = <Message>[].obs;
  late Conversation conversation;

  PendingMessagesStorageService get _pendingService =>
      Get.find<PendingMessagesStorageService>();
  ConversationsStorageService get _conversationsService => 
      Get.find<ConversationsStorageService>();
  SyncService get _syncService => Get.find<SyncService>();
  
  String get _currentUserId => 'current_user_id'; // TODO: Récupérer depuis AppStorage

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      conversation = Get.arguments as Conversation;
      messages.assignAll(conversation.messages.reversed.toList());
      
      _loadPendingMessages();
      
      Future.microtask(() {
        if (Get.isRegistered<MessagesController>()) {
          Get.find<MessagesController>().markAsRead(conversation.id);
        }
        _conversationsService.markAsRead(conversation.id);
      });
    }
  }
  
  void _loadPendingMessages() {
    final pendingMessages = _pendingService.getAllForConversation(conversation.id);
    
    for (final pending in pendingMessages) {
      final exists = messages.any((m) => m.id == pending.localId);
      if (!exists) {
        final msg = Message(
          id: pending.localId,
          text: pending.text,
          time: pending.createdAt,
          isMe: true,
          status: _mapSyncStatusToMessageStatus(pending.syncStatus),
        );
        
        final insertIndex = messages.indexWhere(
          (m) => m.time.isBefore(pending.createdAt)
        );
        if (insertIndex == -1) {
          messages.add(msg);
        } else {
          messages.insert(insertIndex, msg);
        }
      }
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final text = messageController.text.trim();
    
    messageController.clear();
    message = "";
    update();

    final pendingMessage = await _pendingService.enqueue(
      conversationId: conversation.id,
      text: text,
      senderId: _currentUserId,
    );

    final newMessage = Message(
      id: pendingMessage.localId,
      text: text,
      time: DateTime.now(),
      isMe: true,
      status: MessageStatus.pending,
    );
    
    messages.insert(0, newMessage);

    _updateGlobal(newMessage);
    
    await _conversationsService.addMessageToConversation(
      conversationId: conversation.id,
      message: newMessage,
      localId: pendingMessage.localId,
    );

    _syncAndUpdateStatus(pendingMessage.localId);
  }
  
  Future<void> _syncAndUpdateStatus(String localId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_syncService.isOnline.value) {
      await _pendingService.markAsSending(localId);
      _updateMessageStatus(localId, MessageStatus.pending);
      
      await _syncService.syncNow();
      
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedPending = _pendingService.pendingMessages
          .firstWhereOrNull((m) => m.localId == localId);
      
      if (updatedPending == null) {
        _updateMessageStatus(localId, MessageStatus.sent);
        
        await Future.delayed(const Duration(seconds: 2));
        _updateMessageStatus(localId, MessageStatus.viewed);
        await _pendingService.markAsViewed(localId);
      } else if (updatedPending.syncStatus == MessageSyncStatus.failed) {
        _updateMessageStatus(localId, MessageStatus.failed);
      }
    } else {
      _updateMessageStatus(localId, MessageStatus.pending);
    }
  }
  
  Future<void> retryMessage(String messageId) async {
    final success = await _pendingService.retry(messageId);
    if (success) {
      _updateMessageStatus(messageId, MessageStatus.pending);
      _syncAndUpdateStatus(messageId);
    }
  }

  void _updateMessageStatus(String id, MessageStatus newStatus) {
    int index = messages.indexWhere((m) => m.id == id);
    if (index != -1) {
      final updatedMsg = Message(
        id: messages[index].id,
        text: messages[index].text,
        time: messages[index].time,
        isMe: true,
        status: newStatus,
      );
      messages[index] = updatedMsg;
      messages.refresh();
      
      _conversationsService.updateMessageStatus(
        conversationId: conversation.id,
        messageId: id,
        status: newStatus,
        localId: id,
      );
      
      _updateGlobal(updatedMsg);
    }
  }

  void _updateGlobal(Message msg) {
    if (Get.isRegistered<MessagesController>()) {
      Get.find<MessagesController>().updateLastMessage(conversation.id, msg);
    }
  }
  
  MessageStatus _mapSyncStatusToMessageStatus(MessageSyncStatus syncStatus) {
    switch (syncStatus) {
      case MessageSyncStatus.pending:
      case MessageSyncStatus.sending:
        return MessageStatus.pending;
      case MessageSyncStatus.failed:
        return MessageStatus.failed;
      case MessageSyncStatus.sent:
      case MessageSyncStatus.delivered:
        return MessageStatus.sent;
      case MessageSyncStatus.viewed:
        return MessageStatus.viewed;
    }
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
}
