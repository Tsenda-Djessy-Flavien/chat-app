import 'package:chat_app/presentation/widgets/chat_message.dart';
import 'package:chat_app/presentation/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    // recuperer le token de l'appareil qui envoie la notification
    final token = await fcm.getToken();
    // vous pouvez envoyer ce token via http ou bien un sdk firestore (backend)
    print('device notif token: $token');
  }

  @override
  void initState() {
    setupPushNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(child: ChatMessage()),
          NewMessage(),
        ],
      ),
    );
  }
}
