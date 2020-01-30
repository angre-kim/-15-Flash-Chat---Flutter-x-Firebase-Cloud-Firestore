import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance; //3rd. cloud에 저장하기 위해// widget분리 후 에러방지위해 상위로 위치시킴
class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();//가. 입력창 글자 입력 후 clear 만들기 위해
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String messageText; // 1st. cloud에 저장하기 위해

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

//  void getMessages() async {
//    final messages = await _firestore.collection('messages').getDocuments();
//    for (var message in messages.documents) {
//      print(message.data);
  //  }
//}

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      //listen한다.firebase 대쉬보드에서 입력해도 listen 할 수 있다.
      for (var message in snapshot.documents) {
        //전부다
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messagesStream(); //
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,//나. 입력창 글자 입력 후 clear 만들기 위해
                      onChanged: (value) {
                        messageText = value; // 2nd. cloud에 저장하기 위해
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();//다. 입력창 글자 입력 후 clear 만들기 위해
                      _firestore.collection('messages').add({
                        //map 타입
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    }, //4th. cloud에 저장하기 위해
                    child: Text(
                      '전송',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   //streambuilder 시작
      StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );

          }
          final messages = snapshot.data.documents;
          List<MessageBubble>messageBubble = [];
          for (var message in messages) {
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];

            final messageWidget = MessageBubble(
              sender: messageSender,
              text: messageText,
            );

            messageBubble.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              padding:
              EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubble,
            ),
          );

        },
      );
  }
}


class MessageBubble extends StatelessWidget {

  MessageBubble({this.sender, this.text});

  final String sender;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(30.0),//버블형태 만들기
            elevation: 5.0,// elevation 주기
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
