import 'dart:io';

import 'package:chatapp/add_image/add_image.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  final _authentication = FirebaseAuth.instance;
  bool showSpiner = false;
  bool isSignupScreen = true;
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';
  File? userPickedImage;

  void pickedimage(File image){
    userPickedImage = image;
  }

  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  void showAlert(BuildContext context){
    showDialog(context: context, builder: (context){
      return Dialog(
        backgroundColor: Colors.white,
        child: AddImage(pickedimage),
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: ModalProgressHUD(
          inAsyncCall: showSpiner,
          child: Stack(children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage('image/images.jpg'),
                              fit:BoxFit.fill)),
                  child: Container(
                    padding: EdgeInsets.only(top:90, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Welcome',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 25,
                              color: Colors.white
                            ),
                            children: [
                              TextSpan(
                                text: isSignupScreen ?' to Thunder chat!' : ' back',
                                style: TextStyle(
                                  letterSpacing: 1.0,
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(isSignupScreen?'Signup to continue':'Signin to continue',
                        style: TextStyle(
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            //배경
            Positioned(
              top: 180,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.all(20.0),
                  height: isSignupScreen ? 280.0 : 250.0,
                  width: MediaQuery.of(context).size.width - 40,
                  margin : EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child:  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isSignupScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:!isSignupScreen ?  Palette.activeColor : Palette.textColor1
                                    ),
                                  ),
                                  if(!isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.only(top:3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isSignupScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'SIGNUP',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSignupScreen ?  Palette.activeColor : Palette.textColor1
                                        ),
                                      ),
                                      SizedBox(width:15,),
                                      if(isSignupScreen)
                                      GestureDetector(
                                        onTap: (){
                                          showAlert(context);
                                        },
                                        child: Icon(
                                          Icons.image,
                                          color: isSignupScreen? Colors.cyan : Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0,3,35,0),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if(isSignupScreen)
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: ValueKey(1),
                                  validator: (value){
                                    if(value!.isEmpty || value.length < 4){
                                      return 'Please enter at least 4 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    userName = value!;
                                  },
                                  onChanged: (value){
                                    userName = value;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        Icons.account_circle,
                                    color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Palette.textColor1
                                      ),
                                    borderRadius: BorderRadius.all(Radius.circular(35.0)
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                        BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    hintText: 'User name',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  key: ValueKey(2),
                                  validator: (value){
                                    if(value!.isEmpty || !value.contains('@')){
                                      return 'Please enter a valid email address.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    userEmail = value!;
                                  },
                                  onChanged: (value){
                                    userEmail = value;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        Icons.email,
                                        color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.textColor1
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35.0)
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    hintText: 'email',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Palette.textColor1
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  key:ValueKey(3),
                                  validator: (value){
                                    if(value!.isEmpty || value.length < 6){
                                      return "Password must be at least 7 characters long.";
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    userPassword = value!;
                                  },
                                  onChanged: (value){
                                    userPassword = value;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        Icons.lock,
                                        color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.textColor1
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35.0)
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Palette.textColor1
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(!isSignupScreen)
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: ValueKey(4),
                                  validator: (value){
                                    if(value!.isEmpty || value.length < 4){
                                      return 'Please enter at least 4 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    userEmail = value!;
                                  },
                                  onChanged: (value){
                                    userEmail = value;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        Icons.email,
                                        color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.textColor1
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35.0)
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    hintText: 'email',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Palette.textColor1
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                                SizedBox(height: 8,),
                                TextFormField(
                                  obscureText: true,
                                  key: ValueKey(5),
                                  validator: (value){
                                    if(value!.isEmpty || value.length < 6){
                                      return 'Password must be at least 7 characters long.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    userPassword = value!;
                                  },
                                  onChanged: (value){
                                    userPassword = value;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        Icons.lock,
                                        color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.textColor1
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35.0)
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Palette.textColor1
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ),
           //텍스트 폼 필드
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen ? 430 : 400,
                right: 0,
                left: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          showSpiner = true;
                        });
                        if (isSignupScreen) {
                          if(userPickedImage == null){
                            setState(() {
                              showSpiner = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please pick your image'),
                              backgroundColor: Colors.blue,)
                            );
                            return;
                          }
                          _tryValidation();
                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword
                            );

                            final refImage = FirebaseStorage.instance
                                .ref()
                                .child('picked_image')
                            .child(newUser.user!.uid.toString() + '.png');

                            await refImage.putFile(userPickedImage!);
                            final url = await refImage.getDownloadURL();

                            await FirebaseFirestore.instance
                            .collection('user')
                            .doc(newUser.user!.uid)
                            .set({
                              'userName' : userName,
                              'email' : userEmail,
                              'picked_image' : url,
                            });
                          } catch (e) {
                            print(e);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(
                                    'Please check your email and password'),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            }
                          }
                        }
                        else {
                          try {
                            final newUser =
                            await _authentication.signInWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword);
                          } catch (e) {
                            print(e);
                          }
                        }
                        if(mounted) {
                          setState(() {
                            showSpiner = false;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.black,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(Icons.arrow_forward,
                        color: Colors.white,),
                      ),
                    ),
                  ),
                )
              ),
            //전송 버튼
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
                curve:Curves.easeIn,
                top: isSignupScreen ? MediaQuery.of(context).size.height-125
              : MediaQuery.of(context).size.height - 165,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Text(isSignupScreen ? 'or Signup with' : 'or Signin with'),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      onPressed: (){},
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: Size(155,40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          backgroundColor: Palette.googleColor
                        ),
                      icon: Icon(Icons.add),
                      label: Text('Google'),
                    ),
                  ],
                ),
              ),
            //구글 로그인 버튼
            ],
          ),
        ),
      ),
    );
  }
}
