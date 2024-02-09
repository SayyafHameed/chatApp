import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: const Center(child: Text('loading....')),
    );
  }
}