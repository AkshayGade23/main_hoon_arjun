// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/providers/mahabharat_characters.dart';
import 'package:main_hoon_arjun/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

import '../widgets/comment.dart';
import '../constants.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/comment-screen';
  final currentShloK;

  // ignore: use_key_in_widget_constructors
  const CommentScreen({this.currentShloK});
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  var comments;
  List<dynamic> allUsers = [];

  void _postComment(comment) async {
    final _user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('Feed')
        .doc(widget.currentShloK)
        .collection('comments')
        .add({
      'createdAt': Timestamp.now(),
      'useremail': _user.email,
      'comment': comment,
    });
  }

  Widget commentChild(data) {
    return ListView.builder(
        itemBuilder: (context, index) {
          var commenter = allUsers.indexWhere(
              (element) => element['email'] == data[index]['useremail']);
          return CommentStructure(
              username: allUsers[commenter]['username'],
              comment: data[index]['comment'],
              avatarIndex: allUsers[commenter]['avatarIndex']);
        },
        itemCount: data.length);
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Comments'),
        elevation: 0,
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("users").get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            allUsers = snapshot.data.docs.map((e) => e.data()).toList();
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Feed')
                  .doc(widget.currentShloK)
                  .collection('comments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CommentBox(
                    userImage: "",
                    child: commentChild(snapshot.data.docs),
                    labelText: 'Write a comment...',
                    errorText: 'Comment cannot be blank',
                    withBorder: false,
                    sendButtonMethod: () {
                      if (formKey.currentState.validate()) {
                        _postComment(commentController.text);
                        commentController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                    formKey: formKey,
                    commentController: commentController,
                    backgroundColor: backgroundC,
                    textColor: Colors.white,
                    sendWidget: Icon(
                      Icons.send_sharp,
                      size: 30,
                      color: Colors.white,
                    ),
                  );
                }
                return CircularProgressIndicator();
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

class CommentStructure extends StatelessWidget {
  final String username;
  final String comment;
  final int avatarIndex;
  CommentStructure({this.username, this.comment, this.avatarIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return ProfilePictureDialog(
                        avatarIndex: avatarIndex,
                        username: username,
                      );
                    });
              },
              child: CircleAvatar(
                backgroundColor: Colors.orange.shade50,
                radius: 30,
                child: Image.asset(
                  Provider.of<MahabharatCharacters>(context, listen: true)
                      .getCharacterImageLink(avatarIndex),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            height: 30.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 280,
                padding: EdgeInsets.all(1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
              Container(
                width: 280,
                child: Text(
                  comment,
                  style: TextStyle(color: Colors.white),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
