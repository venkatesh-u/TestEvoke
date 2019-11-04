
import 'package:flutter/material.dart';
import 'package:test_in_app_purchase/src/InAppPurchase/in_app_billing.dart';
// import 'package:myapp/Screens/Home.dart';

import 'src/Auth/Login.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//import 'package:registration_login/Screens/Login.dart';
//import 'package:registration_login/Screens/splash.dart';

// import 'Screens/splash.dart';
//import 'package:english_words/english_words.dart';

//void main() => runApp(MyApp());

var routes =  <String , WidgetBuilder>
{
   "/LoginScreen" : (BuildContext context) => LoginScreen()
};

void main() => runApp(MaterialApp(
      title: 'Named Routes Demo',
      debugShowCheckedModeBanner: false,
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => LoginScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        //'/second': (context) => SecondScreen(),
        "/inAppPurchase" : (BuildContext context) => InAppPurchaseScreen(),
      },
    ));




// void main() => runApp(new MaterialApp(
//   theme: ThemeData.dark(),
//   debugShowCheckedModeBanner: false,
//    initialRoute: '/',
//   // home: SplashScreen(),
//   routes:routes
// ));