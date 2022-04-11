import 'package:{REPLACEME}/src/chat/chat_service.dart';

class MessagerController {
  MessagerController({List<ChatModel>? chat}) {
    chats = chat ?? [];
  }

  // this should be a map while passing around ids instead of indexs..
  late List<ChatModel> chats;

  ChatModel getChat(int index) {
    return chats[index];
  }
}
