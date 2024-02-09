import 'package:chat_app_sayyaf/widget/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
const ChatMessage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final authFirebase = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chatMessage').orderBy('createAt', descending: false).snapshots(),
      builder: (ctx, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting)
        {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
        {
          return const Center(child: Text('No Message Found.'));
        }
        if(snapshot.hasError)
        {
          return const Center(child: Text('Something Went Worng... '));
        }

        final loadedMessage = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessage.length,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessage[index].data();
            final nextMessage = index + 1 < loadedMessage.length? loadedMessage[index + 1].data() : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId = nextMessage!=null? nextMessage['userId'] : null;
            final bool nextUser = nextMessageUserId == currentMessageUserId;
            // if(nextUser){
            //   return MessageBubble(isOneMessage: authFirebase.uid == currentMessageUserId, message: , height: 2.0, width: 2.0);
            // }
          },
          );
      },);
  }
}