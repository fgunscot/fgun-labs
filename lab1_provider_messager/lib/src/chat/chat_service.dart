class ChatModel {
  ChatModel({required this.name, required this.messages});
  String name;
  List<MessageModel> messages;
}

class MessageModel {
  MessageModel(this.message);
  String message;
}
