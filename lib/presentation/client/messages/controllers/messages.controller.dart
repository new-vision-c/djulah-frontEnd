import 'package:djulah/datas/local_storage/conversations_storage_service.dart';
import 'package:djulah/datas/local_storage/pending_messages_storage_service.dart';
import 'package:djulah/datas/local_storage/sync_service.dart';
import 'package:djulah/domain/entities/conversation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessagesController extends GetxController {
  final conversations = <Conversation>[].obs;
  final isLoading = true.obs;
  
  /// Services de stockage
  ConversationsStorageService get _conversationsService => 
      Get.find<ConversationsStorageService>();
  PendingMessagesStorageService get _pendingService => 
      Get.find<PendingMessagesStorageService>();
  SyncService get _syncService => Get.find<SyncService>();
  
  /// Nombre de messages en attente d'envoi
  int get pendingMessagesCount => _pendingService.pendingCount;
  
  /// Indicateur de connexion
  bool get isOnline => _syncService.isOnline.value;

  @override
  void onInit() {
    super.onInit();
    _loadConversations();
    
    // Écouter les changements de connexion pour afficher un indicateur
    ever(_syncService.isOnline, (_) => update());
  }

  Future<void> _loadConversations() async {
    isLoading.value = true;
    
    // 1. D'abord charger depuis le cache local
    final cachedConversations = _conversationsService.getAllConversations();
    if (cachedConversations.isNotEmpty) {
      conversations.assignAll(cachedConversations);
      isLoading.value = false;
    }
    
    // 2. Ensuite charger depuis le backend (si en ligne)
    if (_syncService.isOnline.value) {
      try {
        await _loadFromBackend();
      } catch (e) {
        // Si erreur et pas de cache, afficher le mockup
        if (conversations.isEmpty) {
          _loadMockData();
        }
      }
    } else if (conversations.isEmpty) {
      // Si offline et pas de cache, charger le mockup
      _loadMockData();
    }
    
    isLoading.value = false;
  }
  
  /// Charge les conversations depuis le backend
  Future<void> _loadFromBackend() async {
    // TODO: Remplacer par l'appel API réel
    // Simuler un délai réseau
    await Future.delayed(const Duration(seconds: 1));
    
    // Pour l'instant, utiliser les données mockup
    _loadMockData();
    
    // Sauvegarder dans le cache
    await _conversationsService.cacheConversations(conversations);
  }
  
  /// Charge les données mockup
  void _loadMockData() {
    conversations.assignAll([
      Conversation(
        id: '1',
        otherUserName: 'Mia Mimie',
        otherUserAvatar: 'assets/images/client/avatar/avatar1.png',
        lastMessage: "j'espere que vous allez bien",
        lastMessageTime: '07:45 AM',
        unreadCount: 1,
        messages: [
          Message(id: 'm1', text: 'Bonjour', time: DateTime.now(), isMe: true),
          Message(id: 'm2', text: "j'espere que vous allez bien", time: DateTime.now(), isMe: false),
        ],
      ),
      Conversation(
        id: '2',
        otherUserName: 'Jean Dupont',
        otherUserAvatar: 'assets/images/client/avatar/avatar2.png',
        lastMessage: 'Votre commande est prête',
        lastMessageTime: 'Hier',
        unreadCount: 0,
        messages: [
          Message(id: 'm3', text: 'Votre commande est prête', time: DateTime.now(), isMe: false),
        ],
      ),
      Conversation(
        id: '3',
        otherUserName: 'Sarah Cohen',
        otherUserAvatar: 'assets/images/client/avatar/Avatar3.png',
        lastMessage: 'On se voit demain pour la visite ?',
        lastMessageTime: '18:30',
        unreadCount: 2,
        messages: [
          Message(id: 'm4', text: 'On se voit demain pour la visite ?', time: DateTime.now(), isMe: false),
        ],
      ),
      Conversation(
        id: '4',
        otherUserName: 'Paul Martin',
        otherUserAvatar: 'assets/images/client/avatar/Avatar4.png',
        lastMessage: 'Merci pour votre retour rapide.',
        lastMessageTime: 'Lun.',
        unreadCount: 0,
        messages: [
          Message(id: 'm5', text: 'Merci pour votre retour rapide.', time: DateTime.now(), isMe: false),
        ],
      ),
      Conversation(
        id: '5',
        otherUserName: 'Julie Morel',
        otherUserAvatar: 'assets/images/client/avatar/Avatar5.png',
        lastMessage: "C'est parfait, merci beaucoup !",
        lastMessageTime: '09:12',
        unreadCount: 1,
        messages: [
          Message(id: 'm6', text: "C'est parfait, merci beaucoup !", time: DateTime.now(), isMe: false),
        ],
      ),
      Conversation(
        id: '6',
        otherUserName: 'Ahmed Sylla',
        otherUserAvatar: 'assets/images/client/avatar/Avatar6.png',
        lastMessage: "J'ai bien reçu les documents.",
        lastMessageTime: '12:05',
        unreadCount: 0,
        messages: [
          Message(id: 'm7', text: "J'ai bien reçu les documents.", time: DateTime.now(), isMe: false),
        ],
      ),
    ]);
  }
  
  /// Rafraîchit les conversations
  Future<void> refresh() async {
    await _loadConversations();
  }

  void markAsRead(String conversationId) {
    int index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final conv = conversations[index];
      conversations[index] = Conversation(
        id: conv.id,
        otherUserName: conv.otherUserName,
        otherUserAvatar: conv.otherUserAvatar,
        lastMessage: conv.lastMessage,
        lastMessageTime: conv.lastMessageTime,
        unreadCount: 0,
        messages: conv.messages,
      );
      
      // Mettre à jour le cache
      _conversationsService.markAsRead(conversationId);
    }
  }

  void updateLastMessage(String conversationId, Message message) {
    int index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final conv = conversations[index];
      
      // On gère proprement la liste des messages pour éviter les doublons
      List<Message> updatedMessages = List.from(conv.messages);
      int msgIndex = updatedMessages.indexWhere((m) => m.id == message.id);
      
      if (msgIndex != -1) {
        // Mise à jour du statut (Pending -> Sent -> Viewed)
        updatedMessages[msgIndex] = message;
      } else {
        // Nouveau message
        updatedMessages.add(message);
      }

      conversations[index] = Conversation(
        id: conv.id,
        otherUserName: conv.otherUserName,
        otherUserAvatar: conv.otherUserAvatar,
        lastMessage: message.text,
        lastMessageTime: DateFormat('hh:mm a').format(message.time),
        unreadCount: 0,
        messages: updatedMessages,
      );
      
      // Remonter la conversation en haut
      final updatedConv = conversations.removeAt(index);
      conversations.insert(0, updatedConv);
      
      // Sauvegarder dans le cache
      _conversationsService.cacheConversation(updatedConv);
    }
  }
  
  /// Récupère le nombre de messages en attente pour une conversation
  int getPendingCountForConversation(String conversationId) {
    return _pendingService.getPendingForConversation(conversationId).length;
  }
}
