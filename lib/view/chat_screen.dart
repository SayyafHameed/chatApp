import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/chat_message.dart';
import '../widget/new_message.dart';

class ChatScreen extends StatelessWidget {
const ChatScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          }, 
          icon: const Icon(Icons.exit_to_app),
          color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      body: Column(
        children: const [
          Expanded(child: ChatMessage()),
          NewMessage(),
        ],
      ),
    );
  }
}