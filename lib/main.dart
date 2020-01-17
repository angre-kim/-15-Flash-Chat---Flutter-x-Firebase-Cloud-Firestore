import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

import 'screens/chat_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen().id,
      routes: {
        WelcomeScreen().id: (context) => WelcomeScreen(),
        'login_screen': (context) => LoginScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'chat_screen': (context) => ChatScreen(),
      },
      /*
    initialRoute: 'welcomee_screen',   // 오타나면 에러남
    routes: {
    'welcome_screen': (context) => WelcomeScreen(),
    'login_screen': (context) => LoginScreen(),
    'registration_screen': (context) => RegistrationScreen(),
    'chat_screen': (context) => ChatScreen(),

      이걸 피하기 위해서 text가 아닌 방식으로 구현

      class WelcomeScreen extends StatefulWidget {

       String id = 'welcome_screen';

       'welcome_screen': (context) => WelcomeScreen(), 대신

        WelcomeScreen().id: (context) => WelcomeScreen(), 로 수정

          */

      );
    }
  }

