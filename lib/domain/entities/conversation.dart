enum MessageStatus { pending, failed, sent, viewed }

class Conversation {
  final String id;
  final String otherUserName;
  final String otherUserAvatar;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.messages,
  });
}

class Message {
  final String id;
  final String text;
  final DateTime time;
  final bool isMe;
  final MessageStatus status;

  Message({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    this.status = MessageStatus.sent,
  });
}
