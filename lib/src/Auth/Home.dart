import 'package:flutter/material.dart';
// import 'package:myapp/Screens/List.dart';
// import 'package:myapp/utils/navigation_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  @override
  HomescreencreenState createState() => HomescreencreenState();
}

class HomescreencreenState extends State<Homescreen> {

 
//final String text;
// Homescreen({Key key, @required this.text}) : super(key: key);
  // receive data from the FirstScreen as a parameter
  //Homescreen({Key key, @required this.text}) : super(key: key);
  @override  
  Widget build(BuildContext context) {
   
    return Scaffold(appBar: AppBar(title:Text('Home screen')),
    body: Center(
      child: new RaisedButton(child: new Text(
                            'Log Out',
                            style: new TextStyle(
                                color: Colors.white
                            ),
                          ),
                          onPressed: _submit,
                          color: Colors.deepPurple,
      ),
    ),
    );

  }
 void addBoolToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
 // prefs.setBool('boolValue', false);
}
 void _submit() {
   addBoolToSF();
   //Navigator.of(context).pushReplacementNamed('/LoginScreen');
   //Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
  // Navigator.popUntil(context, ModalRoute.withName('/LoginScreen'));

   Navigator.push(
    context,
    MaterialPageRoute(
      // builder: (context) => RealWorldApp(),
    ));
 }
}