import 'package:chat_app/presentation/widgets/chat_message.dart';
import 'package:chat_app/presentation/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
