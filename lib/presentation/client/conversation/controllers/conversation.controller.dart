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
  
  /// Services de stockage
  PendingMessagesStorageService get _pendingService => 
      Get.find<PendingMessagesStorageService>();
  ConversationsStorageService get _conversationsService => 
      Get.find<ConversationsStorageService>();
  SyncService get _syncService => Get.find<SyncService>();
  
  /// ID utilisateur courant (à remplacer par l'ID réel de l'utilisateur connecté)
  String get _currentUserId => 'current_user_id'; // TODO: Récupérer depuis AppStorage

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      conversation = Get.arguments as Conversation;
      // On inverse pour que le plus récent soit à l'index 0 (car reverse: true dans la vue)
      messages.assignAll(conversation.messages.reversed.toList());
      
      // Charger les messages pending locaux pour cette conversation
      _loadPendingMessages();
      
      Future.microtask(() {
        if (Get.isRegistered<MessagesController>()) {
          Get.find<MessagesController>().markAsRead(conversation.id);
        }
        // Mettre à jour le cache
        _conversationsService.markAsRead(conversation.id);
      });
    }
  }
  
  /// Charge les messages en attente depuis le stockage local
  void _loadPendingMessages() {
    final pendingMessages = _pendingService.getAllForConversation(conversation.id);
    
    for (final pending in pendingMessages) {
      // Vérifier si le message n'existe pas déjà
      final exists = messages.any((m) => m.id == pending.localId);
      if (!exists) {
        final msg = Message(
          id: pending.localId,
          text: pending.text,
          time: pending.createdAt,
          isMe: true,
          status: _mapSyncStatusToMessageStatus(pending.syncStatus),
        );
        
        // Insérer au bon endroit (par date)
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

  /// Envoie un message avec persistence locale
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final text = messageController.text.trim();
    
    messageController.clear();
    message = "";
    update();

    // 1. Créer le message pending dans le stockage local
    final pendingMessage = await _pendingService.enqueue(
      conversationId: conversation.id,
      text: text,
      senderId: _currentUserId,
    );

    // 2. Créer le message pour l'UI
    final newMessage = Message(
      id: pendingMessage.localId,
      text: text,
      time: DateTime.now(),
      isMe: true,
      status: MessageStatus.pending,
    );
    
    // 3. Ajouter à l'UI
    messages.insert(0, newMessage);

    // 4. Mettre à jour le MessagesController
    _updateGlobal(newMessage);
    
    // 5. Sauvegarder dans le cache des conversations
    await _conversationsService.addMessageToConversation(
      conversationId: conversation.id,
      message: newMessage,
      localId: pendingMessage.localId,
    );

    // 6. Déclencher la synchronisation
    _syncAndUpdateStatus(pendingMessage.localId);
  }
  
  /// Synchronise le message et met à jour le statut
  Future<void> _syncAndUpdateStatus(String localId) async {
    // Attendre un peu pour l'UI
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Vérifier si on est en ligne
    if (_syncService.isOnline.value) {
      // Simuler l'envoi (la vraie logique est dans SyncService)
      await _pendingService.markAsSending(localId);
      _updateMessageStatus(localId, MessageStatus.pending);
      
      // Déclencher la sync
      await _syncService.syncNow();
      
      // Vérifier le résultat
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedPending = _pendingService.pendingMessages
          .firstWhereOrNull((m) => m.localId == localId);
      
      if (updatedPending == null) {
        // Message envoyé avec succès
        _updateMessageStatus(localId, MessageStatus.sent);
        
        // Simuler la vue après un délai
        await Future.delayed(const Duration(seconds: 2));
        _updateMessageStatus(localId, MessageStatus.viewed);
        await _pendingService.markAsViewed(localId);
      } else if (updatedPending.syncStatus == MessageSyncStatus.failed) {
        // Échec de l'envoi
        _updateMessageStatus(localId, MessageStatus.failed);
      }
    } else {
      // Hors ligne - le message reste en pending
      _updateMessageStatus(localId, MessageStatus.pending);
    }
  }
  
  /// Réessaie d'envoyer un message échoué
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
      
      // Mettre à jour le cache
      _conversationsService.updateMessageStatus(
        conversationId: conversation.id,
        messageId: id,
        status: newStatus,
        localId: id,
      );
      
      // Crucial : mettre à jour le MessagesController pour que l'état soit sauvegardé
      _updateGlobal(updatedMsg);
    }
  }

  void _updateGlobal(Message msg) {
    if (Get.isRegistered<MessagesController>()) {
      Get.find<MessagesController>().updateLastMessage(conversation.id, msg);
    }
  }
  
  /// Convertit le statut de sync en statut de message
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
