import 'package:flutter_test/flutter_test.dart';
import 'package:{REPLACEME}/src/chat/chat_service.dart';

import 'package:{REPLACEME}/src/messager/messager_controller.dart';

void main() {
  group('Chat list functions tests - -', () {
    final chatList = [
      ChatModel(name: 'james', messages: []),
      ChatModel(name: 'steve', messages: []),
      ChatModel(name: 'john', messages: []),
    ];
    test('-> get chat returns correct name', () {
      final controller = MessagerController(chat: chatList);
      expect(controller.getChat(1).name, 'steve');
      expect(controller.getChat(2).name, 'john');
    });
    test('-> get chat returns object', () {
      final controller = MessagerController(chat: chatList);
      expect(controller.getChat(1), isInstanceOf<ChatModel>());
    });
    test('-> check elem is a ChatModel', () {
      final controller = MessagerController(chat: chatList);
      final chat = controller.chats.elementAt(1);
      expect(chat, isInstanceOf<ChatModel>());
    });
    test('-> check list is correct lenght', () {
      final controller = MessagerController(chat: chatList);
      expect(controller.chats.length, 3);
    });
    test('-> check list is populated', () {
      final controller = MessagerController(chat: chatList);
      expect(controller.chats, isNotEmpty);
    });
    test('-> init empty list', () {
      final controller = MessagerController(chat: []);
      expect(controller.chats, isEmpty);
    });
  });
}
