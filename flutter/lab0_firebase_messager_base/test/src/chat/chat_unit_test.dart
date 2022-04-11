import 'package:flutter_test/flutter_test.dart';
import 'package:lab0_firebase_messager_base/src/chat/chat_controller.dart';
import 'package:lab0_firebase_messager_base/src/chat/chat_service.dart';

void main() {
  group('get data from model - -', () {
    final list = [
      MessageModel('this is the first message'),
      MessageModel('this is the Secound'),
      MessageModel('Third message'),
      MessageModel('fourth')
    ];
    final fullModel = ChatModel(name: 'john', messages: list);
    final emptyModel = ChatModel(name: 'john', messages: []);

    test('-> get message from list of full messages', () {
      final controller = ChatController(fullModel);
      expect(controller.messages[1].message, 'this is the Secound');
      expect(controller.messages[3].message, 'fourth');
    });

    test('-> get full messages list from model', () {
      final controller = ChatController(fullModel);
      expect(controller.messages.length, 4);
    });

    test('-> get full messages list from model', () {
      final controller = ChatController(fullModel);
      expect(controller.messages, isNotEmpty);
    });

    test('-> get empty message list from model', () {
      final controller = ChatController(emptyModel);
      expect(controller.messages, isEmpty);
    });

    test('-> get messages list type from model', () {
      final controller = ChatController(emptyModel);
      expect(controller.messages, isInstanceOf<List<MessageModel>>());
    });

    test('-> get name from model', () {
      final controller = ChatController(emptyModel);
      expect(controller.getName, 'john');
    });

    test('-> get name type from model', () {
      final controller = ChatController(emptyModel);
      expect(controller.getName, isInstanceOf<String>());
    });
  });
}
