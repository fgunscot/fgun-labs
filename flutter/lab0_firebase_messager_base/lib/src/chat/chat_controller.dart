import 'dart:math';

import 'package:lab0_firebase_messager_base/src/chat/chat_service.dart';

class ChatController {
  ChatController(this.model);
  ChatModel model;

  get getName => model.name;

  get isMe => Random().nextBool();

  get messages => model.messages;

  sendMessage(String message) => print('sending message: $message');
}
