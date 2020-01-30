import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore =
    Firestore.instance; //3rd. cloud에 저장하기 위해// widget분리 후 에러방지위해 상위로 위치시킴
FirebaseUser loggedInUser; //a.센더에 따른 다른 색상주기 위해

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController =
      TextEditingController(); //가. 입력창 글자 입력 후 clear 만들기 위해
  final _auth = FirebaseAuth.instance;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
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
                      controller:
                          messageTextController, //나. 입력창 글자 입력 후 clear 만들기 위해
                      onChanged: (value) {
                        messageText = value; // 2nd. cloud에 저장하기 위해
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController
                          .clear(); //다. 입력창 글자 입력 후 clear 만들기 위해
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
    return //streambuilder 시작
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
        final messages =
            snapshot.data.documents.reversed; //ㄴ. 아래에서 위로 입력 내용 보이게
        List<MessageBubble> messageBubble = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final currentUser = loggedInUser.email; //b.센더에 따른 다른 색상주기 위해

          if (currentUser == messageSender) {
            //c.센더에 따른 다른 색상주기 위해
          }
          final messageWidget = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender, //e.센더에 따른 다른 색상주기 위해
          );

          messageBubble.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true, //ㄱ.입력창 고정시키고 그 위에서 위로 스크롤되게 하기위해
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubble,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe; //d.센더에 따른 다른 색상주기 위해

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start, //g.센더에 따른 다른 위치 위해
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    //센더에 따른 화살표 방향 수정
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            elevation: 5.0, // elevation 주기
            color: isMe
                ? Colors.lightBlueAccent
                : Colors.white, //e.센더에 따른 다른 색상주기 위해
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe
                      ? Colors.white
                      : Colors.black54, //f.센더에 따른 다른 색상주기 위해
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
