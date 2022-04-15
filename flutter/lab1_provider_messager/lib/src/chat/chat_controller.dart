import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:lab1_provider_messager/src/chat/chat_service.dart';
import 'package:lab1_provider_messager/src/messager/messager_service.dart';

class ChatController with ChangeNotifier {
  ChatController(this.model);

  late ChatModel model;

  get getName => model.name;

  get isMe => Random().nextBool();

  get messages => model;

  sendMessage(String message) {
    // model.messages.add(MessageModel(message));
    notifyListeners();
  }
}
