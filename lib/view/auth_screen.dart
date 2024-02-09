import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widget/user_images_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
const AuthScreen({ Key? key }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _emailAdd = '';
  var _userName = '';
  var _password = '';
  File? _selectedImage;
  var _isUpLoading = false;

  void _submit() async {
    final valid = _formKey.currentState!.validate();

    if (!valid || (!_isLogin && _selectedImage == null)){
      return;
    }
    try {
      setState(() {
        _isUpLoading = true;
      });
    if(_isLogin)  {
        final UserCredential userCredential = await _firebase.signInWithEmailAndPassword(email: _emailAdd, password: _password,);

       final Reference storageRef = FirebaseStorage.instance.ref().child('user_images').child(
         '${userCredential.user!.uid}.jpg' // unqiue id image
        );

        await storageRef.putFile(_selectedImage!);
        final imageURL = await storageRef.getDownloadURL();
        log(imageURL);

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'user_name': _userName,
          'email': _emailAdd,
          'image_url': imageURL,
        });
    }
    else{
        final UserCredential userCredential = await _firebase.createUserWithEmailAndPassword(email: _emailAdd, password: _password,);
        }
      }on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? 'Authentication Faild.'),));

        setState(() {
          _isUpLoading = false;
        });
      }
    

    if(valid){
      _formKey.currentState!.save();
      log(_emailAdd);
      log(_password);
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  right: 20,
                  left: 20,
                ),
                child: const Icon(Icons.person, size: 150.0,),
              ),
              Card(
                margin: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Padding(padding: const EdgeInsets.all(16.0),
                  child: Form(key: _formKey,
                  child: Column(
                    children: [
                      if(!_isLogin)  
                      UserImagesPicker(onImagePick: (File imagePecker) { 
                        _selectedImage = imagePecker;
                       },),
                      if(!_isLogin) 
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'User Name',
                        ),
                        keyboardType: TextInputType.name,
                        onSaved: (value) => _userName = value!,
                        validator: (value){
                          if(value == null || value.trim().length < 4){
                            return 'Password must be at least 4 charcters long.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        onSaved: (value) => _emailAdd = value!,
                        validator: (value){
                          if(value == null || value.trim().isEmpty || !value.contains('@')){
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        onSaved: (value) => _password = value!,
                        validator: (value){
                          if(value == null || value.trim().length < 6){
                            return 'Password must be at least 6 charcters long.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      if(!_isUpLoading) const CircularProgressIndicator(),
                      if(!_isUpLoading)
                      ElevatedButton(onPressed: _submit,style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ), 
                      child: Text(_isLogin ? 'Login' : 'SignUp'),
                      ),
                      if(!_isUpLoading)
                      TextButton(onPressed: (){
                        setState(() {
                          _isLogin = ! _isLogin;
                        });
                      }, 
                      child: Text(_isLogin ? 'Create an account' : 'I already have an account'),
                      ),
                    ],
                  )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}