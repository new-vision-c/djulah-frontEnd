import 'package:hive/hive.dart';

part 'pending_message.model.g.dart';

/// Statut de synchronisation du message
@HiveType(typeId: 1)
enum MessageSyncStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  sending,

  @HiveField(2)
  sent,

  @HiveField(3)
  failed,

  @HiveField(4)
  delivered,

  @HiveField(5)
  viewed,
}

/// Modèle pour stocker les messages en attente d'envoi
/// Permet la persistance et la synchronisation offline-first
@HiveType(typeId: 2)
class PendingMessage extends HiveObject {
  @HiveField(0)
  final String localId;

  @HiveField(1)
  String? serverId;

  @HiveField(2)
  final String conversationId;

  @HiveField(3)
  final String text;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  DateTime? sentAt;

  @HiveField(6)
  MessageSyncStatus syncStatus;

  @HiveField(7)
  int retryCount;

  @HiveField(8)
  String? errorMessage;

  @HiveField(9)
  final String senderId;

  @HiveField(10)
  final String? attachmentPath;

  @HiveField(11)
  final String? attachmentType;

  PendingMessage({
    required this.localId,
    this.serverId,
    required this.conversationId,
    required this.text,
    required this.createdAt,
    this.sentAt,
    this.syncStatus = MessageSyncStatus.pending,
    this.retryCount = 0,
    this.errorMessage,
    required this.senderId,
    this.attachmentPath,
    this.attachmentType,
  });

  /// Vérifie si le message peut être réessayé
  bool get canRetry => retryCount < 3 && syncStatus == MessageSyncStatus.failed;

  /// Vérifie si le message est en attente
  bool get isPending =>
      syncStatus == MessageSyncStatus.pending ||
      syncStatus == MessageSyncStatus.sending;

  /// Vérifie si le message a échoué
  bool get hasFailed => syncStatus == MessageSyncStatus.failed;

  /// Vérifie si le message a été envoyé avec succès
  bool get isSent =>
      syncStatus == MessageSyncStatus.sent ||
      syncStatus == MessageSyncStatus.delivered ||
      syncStatus == MessageSyncStatus.viewed;

  /// Crée une copie avec des valeurs mises à jour
  PendingMessage copyWith({
    String? localId,
    String? serverId,
    String? conversationId,
    String? text,
    DateTime? createdAt,
    DateTime? sentAt,
    MessageSyncStatus? syncStatus,
    int? retryCount,
    String? errorMessage,
    String? senderId,
    String? attachmentPath,
    String? attachmentType,
  }) {
    return PendingMessage(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
      syncStatus: syncStatus ?? this.syncStatus,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      senderId: senderId ?? this.senderId,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      attachmentType: attachmentType ?? this.attachmentType,
    );
  }

  /// Convertit en Map pour JSON/API
  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'serverId': serverId,
      'conversationId': conversationId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'sentAt': sentAt?.toIso8601String(),
      'syncStatus': syncStatus.index,
      'retryCount': retryCount,
      'errorMessage': errorMessage,
      'senderId': senderId,
      'attachmentPath': attachmentPath,
      'attachmentType': attachmentType,
    };
  }

  /// Pour l'envoi à l'API (données minimales)
  Map<String, dynamic> toApiPayload() {
    return {
      'local_id': localId,
      'conversation_id': conversationId,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      if (attachmentPath != null) 'attachment_path': attachmentPath,
      if (attachmentType != null) 'attachment_type': attachmentType,
    };
  }

  /// Crée à partir d'un Map JSON
  factory PendingMessage.fromJson(Map<String, dynamic> json) {
    return PendingMessage(
      localId: json['localId'] as String,
      serverId: json['serverId'] as String?,
      conversationId: json['conversationId'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : null,
      syncStatus: MessageSyncStatus.values[json['syncStatus'] as int],
      retryCount: json['retryCount'] as int? ?? 0,
      errorMessage: json['errorMessage'] as String?,
      senderId: json['senderId'] as String,
      attachmentPath: json['attachmentPath'] as String?,
      attachmentType: json['attachmentType'] as String?,
    );
  }

  @override
  String toString() {
    return 'PendingMessage(localId: $localId, conversationId: $conversationId, '
        'status: $syncStatus, retries: $retryCount)';
  }
}
