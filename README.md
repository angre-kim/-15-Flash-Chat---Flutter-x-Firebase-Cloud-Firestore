
# 섹션 15-Flash Chat ⚡️



## What you will create

![Finished App](https://github.com/londonappbrewery/Images/blob/master/flash_chat_flutter_demo.gif)

## What you will learn

- How to incorporate Firebase into your Flutter projects.
- How to use Firebase authentication to register and sign in users.
- How to create beautiful animations using the Flutter Hero widget.
- How to create custom aniamtions using Flutter's animation controller. 
- Learn all about mixins and how they differ from superclasses.
- Learn about Streams and how they work.
- Learn to use ListViews to build scrolling views.
- How to use Firebase Cloud Firestore to store and retrieve data on the fly.


## 171-2

    initialRoute: 'welcomee_screen',  // 오타나면 에러남
    routes: {
    'welcome_screen': (context) => WelcomeScreen(),
    'login_screen': (context) => LoginScreen(),
    'registration_screen': (context) => RegistrationScreen(),
    'chat_screen': (context) => ChatScreen(),

이걸 피하기 위해서 text가 아닌 방식으로 구현

    class WelcomeScreen extends StatefulWidget {
    
       String id = 'welcome_screen';                //추가하고
    
       'welcome_screen': (context) => WelcomeScreen(), //이 부분을 
    
        WelcomeScreen().id: (context) => WelcomeScreen(), 로 수정
        
 WelcomeScreen() widget를 호출하지 않기위해 static사용하고 
 
    static String id = 'welcome_screen';

    routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        
 로 수정
    
    
