import 'dart:async';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/pending_message.model.dart';
import 'local_storage_initializer.dart';

/// Service de gestion des messages en attente
/// Utilise Hive pour la persistence avec file d'attente
class PendingMessagesStorageService extends GetxService {
  late Box<PendingMessage> _pendingBox;

  /// Liste observable des messages en attente
  final RxList<PendingMessage> pendingMessages = <PendingMessage>[].obs;

  /// Messages en cours d'envoi
  final RxList<PendingMessage> sendingMessages = <PendingMessage>[].obs;

  /// Messages échoués
  final RxList<PendingMessage> failedMessages = <PendingMessage>[].obs;

  /// Stream controller pour notifier les changements
  final _pendingChanges = StreamController<List<PendingMessage>>.broadcast();
  Stream<List<PendingMessage>> get pendingChanges => _pendingChanges.stream;

  @override
  void onInit() {
    super.onInit();
    _pendingBox = Hive.box<PendingMessage>(
      LocalStorageInitializer.pendingMessagesBoxName,
    );
    _loadMessages();
  }

  @override
  void onClose() {
    _pendingChanges.close();
    super.onClose();
  }

  /// Charge les messages depuis le stockage local
  void _loadMessages() {
    final allMessages = _pendingBox.values.toList();
    
    // Trier par date de création
    allMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    
    pendingMessages.assignAll(
      allMessages.where((m) => m.syncStatus == MessageSyncStatus.pending),
    );
    sendingMessages.assignAll(
      allMessages.where((m) => m.syncStatus == MessageSyncStatus.sending),
    );
    failedMessages.assignAll(
      allMessages.where((m) => m.syncStatus == MessageSyncStatus.failed),
    );
    
    _pendingChanges.add(pendingMessages);
  }

  /// Ajoute un message à la file d'attente
  Future<PendingMessage> enqueue({
    required String conversationId,
    required String text,
    required String senderId,
    String? attachmentPath,
    String? attachmentType,
  }) async {
    final localId = _generateLocalId();
    
    final message = PendingMessage(
      localId: localId,
      conversationId: conversationId,
      text: text,
      createdAt: DateTime.now(),
      senderId: senderId,
      syncStatus: MessageSyncStatus.pending,
      attachmentPath: attachmentPath,
      attachmentType: attachmentType,
    );

    await _pendingBox.put(localId, message);
    pendingMessages.add(message);
    
    _pendingChanges.add(pendingMessages);
    
    return message;
  }

  /// Récupère le prochain message à envoyer
  PendingMessage? getNextPending() {
    if (pendingMessages.isEmpty) return null;
    return pendingMessages.first;
  }

  /// Récupère tous les messages en attente pour une conversation
  List<PendingMessage> getPendingForConversation(String conversationId) {
    return pendingMessages
        .where((m) => m.conversationId == conversationId)
        .toList();
  }

  /// Récupère tous les messages (tous statuts) pour une conversation
  List<PendingMessage> getAllForConversation(String conversationId) {
    return _pendingBox.values
        .where((m) => m.conversationId == conversationId)
        .toList();
  }

  /// Marque un message comme "en cours d'envoi"
  Future<void> markAsSending(String localId) async {
    await _updateStatus(localId, MessageSyncStatus.sending);
  }

  /// Marque un message comme "envoyé" avec succès
  Future<void> markAsSent(String localId, {String? serverId}) async {
    final message = _pendingBox.get(localId);
    if (message == null) return;

    final updated = PendingMessage(
      localId: message.localId,
      serverId: serverId,
      conversationId: message.conversationId,
      text: message.text,
      createdAt: message.createdAt,
      sentAt: DateTime.now(),
      syncStatus: MessageSyncStatus.sent,
      retryCount: message.retryCount,
      senderId: message.senderId,
      attachmentPath: message.attachmentPath,
      attachmentType: message.attachmentType,
    );

    await _pendingBox.put(localId, updated);
    _loadMessages();
  }

  /// Marque un message comme "vu"
  Future<void> markAsViewed(String localId) async {
    await _updateStatus(localId, MessageSyncStatus.viewed);
  }

  /// Marque un message comme "échoué"
  Future<void> markAsFailed(String localId, {String? errorMessage}) async {
    final message = _pendingBox.get(localId);
    if (message == null) return;

    final updated = PendingMessage(
      localId: message.localId,
      serverId: message.serverId,
      conversationId: message.conversationId,
      text: message.text,
      createdAt: message.createdAt,
      sentAt: message.sentAt,
      syncStatus: MessageSyncStatus.failed,
      retryCount: message.retryCount + 1,
      errorMessage: errorMessage,
      senderId: message.senderId,
      attachmentPath: message.attachmentPath,
      attachmentType: message.attachmentType,
    );

    await _pendingBox.put(localId, updated);
    _loadMessages();
  }

  /// Réessaie un message échoué
  Future<bool> retry(String localId) async {
    final message = _pendingBox.get(localId);
    if (message == null || !message.canRetry) return false;

    await _updateStatus(localId, MessageSyncStatus.pending);
    return true;
  }

  /// Réessaie tous les messages échoués
  Future<int> retryAllFailed() async {
    int count = 0;
    for (final message in failedMessages.toList()) {
      if (message.canRetry) {
        await retry(message.localId);
        count++;
      }
    }
    return count;
  }

  /// Supprime un message de la file
  Future<void> remove(String localId) async {
    await _pendingBox.delete(localId);
    _loadMessages();
  }

  /// Supprime les messages envoyés avec succès (nettoyage)
  Future<int> cleanupSent({Duration? olderThan}) async {
    final cutoff = olderThan != null
        ? DateTime.now().subtract(olderThan)
        : DateTime.now().subtract(const Duration(days: 7));

    int count = 0;
    final toDelete = <String>[];

    for (final message in _pendingBox.values) {
      if (message.isSent && 
          message.sentAt != null && 
          message.sentAt!.isBefore(cutoff)) {
        toDelete.add(message.localId);
        count++;
      }
    }

    for (final id in toDelete) {
      await _pendingBox.delete(id);
    }

    _loadMessages();
    return count;
  }

  /// Met à jour le statut d'un message
  Future<void> _updateStatus(String localId, MessageSyncStatus status) async {
    final message = _pendingBox.get(localId);
    if (message == null) return;

    final updated = PendingMessage(
      localId: message.localId,
      serverId: message.serverId,
      conversationId: message.conversationId,
      text: message.text,
      createdAt: message.createdAt,
      sentAt: message.sentAt,
      syncStatus: status,
      retryCount: message.retryCount,
      errorMessage: message.errorMessage,
      senderId: message.senderId,
      attachmentPath: message.attachmentPath,
      attachmentType: message.attachmentType,
    );

    await _pendingBox.put(localId, updated);
    _loadMessages();
  }

  /// Génère un ID local unique
  String _generateLocalId() {
    return 'local_${DateTime.now().millisecondsSinceEpoch}_${_pendingBox.length}';
  }

  /// Efface tous les messages
  Future<void> clearAll() async {
    await _pendingBox.clear();
    pendingMessages.clear();
    sendingMessages.clear();
    failedMessages.clear();
    _pendingChanges.add([]);
  }

  /// Nombre total de messages en attente
  int get pendingCount => pendingMessages.length;

  /// Nombre de messages échoués
  int get failedCount => failedMessages.length;

  /// Vérifie s'il y a des messages à envoyer
  bool get hasPendingMessages => pendingMessages.isNotEmpty;
}
