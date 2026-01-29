// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_message.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageSyncStatusAdapter extends TypeAdapter<MessageSyncStatus> {
  @override
  final int typeId = 1;

  @override
  MessageSyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageSyncStatus.pending;
      case 1:
        return MessageSyncStatus.sending;
      case 2:
        return MessageSyncStatus.sent;
      case 3:
        return MessageSyncStatus.failed;
      case 4:
        return MessageSyncStatus.delivered;
      case 5:
        return MessageSyncStatus.viewed;
      default:
        return MessageSyncStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, MessageSyncStatus obj) {
    switch (obj) {
      case MessageSyncStatus.pending:
        writer.writeByte(0);
        break;
      case MessageSyncStatus.sending:
        writer.writeByte(1);
        break;
      case MessageSyncStatus.sent:
        writer.writeByte(2);
        break;
      case MessageSyncStatus.failed:
        writer.writeByte(3);
        break;
      case MessageSyncStatus.delivered:
        writer.writeByte(4);
        break;
      case MessageSyncStatus.viewed:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSyncStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PendingMessageAdapter extends TypeAdapter<PendingMessage> {
  @override
  final int typeId = 2;

  @override
  PendingMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingMessage(
      localId: fields[0] as String,
      serverId: fields[1] as String?,
      conversationId: fields[2] as String,
      text: fields[3] as String,
      createdAt: fields[4] as DateTime,
      sentAt: fields[5] as DateTime?,
      syncStatus: fields[6] as MessageSyncStatus,
      retryCount: fields[7] as int,
      errorMessage: fields[8] as String?,
      senderId: fields[9] as String,
      attachmentPath: fields[10] as String?,
      attachmentType: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PendingMessage obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.serverId)
      ..writeByte(2)
      ..write(obj.conversationId)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.sentAt)
      ..writeByte(6)
      ..write(obj.syncStatus)
      ..writeByte(7)
      ..write(obj.retryCount)
      ..writeByte(8)
      ..write(obj.errorMessage)
      ..writeByte(9)
      ..write(obj.senderId)
      ..writeByte(10)
      ..write(obj.attachmentPath)
      ..writeByte(11)
      ..write(obj.attachmentType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
