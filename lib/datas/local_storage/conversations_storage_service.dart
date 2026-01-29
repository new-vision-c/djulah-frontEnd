import 'dart:async';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/conversation.dart';
import '../models/cached_conversation.model.dart';
import 'local_storage_initializer.dart';

/// Service de gestion du cache des conversations
/// Permet la persistence et le mode offline
class ConversationsStorageService extends GetxService {
  late Box<CachedConversation> _conversationsBox;

  /// Liste observable des conversations en cache
  final RxList<CachedConversation> cachedConversations = <CachedConversation>[].obs;

  @override
  void onInit() {
    super.onInit();
    _conversationsBox = Hive.box<CachedConversation>(
      LocalStorageInitializer.conversationsBoxName,
    );
    _loadConversations();
  }

  /// Charge les conversations depuis le cache
  void _loadConversations() {
    final all = _conversationsBox.values.toList();
    // Trier par dernière mise à jour
    all.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    cachedConversations.assignAll(all);
  }

  /// Sauvegarde une conversation dans le cache
  Future<void> cacheConversation(Conversation conversation) async {
    final cached = CachedConversation(
      id: conversation.id,
      otherUserName: conversation.otherUserName,
      otherUserAvatar: conversation.otherUserAvatar,
      lastMessage: conversation.lastMessage,
      lastMessageTime: conversation.lastMessageTime,
      unreadCount: conversation.unreadCount,
      messages: conversation.messages.map((m) => CachedMessage(
        id: m.id,
        text: m.text,
        time: m.time,
        isMe: m.isMe,
        statusIndex: m.status.index,
      )).toList(),
      lastUpdated: DateTime.now(),
    );

    await _conversationsBox.put(conversation.id, cached);
    _loadConversations();
  }

  /// Sauvegarde plusieurs conversations
  Future<void> cacheConversations(List<Conversation> conversations) async {
    for (final conv in conversations) {
      await cacheConversation(conv);
    }
  }

  /// Récupère une conversation du cache
  CachedConversation? getCachedConversation(String conversationId) {
    return _conversationsBox.get(conversationId);
  }

  /// Convertit une conversation en cache vers l'entité domain
  Conversation? toConversation(String conversationId) {
    final cached = getCachedConversation(conversationId);
    if (cached == null) return null;

    return Conversation(
      id: cached.id,
      otherUserName: cached.otherUserName,
      otherUserAvatar: cached.otherUserAvatar,
      lastMessage: cached.lastMessage,
      lastMessageTime: cached.lastMessageTime,
      unreadCount: cached.unreadCount,
      messages: cached.messages.map((m) => Message(
        id: m.id,
        text: m.text,
        time: m.time,
        isMe: m.isMe,
        status: MessageStatus.values[m.statusIndex],
      )).toList(),
    );
  }

  /// Récupère toutes les conversations du cache comme entités domain
  List<Conversation> getAllConversations() {
    return cachedConversations.map((cached) => Conversation(
      id: cached.id,
      otherUserName: cached.otherUserName,
      otherUserAvatar: cached.otherUserAvatar,
      lastMessage: cached.lastMessage,
      lastMessageTime: cached.lastMessageTime,
      unreadCount: cached.unreadCount,
      messages: cached.messages.map((m) => Message(
        id: m.id,
        text: m.text,
        time: m.time,
        isMe: m.isMe,
        status: MessageStatus.values[m.statusIndex],
      )).toList(),
    )).toList();
  }

  /// Ajoute un message à une conversation en cache
  Future<void> addMessageToConversation({
    required String conversationId,
    required Message message,
    String? localId,
  }) async {
    final cached = _conversationsBox.get(conversationId);
    if (cached == null) return;

    final newCachedMessage = CachedMessage(
      id: message.id,
      text: message.text,
      time: message.time,
      isMe: message.isMe,
      statusIndex: message.status.index,
      localId: localId,
    );

    // Vérifier si le message existe déjà
    final existingIndex = cached.messages.indexWhere((m) => 
      m.id == message.id || (localId != null && m.localId == localId)
    );

    if (existingIndex != -1) {
      // Mettre à jour le message existant
      cached.messages[existingIndex] = newCachedMessage;
    } else {
      // Ajouter le nouveau message
      cached.messages.add(newCachedMessage);
    }

    // Mettre à jour le dernier message
    cached.lastMessage = message.text;
    cached.lastMessageTime = DateFormat('hh:mm a').format(message.time);

    await _conversationsBox.put(conversationId, cached.copyWith(
      messages: cached.messages,
      lastMessage: cached.lastMessage,
      lastMessageTime: cached.lastMessageTime,
      lastUpdated: DateTime.now(),
    ));

    _loadConversations();
  }

  /// Met à jour le statut d'un message dans le cache
  Future<void> updateMessageStatus({
    required String conversationId,
    required String messageId,
    required MessageStatus status,
    String? localId,
  }) async {
    final cached = _conversationsBox.get(conversationId);
    if (cached == null) return;

    final messageIndex = cached.messages.indexWhere((m) => 
      m.id == messageId || (localId != null && m.localId == localId)
    );

    if (messageIndex == -1) return;

    final updatedMessage = cached.messages[messageIndex].copyWith(
      statusIndex: status.index,
    );

    cached.messages[messageIndex] = updatedMessage;

    await _conversationsBox.put(conversationId, cached.copyWith(
      messages: cached.messages,
      lastUpdated: DateTime.now(),
    ));

    _loadConversations();
  }

  /// Marque une conversation comme lue
  Future<void> markAsRead(String conversationId) async {
    final cached = _conversationsBox.get(conversationId);
    if (cached == null) return;

    await _conversationsBox.put(conversationId, cached.copyWith(
      unreadCount: 0,
      lastUpdated: DateTime.now(),
    ));

    _loadConversations();
  }

  /// Supprime une conversation du cache
  Future<void> removeConversation(String conversationId) async {
    await _conversationsBox.delete(conversationId);
    _loadConversations();
  }

  /// Efface tout le cache
  Future<void> clearAll() async {
    await _conversationsBox.clear();
    cachedConversations.clear();
  }

  /// Vérifie si le cache est vide
  bool get isEmpty => cachedConversations.isEmpty;

  /// Nombre de conversations en cache
  int get count => cachedConversations.length;
}
