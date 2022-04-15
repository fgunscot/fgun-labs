import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab1_provider_messager/src/chat/chat_service.dart';
import 'package:lab1_provider_messager/src/messager/messager_controller.dart';

class MessagerService {
  MessagerService({required this.controller}) {
    init();
  }
  late MessagerController controller;
  late String myUserId;

  final _usersCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  userDocumentRef(String id) =>
      FirebaseFirestore.instance.doc('users/$id').withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (movie, _) => movie.toJson(),
          );

  final _chatsCollectionRef = FirebaseFirestore.instance
      .collection('chats')
      .withConverter<ChatModel>(
        fromFirestore: (snapshot, _) => ChatModel.fromJson(snapshot.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  void init() {
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        myUserId = user.uid;
        if (await checkExist(user.uid)) {
          var myUser = await userDocumentRef(user.uid).get();
          controller.setUserModel(myUser.data());
          usersHandler();
        } else {
          addUser(user);
        }
      }
    });
  }

  void usersHandler() {
    List<String> filter = [];
    filter.add(myUserId);
    Map<String, UserModel> col = {};
    _usersCollectionRef
        .where(FieldPath.documentId, whereNotIn: filter)
        .snapshots()
        .listen((users) {
      for (var doc in users.docs) {
        col[doc.id] = doc.data();
      }
      controller.setUsers(col);
    });
  }

  void startChat(String id) async {
    var ref = await _chatsCollectionRef.add(ChatModel(userIds: [myUserId, id]));
    var chatId = ref.id;
    _usersCollectionRef
        .doc(myUserId)
        .update({'chat_ids.$chatId': getOthersDisplayName(id)});
    _usersCollectionRef
        .doc(id)
        .update({'chat_ids.$chatId': controller.getUserModel().displayName});
  }

  String? getOthersDisplayName(String id) {
    return controller.getUsers()[id]!.displayName;
  }

  void addUser(User user) {
    _usersCollectionRef.doc(user.uid).set(UserModel(
          displayName: user.displayName,
          chatIds: {},
        ));
  }

  Future<bool> checkExist(String id) async {
    try {
      var doc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}

class UserModel {
  UserModel({
    required this.displayName,
    required this.chatIds,
  });
  String? displayName;
  Map<String, dynamic> chatIds;

  UserModel.fromJson(Map<String, dynamic> json)
      : displayName = json['name']!,
        chatIds = json['chat_ids']!;

  Map<String, dynamic> toJson() => {
        'name': displayName,
        'chat_ids': chatIds,
      };
}

class ChatModel {
  ChatModel({required this.userIds});
  String? name;
  List<String> userIds;

  ChatModel.fromJson(Map<String, dynamic> json) : userIds = json['users_ids'];

  Map<String, dynamic> toJson() => {
        'user_ids': userIds,
      };
}
