class ChatMessageModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? photoUrl;
  String? messageType;
  bool? isMe;
  bool? isMessageRead;
  String? message;
  int? createdAt;
  String? messageId;
  String? repliedMessage;
  String? repliedTo;
  String? repliedMessageType;

  ChatMessageModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.createdAt,
    this.message,
    this.isMessageRead,
    this.photoUrl,
    this.messageType,
    this.messageId,
    this.repliedMessage,
    this.repliedTo,
    this.repliedMessageType,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      isMessageRead: json['isMessageRead'],
      photoUrl: json['photoUrl'],
      messageType: json['messageType'],
      createdAt: json['createdAt'],
      messageId: json['id'] ?? '',
      repliedMessage: json['repliedMessage'] ?? '',
      repliedTo: json['repliedTo'] ?? '',
      repliedMessageType: (json['repliedMessageType']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['message'] = this.message;
    data['senderId'] = this.senderId;
    data['isMessageRead'] = this.isMessageRead;
    data['receiverId'] = this.receiverId;
    data['photoUrl'] = this.photoUrl;
    data['messageType'] = this.messageType;
    data['messageId'] = this.id;
    data['repliedMessage'] = this.repliedMessage;
    data['repliedTo'] = this.repliedTo;
    data['repliedMessageType'] = this.repliedMessageType;

    return data;
  }
}
