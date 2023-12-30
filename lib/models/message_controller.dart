import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sentTime;
  final MessageType messageType;
  final bool isSeen;

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sentTime,
    required this.messageType,
    required this.isSeen,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        receiverId: json['receiverId'],
        senderId: json['senderId'],
        sentTime: json['sentTime'].toDate(),
        content: json['content'],
        messageType: MessageType.fromJson(json['messageType']),
        isSeen: json['isSeen'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "content": content,
        "sentTime": sentTime,
        "messageType": messageType.toJson(),
        "isSeen": isSeen,
      };

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Message(
      id: data?['id'],
      receiverId: data?['receiverId'],
      senderId: data?['senderId'],
      sentTime: data?['sentTime'].toDate(),
      content: data?['content'],
      messageType: MessageType.fromJson(data?['messageType']),
      isSeen: data?['isSeen'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "senderId": senderId,
      "receiverId": receiverId,
      "content": content,
      "sentTime": sentTime,
      "messageType": messageType.toJson(),
      "isSeen": isSeen,
    };
  }
}

enum MessageType {
  text,
  image;

  String toJson() => name;
  factory MessageType.fromJson(String json) => values.byName(json);
}
