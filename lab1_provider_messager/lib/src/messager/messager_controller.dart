import 'package:flutter/foundation.dart';
import 'package:lab1_provider_messager/src/chat/chat_service.dart';

class MessagerController with ChangeNotifier {
  MessagerController({List<ChatModel>? chat}) {
    chats = chat ?? [];
  }

  // this should be a map while passing around ids instead of indexs..
  late List<ChatModel> chats;

  ChatModel getChat(int index) {
    return chats[index];
  }
}
