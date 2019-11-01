import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import 'package:http/http.dart' as http;
// import 'package:myapp/Screens/HorizentalListview.dart';
// import 'package:myapp/Screens/Maps.dart';
// import 'package:myapp/Screens/NewMap.dart';
// import 'package:myapp/Screens/StaticListview.dart';
// import 'package:myapp/Screens/card.dart';
// import 'package:myapp/Screens/custom_list_view.dart';
// import 'package:myapp/Screens/drawer.dart';
// import 'package:myapp/Screens/dynamiclistview.dart';
// import 'package:myapp/Screens/listStyling.dart';
// import 'package:myapp/Screens/listall.dart';
// import 'package:myapp/Screens/place_search_map.dart';
// import 'package:myapp/Screens/updatelistview.dart';
// import 'package:myapp/utils/navigation_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_in_app_purchase/src/InAppPurchase/in_app_billing.dart';
import 'package:test_in_app_purchase/src/Map/map_charge_points.dart';
import 'Home.dart';


// class LoginScreen extends StatelessWidget
// {
//   @override
//   Widget build(BuildContext context)
//   {
//    // final wordPair = WordPair.random();
//     return MaterialApp(
//       title:  "Welcomr",
//       home: Scaffold (
//         appBar: AppBar(
//           title:  Text("Wecomre to flutter"),
//         ),
//         body: Center(
//         child: Text("wecome New"),
//        // child: Text(wordPair.asPascalCase),
//         ),
//       ),
//     );
//   }
// }
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}
 class _LoginData {
  String email = '';
  String password = '';
}
class _LoginScreenState extends State<LoginScreen> {
  BuildContext newContext;
  String textToSend = "";
  String url = " http://172.16.19.69:8080/api/login";
  String _message = 'Log in/out by pressing the buttons below.';
   final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
 _LoginData _data = new _LoginData();
  @override
  Widget build (BuildContext context)
  {
    newContext = context;
    MediaQueryData media = MediaQuery.of(context);
   final Size screenSize = media.size;
    
        return new Scaffold(
          //key: this.scaffoldKey,
          appBar: new AppBar(
            title: new Text('EVOKE'),
          ),
          body: new Container(
              padding: new EdgeInsets.all(20.0),
    
              child: new Form(
                key: this._formKey,
                child: new ListView(
                  children: <Widget>[
                    new Container(
                        padding: new EdgeInsets.all(20.0),
                        child:new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlutterLogo(
                            size: 100.0,
                          ),
                        ],
                      )
                    ),
                    new Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new TextFormField(
                          keyboardType: TextInputType.emailAddress, // Use email input type for emails.
                          decoration: new InputDecoration(
                              hintText: 'you@example.com',
                              labelText: 'E-mail Address',
                              icon: new Icon(Icons.email)),
                          validator: this._validateEmail,
                          onSaved: (String value) {
                            this._data.email = value;
                          }
    
                          )
                      ),
                    new Container(
                      padding: const EdgeInsets.only(top:10.0),
                      child:  new TextFormField(
                          obscureText: true, // Use secure text for passwords.
                          decoration: new InputDecoration(
                              hintText: 'Password',
                              labelText: 'Enter your password',
                              icon: new Icon(Icons.lock)
    
                          ),
                          validator: this._validatePassword,
                          onSaved: (String value) {
                            this._data.password = value;
                          }
                      ),
                    ),
                    new Container(
                      width: screenSize.width,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        height:40.0,
                        margin: const EdgeInsets.only(left: 0.0,top: 30.0),
                        child: new RaisedButton(
                          child: new Text(
                            'Login',
                            style: new TextStyle(
                                color: Colors.white
                            ),
                          ),
                          onPressed: this._submit,
                          color: Colors.blue,
                        ),

                      ),
                      new Container(
                        height:40.0,
                        margin: const EdgeInsets.only(left: 30.0,top: 30.0),
                        child: new RaisedButton(
                          child: new Text(
                            'Skip',
                            style: new TextStyle(
                                color: Colors.white
                            ),
                          ),
                          onPressed: skipAuthentication,
                          color: Colors.blue[100],
                        ),

                      )
                    ],
                  ),
                ),
         ],
            ),
          )
      ),
    );
  }
   String _validateEmail(String value) {

   //if(!(value.length>0 && value.contains("@") && value.contains("."))){
     if(!(value.length>0 )){
   return 'The E-mail Address must be a valid email address.';
   }
   return null;
 }
 String _validatePassword(String value) {
  //  if (value.length < 8) {
  //    return 'The Password must be at least 8 characters.';
  //  }
    if (value.length < 1) {
     return 'The Password must be at least 1 character.';
   }

   return null;
 }
  Future _submit() async {
   if (this._formKey.currentState.validate()) {
     _formKey.currentState.save(); // Save our form now.

     print('Printing the login data.');
     print('Email: ${_data.email}');
     print('Password: ${_data.password}');
     
     asyncFunc();
      addBoolToSF();
     //NavigationRouter.switchToHome(context);
     //print('Passwordcfafafaas: ${asyncResult}');
     //if (asyncResult == "success")
    // {

      Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Homescreen(),
    ));
    
         //NavigationRouter.switchToHome(context) ;
    //      Navigator.pushNamed(context, "/HomeScreen", 
    //      MaterialPageRoute(
    //   builder: (context) => HomeScreen(text: textToSend,),
    // ));
       //print('Password: ${textToSend}');

         
         
    }
 }
 void addBoolToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('boolValue', true);
   print('Password: ${prefs.getBool('boolValue')}');
}
 void skipAuthentication() {
   
   Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MapChargePoints(),
    ));
 }

Future asyncFunc() async {
  

 
 

//     Map data1 = {
// "username": "admin",
// "password": "admin"
// };

 var url = 'http://172.16.19.69:8080/api/login';
var match = {
"username": _data.email,
"password": _data.password
};
// var response = await post(Uri.parse(url),
//     // headers: {
//     //   "Accept": "application/json",
//     //   "Content-Type": "application/x-www-form-urlencoded"
//     // },
//     body: json.encode(match),
//     encoding: Encoding.getByName("utf-8"));
   
var response = await http.post(url,  body: json.encode(match),
    encoding: Encoding.getByName("utf-8"));

//var response = await http.get(url);
print('Response status: ${response.statusCode}');
print('Response body: ${response.body}');
textToSend = response.body;
print('textToSendvdbgdx: ${textToSend}');
print(await http.read('http://172.16.19.69:8080/api/login'));
       
   
  
  }
 
 
 
 void _showMessage(String message) {
   setState(() {
     _message = message;
   });
 }
}


// Future<Null> _seviceGetting() async {
 
// var url = 'http://172.16.19.69:8080/api/login';
// var response = await http.post(url, body: {
// "username": "admin",
// "password": "admin"
// });
// print('Response status: ${response.statusCode}');
// print('Response body: ${response.body}');

// print(await http.read('http://172.16.19.69:8080/api/login'));
   
//  }