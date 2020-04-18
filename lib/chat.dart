import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebaseauthwithgooglesignin/main.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cached_network_image/cached_network_image.dart';


class Chat extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  Chat({Key key, @required this.peerId ,@required this.peerAvatar}):super(key:key);
  @override
  _ChatState createState() => _ChatState(peerId: peerId,peerAvatar:peerAvatar);
}

class _ChatState extends State<Chat> {
  final String peerId;
  final String peerAvatar;
  final FocusNode _focusNode= FocusNode();
  _ChatState({Key key, @required this.peerId,@required this.peerAvatar});
  SharedPreferences _sharedPreferences;
  Firestore _firestore= Firestore.instance;
  TextEditingController _textEditingController = TextEditingController();
   final ScrollController listScrollController = new ScrollController();
 String id;
 File imageFile;
 String groupChatId;
 bool _isLoading=false, isSticker;

 @override
 void initState() {
   super.initState();
   _focusNode.addListener(onFocusChange);
 isSticker=false;
   readLocal();
 }

 onFocusChange () {
   if(_focusNode.hasFocus) {
    setState(() {
          isSticker=false;
        });
   }
 }

 readLocal() async {
_sharedPreferences= await SharedPreferences.getInstance();
 id = _sharedPreferences.getString('id');
 if(id.hashCode< peerId.hashCode) {
  groupChatId='$id-$peerId';
}
else {
  groupChatId='$peerId-$id';
}
setState(() {});

 }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
         backgroundColor: Colors.grey[350],
        appBar: AppBar(
           title: Text('Chat'),
        ),
         body: Stack(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                             image: AssetImage('images/chatter.jpeg'),
                              fit: BoxFit.cover,
                          ),
                      ),
                     
                  ),
                  Column(
                    children: <Widget>[
                       _buildMessage(),
                       (isSticker ? _buildSticker(): Container()),
                      _buildInput(),
                    ],),
                    _buildLoading()
                ],
         ),
      ),
    );
  }


Widget _buildSticker() {
  return Container(
     decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border( top: BorderSide( color: Colors.black26, width: 0.5))
     ),
     height: 180.0,
     padding: const EdgeInsets.all(10.0),
     child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: <Widget>[
                 FlatButton(
                    onPressed:()=> _sendMessage('mimi1', 2),
                    child: Image.asset('images/mimi1.gif', height: 50.0, width: 50.0, fit: BoxFit.cover,),
                 ),
                  FlatButton(
                    onPressed: ()=>_sendMessage('indian1', 2),
                    child: Image.asset('images/indian1.gif', height: 50.0, width: 50.0, fit: BoxFit.cover,),
                 ),
                  FlatButton(
                    onPressed: ()=>_sendMessage('mimi3', 2),
                    child: Image.asset('images/mimi3.gif', height: 50.0, width: 50.0, fit: BoxFit.cover,),
                 )
             ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: <Widget>[
                 FlatButton(
                    onPressed:()=> _sendMessage('mimi4', 2),
                    child: Image.asset('images/mimi4.gif', height: 50.0, width: 50.0, fit: BoxFit.cover,),
                 ),
                  FlatButton(
                    onPressed: ()=>_sendMessage('mimi5', 2),
                    child: Image.asset('images/mimi5.gif', height: 50.0, width: 50.0, fit: BoxFit.cover,),
                 ),
                  FlatButton(
                    onPressed:()=> _sendMessage('mimi6', 2),
                    child: Image.asset('images/mimi6.gif', height: 50.0, width: 50.0, fit: BoxFit.cover,),
                 )
             ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: <Widget>[
                 FlatButton(
                    onPressed: ()=>_sendMessage('mimi7', 2),
                    child: Image.asset('images/mimi7.gif', height: 50.0, width: 50.0, fit: BoxFit.cover,),
                 ),
                  FlatButton(
                    onPressed:()=> _sendMessage('mimi8', 2),
                    child: Image.asset('images/mimi8.gif', height: 50.0, width: 50.0, fit: BoxFit.cover,),
                 ),
                  FlatButton(
                    onPressed:()=> _sendMessage('mimi9', 2),
                    child: Image.asset('images/mimi9.gif', height: 50.0, width: 50.0, fit: BoxFit.cover,),
                 )
             ],
          )
        ],
     ),
  );
}

Widget _buildItemMessage (DocumentSnapshot document) {
   if(document['idFrom']==id) {
        return Container(
   child: Row(
     mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
            document['type']==0 ?
          Container(
             child: Text(document['content'],style: TextStyle( color: Colors.black)),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(bottom: 20.0, right: 10.0),
          )
          :document['type']==1 ? 
          Container(
            child: 
        Material(
           child: CachedNetworkImage(
              placeholder: Container(
                 child: CircularProgressIndicator(),
                 height: 200.0,
                 width: 200.0,
                 padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
              ),
               errorWidget: Container(
                    child: Image.asset('images/Flutter_01.jpeg'),
                     height: 200.0,
                     width: 200.0,
               ),
               imageUrl: document['content'],
               height: 200.0,
               width: 200.0,
               fit: BoxFit.cover,
           ),
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        margin: EdgeInsets.only(bottom: 20.0, right: 10.0),
          )
          : Container(
              margin: EdgeInsets.only(bottom: 20.0, right: 10.0),
            decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.all(Radius.circular(9.0)),
                border: Border.all( color: Colors.black26, width: 1.0),
            ),
                      child: new Image.asset(
                        'images/${document['content']}.gif',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
          )
       
         ],
   )
 );
   }
   else {
     //Peer Messages area
      return Container(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
                      children:<Widget>[ 
                        Material(
                           borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                           clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              placeholder: Container(
                                 child: CircularProgressIndicator(),
                                  width: 50.0,
                                  height: 50.0,
                                  padding: const EdgeInsets.all(10.0),
                              ),
                               imageUrl:peerAvatar,
                          height: 50.0,
                           width: 50.0,
                           fit: BoxFit.cover,
                            ) ,
                        ),
document['type']==0 ?
                        Container(
               child: Text(document['content'],style: TextStyle( color: Colors.white)),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0),
            )
            : document['type']==1 ? 
          Container(
            child: 
        Material(
           child: CachedNetworkImage(
              placeholder: Container(
                 child: CircularProgressIndicator(),
                 height: 200.0,
                 width: 200.0,
                 padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
              ),
               errorWidget: Container(
                    child: Text('IMage is not available'),
               ),
               imageUrl: document['content'],
               height: 200.0,
               width: 200.0,
               fit: BoxFit.cover,
           ),
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        margin: EdgeInsets.only(bottom: 20.0, right: 10.0),
          )
          : Container(
                      child: new Image.asset(
                        'images/${document['content']}.gif',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                        margin: EdgeInsets.only(bottom: 20.0, right: 10.0),
          )
                      ]
          ),
       
         ],
    // mainAxisAlignment: MainAxisAlignment.end,
   )
 );
   }
 
 }


 Widget _buildMessage() {
 return Flexible(
   child: groupChatId == ''
          ? Center(child: CircularProgressIndicator()) : StreamBuilder(
      stream: _firestore.collection('messages').document(groupChatId).collection(groupChatId).orderBy('timestamp', descending: true).limit(20).snapshots(),
     builder:(context, snapshot) {
       if(!snapshot.hasData) {
        return Center( child: CircularProgressIndicator());
       }
       else {
         return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => _buildItemMessage(snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
       }
     }),
 );
 }

 
_sendMessage(String content, int type) {
   if(content.trim()!='')
   { _textEditingController.clear();
     var documentReference=_firestore.collection('messages').document(groupChatId).collection(groupChatId).document(
       DateTime.now().millisecondsSinceEpoch.toString()
     );

     _firestore.runTransaction((transactionHandler) async {
   await transactionHandler.set(documentReference, {
         'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type

   });
     });
     setState(() {
            isSticker=false;
          });

      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
   }
   else {
     Fluttertoast.showToast(
       msg: 'Nothing to Send',
        gravity: ToastGravity.CENTER
     );
     
   }
 }


 _getImage() async {
   imageFile= await ImagePicker.pickImage(source:  ImageSource.gallery);
   if(imageFile!=null){
setState(() {
  _isLoading=true;
});
uploadFile();
   }
 }
 _getSticker() {
   _focusNode.unfocus();
   setState(() {
        isSticker=!isSticker;
      });
 }

Future uploadFile() async {
  String fileName= DateTime.now().millisecondsSinceEpoch.toString();
  StorageReference reference=FirebaseStorage.instance.ref().child(fileName);
  StorageUploadTask storageUploadTask=reference.putFile(imageFile);
  StorageTaskSnapshot storageTaskSnapshot=await storageUploadTask.onComplete;
  storageTaskSnapshot.ref.getDownloadURL().then((downLoadUrl) {
    setState(() {
          _isLoading=false;
        });
        _sendMessage(downLoadUrl, 1);
  }).catchError((e) {
    print(e);
    setState(() {
          _isLoading=false;
        });
        Fluttertoast.showToast(
          msg: 'Error In Uplaoding the image'
        );
  });
}

Widget _buildLoading () {
  return  Positioned(
     child: _isLoading ?
      Container(
        child: Center(child: CircularProgressIndicator(),
     ),
  ): Container()
  );
}

 Widget _buildInput() {
   return Container(
      color: Colors.white,
       child: Row(
         children: <Widget>[
            Material(
               child: Container(
                 margin: new EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                     icon: Icon(Icons.photo),
                      onPressed: _getImage,
                     color: Colors.black38,
                  ),
               ),
               
            ),
            Material(
               child: Container(
                 margin: new EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                     icon: Icon(Icons.face),
                      onPressed: _getSticker,
                     color: Colors.black38,
                  ),
               ),
               
            ),

            Flexible(
               child: TextField(
                  autofocus: true,
                   focusNode: _focusNode,
                  controller: _textEditingController,
                   decoration: InputDecoration.collapsed(
                      hintText: 'Enter Message',
                   ),
               ),
            ),
            Material(
               child:   Container(
                  child: IconButton(
                      icon: Icon(Icons.send),
                        onPressed: () => _sendMessage(_textEditingController.text, 0),
                  )
               ) ,
            )
       ],
      )
   );
 }
}
