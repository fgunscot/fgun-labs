import 'package:flutter/material.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_view.dart';
import 'package:lab1_provider_messager/src/chat/chat_service.dart';
import 'package:lab1_provider_messager/src/chat/chat_view.dart';
import 'package:lab1_provider_messager/src/widgets/drawer/drawer_view.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required this.chatName,
    required this.index,
  }) : super(key: key);
  final String chatName;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('chatTileIndex$index'),
      leading: const CircleAvatar(backgroundColor: Colors.cyan),
      title: Text(chatName),
      onTap: () => Navigator.restorablePushNamed(
        context,
        ChatView.routeName,
        arguments: index,
      ),
    );
  }
}

class MessagerView extends StatelessWidget {
  static const routeName = '/messager';
  const MessagerView({Key? key, required this.chats}) : super(key: key);

  final List<ChatModel> chats;

  static const navToAuthIconButtonKey = Key('navToAuthIconButton');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messager'),
        actions: [
          IconButton(
            key: MessagerView.navToAuthIconButtonKey,
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              Navigator.restorablePushNamed(
                  context, AuthenticationView.routeName);
            },
          ),
        ],
      ),
      drawer: const DrawerView(),
      body: chats.isNotEmpty
          ? ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) =>
                  ChatTile(chatName: chats[index].name, index: index),
            )
          : const Center(child: Text('You dont have anyone to chat with.')),
    );
  }
}
