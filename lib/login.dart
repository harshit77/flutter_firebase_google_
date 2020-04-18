import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebaseauthwithgooglesignin/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Chat App',
       home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

// Timer _timer=Timer.periodic(const Duration( milliseconds: 1400), (_timer) {
//  Fluttertoast.showToast(
//    msg: "I am inside Timmer"
//  );
// });
 final GoogleSignIn _googleSignIn = GoogleSignIn();
 final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
SharedPreferences _sharedPreferences;
FirebaseUser currentUser;
 bool _isLoading=false,_isLoggedIn=false;

@override
void initState() {
    super.initState();
    _isSignedIn();
  }


  void _isSignedIn() async{
   this.setState(() {
        _isLoading=true;
      });
   _sharedPreferences= await SharedPreferences.getInstance();
    _isLoggedIn= await _googleSignIn.isSignedIn();
    if(_isLoggedIn)   {
    print("Inside _isSignedIn");
     print('lllll ${_sharedPreferences.getString('id')}');
      Navigator.push(context, new MaterialPageRoute(
         builder: (context) =>new HomeScreen(currentUser: _sharedPreferences.getString('id'))
      ));
    }
     this.setState(() {
              _isLoading=false;
            });
  }


  Future<Null> _signIn() async {
    this.setState(() {
          _isLoading=true;
        });
    final GoogleSignInAccount _googleSigninAccount= await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleSignInAuth= await _googleSigninAccount.authentication;
    FirebaseUser firebaseUser= await _firebaseAuth.signInWithGoogle(
       accessToken: _googleSignInAuth.accessToken,
       idToken: _googleSignInAuth.idToken
    );
  if(firebaseUser!=null) {
     final Firestore _firestore= Firestore.instance;
      final QuerySnapshot _result= await _firestore.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      List<DocumentSnapshot> _documents=_result.documents;
       print(_documents.length);
      if(_documents.length==0) {
        _firestore.collection('users').document(firebaseUser.uid).setData({
          'nickname':firebaseUser.displayName,
          'photoUrl':firebaseUser.photoUrl,
          'id':firebaseUser.uid
        });
        currentUser=firebaseUser;
        await _sharedPreferences.setString('nickname', currentUser.displayName);
         await _sharedPreferences.setString('photoUrl', currentUser.photoUrl);
          await _sharedPreferences.setString('id', currentUser.uid);
      }
      else {
        await _sharedPreferences.setString('nickname', _documents[0]['nickname']);
          await _sharedPreferences.setString('photoUrl', _documents[0]['photoUrl']);
            await _sharedPreferences.setString('id', _documents[0]['id']);
            await _sharedPreferences.setString('aboutMe', _documents[0]['aboutMe']);
      }
      Fluttertoast.showToast(
    msg: 'Successful',
     gravity:  ToastGravity.CENTER,
      backgroundColor: Colors.amberAccent,
       textColor: Colors.white
 );
  this.setState(() {
      _isLoading=false;
    });
      Navigator.push(context, MaterialPageRoute(
         builder: (context)=> HomeScreen(currentUser: _sharedPreferences.getString('id'))
      ));
  }
  else{
    Fluttertoast.showToast(
      msg: 'Sign In Fail'
    );
    this.setState(() {
      _isLoading=false;
    });
  }
 

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
          fit:StackFit.expand,
           children: <Widget>[
             Container(
                decoration: BoxDecoration(
                   color: Colors.white
                ),
             ),
             Column(
                mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                     Expanded(
                      flex: 2,
                       child: Container(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                               CircleAvatar(
                                   child: Icon(Icons.chat_bubble, size: 50.0, color: Colors.white),
                                    radius: 50.0,
                                  ),
                                 Padding(padding: const EdgeInsets.all(10.0)),
                                 Text('Chatters',style: TextStyle( fontWeight:  FontWeight.bold, fontSize: 22.0, color: Colors.black45),)
                                ],
                                  ),
                          ),
                          ),
                          Expanded(
                             flex: 1,
                              child: Container(
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                     _isLoading==true ? CircularProgressIndicator():RaisedButton(
                                         onPressed: _signIn,
                                          child: Text('SIGN IN'),
                                           color: Colors.teal,
                                      ),
                                      Padding(padding: const EdgeInsets.all(20.0)),

                                      Container(
                                         child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                           children: <Widget>[
                                            Icon(Icons.favorite, color: Colors.red,),
                                            Padding(padding: const EdgeInsets.only( left:5)),
                                             Text('Connect and Share Love')
                                         ],
                                      )
                                      )
                                    ],
                                 ),
                              ),
                          )
                       ],
                  )
           ],
           
        
      ),
    );
  }
}