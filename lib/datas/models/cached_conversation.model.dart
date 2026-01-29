import 'package:hive/hive.dart';

part 'cached_conversation.model.g.dart';

/// Modèle pour stocker les messages en cache local
@HiveType(typeId: 3)
class CachedMessage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final DateTime time;

  @HiveField(3)
  final bool isMe;

  @HiveField(4)
  final int statusIndex; // 0: pending, 1: failed, 2: sent, 3: viewed

  @HiveField(5)
  final String? localId; // Pour lier aux messages pending

  CachedMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    required this.statusIndex,
    this.localId,
  });

  CachedMessage copyWith({
    String? id,
    String? text,
    DateTime? time,
    bool? isMe,
    int? statusIndex,
    String? localId,
  }) {
    return CachedMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      time: time ?? this.time,
      isMe: isMe ?? this.isMe,
      statusIndex: statusIndex ?? this.statusIndex,
      localId: localId ?? this.localId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'time': time.toIso8601String(),
      'isMe': isMe,
      'statusIndex': statusIndex,
      'localId': localId,
    };
  }

  factory CachedMessage.fromJson(Map<String, dynamic> json) {
    return CachedMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      time: DateTime.parse(json['time'] as String),
      isMe: json['isMe'] as bool,
      statusIndex: json['statusIndex'] as int,
      localId: json['localId'] as String?,
    );
  }
}

/// Modèle pour stocker les conversations en cache local
@HiveType(typeId: 4)
class CachedConversation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String otherUserName;

  @HiveField(2)
  final String otherUserAvatar;

  @HiveField(3)
  String lastMessage;

  @HiveField(4)
  String lastMessageTime;

  @HiveField(5)
  int unreadCount;

  @HiveField(6)
  List<CachedMessage> messages;

  @HiveField(7)
  final DateTime lastUpdated;

  @HiveField(8)
  final String? otherUserId;

  CachedConversation({
    required this.id,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.messages,
    required this.lastUpdated,
    this.otherUserId,
  });

  CachedConversation copyWith({
    String? id,
    String? otherUserName,
    String? otherUserAvatar,
    String? lastMessage,
    String? lastMessageTime,
    int? unreadCount,
    List<CachedMessage>? messages,
    DateTime? lastUpdated,
    String? otherUserId,
  }) {
    return CachedConversation(
      id: id ?? this.id,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserAvatar: otherUserAvatar ?? this.otherUserAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? this.messages,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      otherUserId: otherUserId ?? this.otherUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otherUserName': otherUserName,
      'otherUserAvatar': otherUserAvatar,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unreadCount': unreadCount,
      'messages': messages.map((m) => m.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'otherUserId': otherUserId,
    };
  }

  factory CachedConversation.fromJson(Map<String, dynamic> json) {
    return CachedConversation(
      id: json['id'] as String,
      otherUserName: json['otherUserName'] as String,
      otherUserAvatar: json['otherUserAvatar'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: json['lastMessageTime'] as String,
      unreadCount: json['unreadCount'] as int? ?? 0,
      messages: (json['messages'] as List<dynamic>)
          .map((m) => CachedMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      otherUserId: json['otherUserId'] as String?,
    );
  }
}
