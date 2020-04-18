import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _username= TextEditingController();
  TextEditingController _aboutme= TextEditingController();

SharedPreferences _sharedPreferences;
String id='',nickname='',aboutMe='',photoUrl='',allAboutMe='';
@override
  void initState() {
    super.initState();
    readLocal();
  }

  readLocal() async{
_sharedPreferences= await SharedPreferences.getInstance();
id= _sharedPreferences.getString('id') ?? '';
nickname= _sharedPreferences.getString('nickname') ?? '';
aboutMe= _sharedPreferences.getString('aboutMe') ?? '';
photoUrl= _sharedPreferences.getString('photoUrl') ?? '';
allAboutMe=_sharedPreferences.getString('allAboutMes') ?? '';
print(photoUrl);
setState(() {
});
  }



Future<Null> _handleUpdate() async {
  print('InSide handleUpdate');
  Firestore.instance.collection('users').document(id).updateData(
    {'nickname':nickname,
     'aboutMe': aboutMe
    }
  ).then((data) async{
  await _sharedPreferences.setString('nickname', nickname);
  if(allAboutMe=='') {
     allAboutMe=aboutMe;
  }
  else {
allAboutMe=allAboutMe+',' +aboutMe;
  }
  
  print('allAboutMe');
   await _sharedPreferences.setString('aboutMe', aboutMe);
   await _sharedPreferences.setString('allAboutme',allAboutMe );
 Fluttertoast.showToast(
     msg: 'Uploaded Successfully'
   );
   setState(() {
      });

  }).catchError((e){
   Fluttertoast.showToast(
     msg: 'Fail to Upload'
   );
  });
}

Widget _buildItem () {
    return CustomScrollView(
       
  slivers: <Widget>[ 
     SliverAppBar(
        expandedHeight: 350.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          background:  Material(
             child: CachedNetworkImage(
                imageUrl: photoUrl,
                 fit:BoxFit.cover,
                 placeholder: Container(
                    child:  Center(
                      child: CircularProgressIndicator(
                         strokeWidth: 1.0,
                      ),
                       heightFactor: 20.0,
                       widthFactor: 20.0,
                    ),
                     height: 10,
                     width: 10,
                 ),
             ),
          ),
          centerTitle: false,
            title: Text(nickname),
        ),
     ),
    SliverList(
       delegate:  SliverChildListDelegate(
         [
           _buildField(),
           Container(
             margin: const EdgeInsets.only( bottom: 10.0,left:10.0 ),
              child: Text("Previously Uploaded Photos", style: TextStyle(fontWeight: FontWeight.bold),),
           )
         ]
       )
    ),

    SliverGrid.count(
      mainAxisSpacing: 1,
      crossAxisCount: 2,
       childAspectRatio: 1,
       crossAxisSpacing: 1,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only( bottom: 10.0,left:10.0 ),
             decoration: BoxDecoration(
                border: Border.all( color: Colors.black12, width: 1.0)
             ),
  child:Hero(
     tag: 'dash',
      child: FlatButton(
         child: Image.asset('images/IMG_9222.JPG'),
          onPressed: (){
           Navigator.push(context,  MaterialPageRoute(
                          builder: (BuildContext context) {
                        return  NewPage();
                          }));
             }
      ),
     )
),
          Container(
            margin: const EdgeInsets.only( bottom: 10.0,right:10.0 ),
              decoration: BoxDecoration(
                border: Border.all( color: Colors.black12, width: 1.0)
             ),
  child:Hero(
     tag: 'dash3',
      child: FlatButton(
         child: Image.asset('images/chatter.jpeg'),
          onPressed: (){
           Navigator.push(context,  MaterialPageRoute(
                          builder: (BuildContext context) {
                        return  NewPage();
                          }));
             }
      ),
     )
),
          Container(
  child:Hero(
     tag: 'dash2',
      child: FlatButton(
         child: Image.asset('images/chatter.jpg'),
          onPressed: (){
           Navigator.push(context,  MaterialPageRoute(
                          builder: (BuildContext context) {
                        return  NewPage();
                          }));
             }
      ),
     )
),
          
        ],
    )
     
    //  SliverGrid(
    //       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //         maxCrossAxisExtent: 200.0,
    //          crossAxisSpacing: 10.0,
    //          mainAxisSpacing: 10.0
    //       ),
    //       delegate: SliverChildBuilderDelegate((BuildContext context,int index)=> Container( color: Colors.purple[ 100 * (index % 9)],   child: Text('${index}'),),childCount: 20),
    //  )
  ], 
    );
}

Widget _buildField() {
  print('vdsfbjvjkdfsbjvk ${allAboutMe}');
  return Container(
     margin: const EdgeInsets.only(top: 20.0),
     child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          //Nickname
          Container(
             child: Text('Nickname',style:  TextStyle( fontWeight: FontWeight.bold),),
         margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
         alignment: Alignment.topLeft,
          ),
          Container(
             child: TextField(
                autofocus: true,
                 controller: _username,
                 onChanged: (value) {
                    nickname=value;
                 },
                  decoration: InputDecoration(
                     hintText: nickname,
                     contentPadding: new EdgeInsets.all(5.0),
                          hintStyle: TextStyle( color:  Colors.grey[300]),
                  ),
             ),
              margin: EdgeInsets.only( left: 30, right: 30.0),
          ),
          //Nickname
          //Aboutme
          Container( child: Text('Status',style:  TextStyle( fontWeight: FontWeight.bold),),
          margin: const EdgeInsets.all(10.0),
          alignment: Alignment.topLeft,
          ),
          Container(
             child: TextField(
                autofocus: true,
                 controller: _aboutme,
                 onChanged: (value) {
                   aboutMe=value;
                 },
                  decoration: InputDecoration(
                     hintText: aboutMe,
                     contentPadding: new EdgeInsets.all(5.0),
                          hintStyle: TextStyle( color:  Colors.grey[300]),
                  ),
             ),
              margin: EdgeInsets.only( left: 30, right: 30.0),
          ),
          //Aboutme
//Button
          Container(
                child: FlatButton(
                  onPressed: _handleUpdate,
                  child: Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Colors.redAccent,
                  highlightColor: new Color(0xff8d93a0),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                 margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
          ),
 
      allAboutMe=='' ? Container() :Container(
        child: Column(
             children:allAboutMe.split(',').map((data)=>ListTile(
                title: Text(data),
                 subtitle: Text('Tap To update Title'),
                 trailing: Icon(Icons.update),
             )).toList(),
        )
      )
          //Button
        ],
     ),

  );
}

  @override
  Widget build(BuildContext context) {
  return photoUrl !='' ? Container(
     child: Material(child: _buildItem()),
  ):Container();
  }
}



class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('Expanded View'),
      ),
          body: Center(
                      child: Container(
         child:Hero(
       tag: 'dash',
        child: Image.asset('images/IMG_9222.JPG')
       )
        
      ),
          ),
    );
  }
}
