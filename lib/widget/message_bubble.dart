import 'package:chat_app_sayyaf/widget/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final bool isOneMessage;
  final ChatMessage message;
  final double height;
  final double width;

const MessageBubble({ Key? key, required this.isOneMessage, required this.message, required this.height, required this.width }) : super(key: key);

  @override
  Widget build(BuildContext context){
    List<Color> _colorScheme = isOneMessage 
    ? [Color.fromRGBO(0, 136, 249, 1.0),
     Color.fromRGBO(0, 82, 218, 1.0),] 
     : [Color.fromRGBO(51, 49, 68, 1.0),
      Color.fromRGBO(51, 49, 68, 1.0),] ;
    return Container(
      // height: height + (message.length / 20 * 6.0),
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(colors: _colorScheme, stops: const [0.30, 0.70], begin: Alignment.centerLeft, end: Alignment.centerRight)
      ),
    );
  }
}