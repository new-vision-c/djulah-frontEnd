// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_conversation.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedMessageAdapter extends TypeAdapter<CachedMessage> {
  @override
  final int typeId = 3;

  @override
  CachedMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedMessage(
      id: fields[0] as String,
      text: fields[1] as String,
      time: fields[2] as DateTime,
      isMe: fields[3] as bool,
      statusIndex: fields[4] as int,
      localId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CachedMessage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.isMe)
      ..writeByte(4)
      ..write(obj.statusIndex)
      ..writeByte(5)
      ..write(obj.localId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CachedConversationAdapter extends TypeAdapter<CachedConversation> {
  @override
  final int typeId = 4;

  @override
  CachedConversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedConversation(
      id: fields[0] as String,
      otherUserName: fields[1] as String,
      otherUserAvatar: fields[2] as String,
      lastMessage: fields[3] as String,
      lastMessageTime: fields[4] as String,
      unreadCount: fields[5] as int,
      messages: (fields[6] as List).cast<CachedMessage>(),
      lastUpdated: fields[7] as DateTime,
      otherUserId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CachedConversation obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.otherUserName)
      ..writeByte(2)
      ..write(obj.otherUserAvatar)
      ..writeByte(3)
      ..write(obj.lastMessage)
      ..writeByte(4)
      ..write(obj.lastMessageTime)
      ..writeByte(5)
      ..write(obj.unreadCount)
      ..writeByte(6)
      ..write(obj.messages)
      ..writeByte(7)
      ..write(obj.lastUpdated)
      ..writeByte(8)
      ..write(obj.otherUserId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
