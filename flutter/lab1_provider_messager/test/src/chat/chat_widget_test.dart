import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab1_provider_messager/src/chat/chat_service.dart';
import 'package:lab1_provider_messager/src/chat/chat_view.dart';
import 'package:lab1_provider_messager/src/chat/chat_controller.dart';
import 'package:provider/provider.dart';

List<MessageModel> messages = [
  MessageModel('this is the first message'),
  MessageModel('this is the Secound'),
  MessageModel('Third message'),
  MessageModel('fourth')
];

void main() {
  group('For ChatView(), Check right keys are present - -', () {
    ChatModel fullModel = ChatModel(name: 'steve', messages: messages);
    ChatModel emptyModel = ChatModel(name: 'steve', messages: []);

    Future<void> _buildChatView(WidgetTester tester, ChatModel model) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ChatController>(
          create: (context) => ChatController(model),
          child: const ChatView(),
        ),
      );
    }

    // testWidgets('-> check input feilds have the right name',
    //     (WidgetTester tester) async {
    //   await _buildChatView(tester, fullModel);
    //   expect(find.byKey(const Key('chatViewTextInputsteve')), findsOneWidget);
    //   expect(find.byKey(const Key('chatViewButtonInputsteve')), findsOneWidget);
    // });

    testWidgets('-> send message', (WidgetTester tester) async {});

    // testWidgets('-> on sent message textfield clears',
    //     (WidgetTester tester) async {
    //   await _buildChatView(tester);
    //   await tester.enterText(_getTextFieldKeyByName('steve'), 'test message');
    //   await tester.pumpAndSettle();

    //   expect(_getTextFieldKeyByName('steve').evaluate(), isNotEmpty);
    //   await tester.tap(_getButtonKeyByName('steve'));
    //   await tester.pumpAndSettle();

    //   print(_getTextFieldKeyByName('steve').);
    //   // expect(_getTextFieldKeyByName('steve').evaluate(), isEmpty);
    // });

    // testWidgets('-> list is showing 4 messages', (WidgetTester tester) async {
    //   await _buildChatView(tester, fullModel);
    // });

    // testWidgets('-> list is showing 0 messages', (WidgetTester tester) async {
    //   await _buildChatView(tester, emptyModel);
    // });
  });
}
