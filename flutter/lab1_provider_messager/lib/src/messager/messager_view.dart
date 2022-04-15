import 'package:flutter/material.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_view.dart';
import 'package:lab1_provider_messager/src/chat/chat_view.dart';
import 'package:lab1_provider_messager/src/messager/messager_controller.dart';
import 'package:provider/provider.dart';

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
  const MessagerView({Key? key}) : super(key: key);

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
      body: Column(
        children: [
          Consumer<MessagerController>(builder: (_, controller, __) {
            var users = controller.getUsers();
            return SizedBox(
              height: 70,
              child: users.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var id = users.keys.toList()[index];
                        return Row(
                          children: [
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                controller.startChat(id);
                                // Navigator.restorablePushNamed(
                                //   context,
                                //   ChatView.routeName,
                                //   arguments: id,
                                // );
                              },
                              child: const CircleAvatar(radius: 26),
                            ),
                          ],
                        );
                      })
                  : const Center(child: Text('you have no friends')),
            );
          }),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)),
                ),
                child: Consumer<MessagerController>(
                  builder: (_, controller, __) {
                    var chats = controller.getChats();
                    return controller.getChats().isNotEmpty
                        ? ListView.builder(
                            itemCount: chats.length,
                            itemBuilder: (context, index) => ChatTile(
                                chatName: chats.keys.toList()[index],
                                index: index),
                          )
                        : const Center(
                            child: Text('You dont have anyone to chat with.'));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
