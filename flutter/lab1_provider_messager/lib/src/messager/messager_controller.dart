import 'package:flutter/foundation.dart';
import 'package:lab1_provider_messager/src/chat/chat_service.dart';
import 'package:lab1_provider_messager/src/messager/messager_service.dart';

class MessagerController with ChangeNotifier {
  MessagerController() {
    service = MessagerService(controller: this);
  }
  late MessagerService service;

  late UserModel _userModel;
  UserModel getUserModel() => _userModel;
  setUserModel(UserModel model) {
    _userModel = model;
    notifyListeners();
  }

  Map<String, UserModel> _users = {};
  Map<String, UserModel> getUsers() => _users;
  setUsers(Map<String, UserModel> models) {
    _users = models;
    notifyListeners();
  }

  startChat(String id) => service.startChat(id);

  Map<String, ChatModel> _chats = {};
  Map<String, ChatModel> getChats() => _chats;

  ChatModel getChat(String id) {
    return _chats[id]!;
  }
}
