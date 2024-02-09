

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class NewMessage extends StatefulWidget {
  const NewMessage({ Key? key }) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  } 

  void _sendMessage() async {
    final enterMessage = _messageController.text;

    if(enterMessage.trim().isEmpty){
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    // fetch userName & userImage

    final User user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    // send Message to firestore

    await FirebaseFirestore.instance.collection('chatMessage').add({
      'text': enterMessage,
      'createAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.data()!['user_name'], 
      'userImage': userData.data()!['image_url'],
    }); 
  } 
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          
           Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Write Message'),
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              autocorrect: true,
            ),
          ),
          IconButton(onPressed: _sendMessage, icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary,))
        ],
      ), 
    );
  }
}