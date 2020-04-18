import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebaseauthwithgooglesignin/choices.dart';
import 'package:firebaseauthwithgooglesignin/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseauthwithgooglesignin/login.dart';
import 'package:firebaseauthwithgooglesignin/chat.dart';
import 'package:firebaseauthwithgooglesignin/futureMessages.dart';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class HomeScreen extends StatefulWidget {
  final String currentUser;
  HomeScreen({@required this.currentUser});

  @override
  _HomeScreenState createState() => _HomeScreenState(currentUser:currentUser);
}

class _HomeScreenState extends State<HomeScreen> {
   List<Choices> _choices= const <Choices> [
  const Choices(title: 'Profile', icon: Icons.settings),
   const Choices(title: 'SignOut',icon: Icons.exit_to_app),
   const Choices(title: 'Future', icon :Icons.timelapse)
  ];
    final String currentUser;
  _HomeScreenState({@required this.currentUser});
  final Firestore _firestore= Firestore.instance;

 _indiviualChat(dynamic peerId) {
    Navigator.push(context, MaterialPageRoute(
       builder: (context)=>Chat(peerId:peerId)
    ));
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot document) {

     if(document['id'] == currentUser) {
      return Container();
     }
     else {
       print("_buildItem");
       return Container(
          padding: const EdgeInsets.only( top: 15.0),
          child: FlatButton(
           color: Colors.amberAccent,
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 25.0, 10.0),
             shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(5.0))),
             onPressed: () {
               Navigator.push(context, MaterialPageRoute(
       builder: (context)=>Chat(peerId:document.documentID,peerAvatar:document['photoUrl'])
    ));
             },
              child: Row(
                 children: <Widget>[
                   Material (
                      child: CachedNetworkImage(
                         placeholder: Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                            ),
                           height: 50.0,
                           width: 50.0,
                           padding: const EdgeInsets.all(10.0),
                         ),
                          imageUrl: document['photoUrl'],
                           height: 50.0,
                           width: 50.0,
                           fit: BoxFit.cover,
                      ),
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      
                   ),
                   Flexible(
                      child:  Container(
                         child: Column(
                            children: <Widget>[
                               Container(
                                  child: Text('Nickname: ${document['nickname']}',style: TextStyle(color: Colors.black)),
                                   alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                               ),
                               Container(
                                  child: Text(  'About me: ${document['aboutMe'] ?? 'Not available'}',style: TextStyle(color: Colors.black)),
                                  alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                               )
                            ],
                         ),
                      ),
                   )
                 ],
              ),
          ),
       );
     }
  }

Future<Null>_handleSignOut () async{

await FirebaseAuth.instance.signOut();
await GoogleSignIn().disconnect();
await GoogleSignIn().signOut();
Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
  builder:  (BuildContext context) =>MyApp(),
), (Route<dynamic> route)=>false);

}

void _itemSelected (Choices choice) {
   print(choice.title);
  if(choice.title=='SignOut')
  {
    _handleSignOut();
  }
  else if(choice.title=='Profile') {
    Navigator.push(context, MaterialPageRoute(
       builder: (BuildContext context) => Settings()
    ));
  }
  else {
    Navigator.push(context, MaterialPageRoute(
 builder: (BuildContext context) =>FutureMessages()
    ));
  }

}
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar:  AppBar(
            backgroundColor:Color.fromRGBO(104, 108, 112,1),
            title: Text("Home Screen"),
             centerTitle: true,
             actions: <Widget>[
                PopupMenuButton<Choices>(
                   onSelected: _itemSelected,
                   itemBuilder: (BuildContext context) {
                   return _choices.map((Choices choices){
                      return PopupMenuItem<Choices>(
                        value: choices,
                         child: Row(
                            children: <Widget>[
                               Icon(
                          choices.icon,
                          color: Colors.black,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choices.title,
                          style: TextStyle(color: Colors.black),
                        ),
                            ],
                         ),
                      );
                  }).toList();

                   },
                )
             ],
         ), 
         body: Stack (
           children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                     image: DecorationImage(
                        image: AssetImage('images/chatter.jpg'),
                        fit: BoxFit.cover
                     )
                  ),
              ),
          StreamBuilder(
            stream: _firestore.collection('users').snapshots(),
            builder: (context,snapshot) {
                if(!snapshot.hasData)
                {
                  return Center(child: CircularProgressIndicator());
                }
                else {    
                    return ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: snapshot.data.documents.length,
                       itemBuilder: (BuildContext context, int index) => _buildItem(context,snapshot.data.documents[index]),
                    );
                }
            }

      )
         ],
       ),
    )
    );
  }
}














//UnComment Following Code for Normal FirebaseAuthtication 

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//        title: 'FireBase Auth App',
//        home: HomePage(),
//         debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String myText;
//  StreamSubscription<DocumentSnapshot> subscription;
//   final  DocumentReference documentReference= Firestore.instance.document("MyData/dummy");
//   bool loginStatus=false,loader=false;
//   final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn= new GoogleSignIn();

// Future<FirebaseUser> _signIn() async{
//  setState(() {
//           loader=true;
//         });
//   GoogleSignInAccount googleSignInAccount= await googleSignIn.signIn();
//   GoogleSignInAuthentication googleSignInAuthentication= await  googleSignInAccount.authentication;

//   FirebaseUser user= await _firebaseAuth.signInWithGoogle(
//      accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken
//   );
//   print('User is ${user.displayName}');
//  return user;


// }
// void newScreen(FirebaseUser user) {
//   if(user.isAnonymous==false) {
//                      Navigator.push(context, new MaterialPageRoute(
//                           builder: (BuildContext context) {
//                             return new NewPage(user);
//                           }));
//       setState(() {
//           loginStatus=true;
//           loader=false;
//         });
//   }


// }

// @override
// void initState() {
//     // TODO: implement initState
//     super.initState();
//     subscription=documentReference.snapshots().listen((snapshot){
//         if(snapshot.exists){
// print("Document Updated Succesfully");  
// setState(() {
//   myText=snapshot.data['name'];
//         });  

//     }
//     });
//   }
//   @override 
//   void dispose() {
//       // TODO: implement dispose
//       subscription?.cancel();
//       super.dispose();
//     }

// void _add() {
//   Map<String,String> mapdata=<String,String> {
//     'name':'Harshit',
//     'developer Skills':'Flutter'
//   };
//   documentReference.setData(mapdata).whenComplete((){
//     print("Document Added");
//   }).catchError((e)=>print(e));
// }

// void _update() {
//   Map<String,String> mapdata=<String,String> {
//     'name':'Harshit Updated',
//     'developer Skills':'Flutter Updated'
//   };
//   documentReference.updateData(mapdata).whenComplete(() {
// print("Document Updated Succesfully");
//   }).catchError((e)=> print(e));
// }
// void _delete() {
//   documentReference.delete().whenComplete(() {
// print("Document Updated Succesfully");
//   }).catchError((e)=> print(e));
// }

// void _fetch() {
//   documentReference.get().then((DocumentSnapshot snapshot) {
//     if(snapshot.exists){
// print("Document Updated Succesfully");  
// setState(() {
//   myText=snapshot.data['name'];
//         });  

//     }

    
//   }).catchError((e)=> print(e));
// }

// void _signOut() {
//   googleSignIn.signOut();
//   setState(() {
//           loginStatus=false;
//         });
//   print("User is SignOut");
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: new AppBar(
//       //   title: new Text('Firebase Auth with Google Signin'),
//       // ),

//       body: Stack(
//         fit: StackFit.expand,
//          children: <Widget>[
//            Container(
//               decoration: BoxDecoration(
//                  color: Colors.redAccent
//               ),
//            ),
//            Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                Expanded(
//                   flex: 2,
//                   child: Container(
//                     child: Column(
//                        mainAxisAlignment:  MainAxisAlignment.center,
//                        children: <Widget>[
//                          CircleAvatar(
//                             radius: 50.0,
//                              child: Icon(Icons.shopping_basket, size: 50.0, color: Colors.white,),
//                          ),
//                          Padding( padding: const EdgeInsets.all(10.0)),
//                          Text('Robbers', style: TextStyle( color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold))
//                        ],
//                     ),
//                   ),
//                ),
//                Expanded(
//                  flex: 1,
//                   child: Container(
//                      child: Column(
//                         children:<Widget>[
//                         Row(mainAxisAlignment:MainAxisAlignment.center,
//               //           children: <Widget>[
//               //             loginStatus==false ?  new RaisedButton(
//               //                  color: Colors.teal,
//               //     onPressed: () => _signIn().then((FirebaseUser user)=> newScreen(user)).catchError((error) =>print(error)) ,
//               //      child: new Text('Sign In'),
//               //  )
//               //  :
//               //   new RaisedButton(
//               //     onPressed: _signOut ,
//               //      child: new Text('Sign Out'),
//               //  ),
//               //           ],
//                         ),
//                      loader==true ? CircularProgressIndicator() :Text(''),
//                        Padding(padding:const EdgeInsets.all(10.0)),
//                        RaisedButton(
//                          onPressed: _add,
//                           color: Colors.amberAccent,
//                         child: Text('Add Data')
//                         ),
//                         // Padding(padding:const EdgeInsets.all(10.0)),
//                         // RaisedButton(
//                         //  onPressed: _delete,
//                         //   color: Colors.amberAccent,
//                         // child: Text('Delete Data')
//                         // ),
//                         // Padding(padding:const EdgeInsets.all(10.0)),
//                         // RaisedButton(
//                         //  onPressed: _fetch,
//                         //   color: Colors.amberAccent,
//                         // child: Text('Fetch Data')
//                         // ),
//                         Padding(padding:const EdgeInsets.all(10.0)),
//                          Padding(padding:const EdgeInsets.all(10.0)),
//                         RaisedButton(
//                          onPressed: _update,
//                           color: Colors.amberAccent,
//                         child: Text('update Data')
//                         ),
//                         Padding(padding:const EdgeInsets.all(10.0)),
//                         myText==null ? new Container(): new Text(myText),
//                        Text('Share your Robbery details \n Never miss latest Update')
//                      ],
//                   ),
//                )
//                )
//              ],)
//          ],
//       )
//       //  body: new Padding(
//       //    padding: const EdgeInsets.all(20.0),
//       //     child: new Column(
//       //        mainAxisAlignment: MainAxisAlignment.center,
//       //        crossAxisAlignment: CrossAxisAlignment.stretch,
//       //        children: <Widget>[
//       //          new RaisedButton(
//       //             onPressed: () => _signIn().then((FirebaseUser user)=> newScreen(user)).catchError((error) =>print(error)) ,
//       //              child: new Text('Sign In'),
//       //          ),
//       //           new RaisedButton(
//       //             onPressed: _signOut ,
//       //              child: new Text('Sign Out'),
//       //          )
//       //        ],
//       //     ),
//       //  ),
      
//     );
//   }
// }

// class NewPage extends StatelessWidget {
//   final FirebaseUser userStats;
//   NewPage(this.userStats);
//   @override
//   Widget build(BuildContext context) {
//     print(userStats);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Stats'),
//       ),
//        body: Center(
//          child: new Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//                Padding(padding:const EdgeInsets.only(top: 20.0,bottom: 10.0)),
//               ClipOval(
//                 child: new Image.network(
//                   userStats.photoUrl,
//                      fit: BoxFit.fill,
//                       width: 90.0,
//                     height: 90.0,
//                 ),
//             ),
//             Padding(padding:const EdgeInsets.only(top: 10.0,bottom: 10.0)),
//             Container(
//                child: new Text(userStats.displayName,
//                 style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.deepOrange) 
//                  )
//                  ),
//                  Padding(padding:const EdgeInsets.only(top: 10.0,bottom: 10.0)),
//                  Column(
//                     children: <Widget>[
//                       Container(
//                          color: Colors.white10,
//                         child: ListTile(title: Text('Email'),
//                          subtitle: Text(userStats.email),
//                          leading: IconButton(
//                            icon:Icon(Icons.email),
//                          ),
//                           trailing: IconButton(
//                              iconSize: 40.0,
//                              icon: Icon(Icons.navigate_next),
                               
//                           ),
//                          ),
//                       ),
//                       Divider(color:Colors.grey,height: 2.0,),
//                       Container(
//                          color: Colors.white10,
//                         child: ListTile(title: Text('Photos'),
//                          subtitle: Text(userStats.uid),
//                          leading: IconButton(
//                            icon:Icon(Icons.photo_camera),
//                          ),
//                           trailing: IconButton(
//                              iconSize: 40.0,
//                              icon: Icon(Icons.navigate_next),
                               
//                           ),
//                          ),
//                       ),
//                        Divider(color:Colors.grey,height: 2.0,),
//                       Container(
//                          color: Colors.white10,
//                         child: ListTile(title: Text('Phone'),
//                          subtitle: Text(userStats.uid),
//                          leading: IconButton(
//                            icon:Icon(Icons.phone_android),
//                          ),
//                           trailing: IconButton(
//                              iconSize: 40.0,
//                              icon: Icon(Icons.navigate_next),
                               
//                           ),
//                          ),
//                       ),
//                       Divider(color:Colors.grey,height: 2.0,),
//                       Container(
//                          color: Colors.white10,
//                         child: ListTile(title: Text('Vacation'),
//                          subtitle: Text(DateTime.now().toString()),
//                          leading: IconButton(
//                            icon:Icon(Icons.beach_access),
//                          ),
//                           trailing: IconButton(
//                              iconSize: 40.0,
//                              icon: Icon(Icons.navigate_next),
                               
//                           ),
//                          ),
//                       )
//                     ],
//                  )
//             ],

//          ),
//        ),
       
      
//     );
//   }
// }