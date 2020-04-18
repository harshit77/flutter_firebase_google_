import 'package:flutter/material.dart';


class FutureMessages extends StatefulWidget {
  @override
  _FutureMessagesState createState() => _FutureMessagesState();
}

class _FutureMessagesState extends State<FutureMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('Future Message'),
       ),
       body: _MainFutureConatiner(context),
    );
  }
}

class _MainFutureConatiner extends StatefulWidget {
BuildContext context;
_MainFutureConatiner(this.context);
  @override
  __MainFutureConatinerState createState() => __MainFutureConatinerState(context);
}

class __MainFutureConatinerState extends State<_MainFutureConatiner> {
  BuildContext context;
  Size size;
__MainFutureConatinerState(BuildContext context) {
  this.context=context;
  size=MediaQuery.of(context).size;

}
  PageController pageController= PageController( viewportFraction: 0.8, initialPage: 1);
  List<bool> _list=[false,false,false];
  bool _openBottomSheet=false;
   double height;
  final List<String> images= <String>[
    'images/bg_messages.png',
       'images/IMG_9222.JPG',
      'images/chatter.jpg'];
  @override
  Widget build(BuildContext context) {
   return Stack(
    children: <Widget>[
 Container(
   child: SizedBox.fromSize(
      size: Size.fromHeight( MediaQuery.of(context).size.height),
       child: PageView.builder(
           onPageChanged: (int page) {
             print(page);
           }, 
          controller: pageController,
          itemCount: images.length,
           itemBuilder:(BuildContext context, int index) {
             return Padding(
                padding:const EdgeInsets.symmetric( vertical: 10.0, horizontal: 10.0),
                 child: Material(
   elevation: 5.0,
    borderRadius: BorderRadius.circular(8.0),
    child: Stack(
       fit:StackFit.expand,
          children: <Widget>[
             Image.asset(images[index],fit: BoxFit.cover,),
            Positioned(
               right: 4.0,
               top: 3.0,
               child: IconButton(
                  onPressed: () {
                    
                 setState(() {
                   _list[index]=!_list[index];
                   _openBottomSheet=!_openBottomSheet;
                    }); 
                  },
                  icon: Icon(_list[index]==true ?  Icons.check_circle :Icons.check_box_outline_blank),
               ),
              )
          ],
    ),
                 ),
             );
           },
       ),
   ),
   ),
   _openBottomSheet!=true?  Container() :Positioned(
      left: 0,
       right: 0,
      child: GestureDetector(
//          onPanDown: (e) {
//            print("SEETING hEIGHT ${e.globalPosition.dy}");
//            setState((){
// height=size.height-e.globalPosition.dy;
//            });
//          }
//          ,
//          onPanUpdate: (e){
//               setState((){
// height=size.height-e.globalPosition.dy;
//            });
//            print(e.globalPosition.dy);},
//          onPanEnd: (e)=>print(e.velocity.pixelsPerSecond),
//          onVerticalDragDown: (e) {
//            print(e);
//          },
//          onVerticalDragEnd:( e) {
//  print(e);
//          },
//           onVerticalDragUpdate: (e) => print(e),
//          onVerticalDragStart: (e) =>print(e),
              child: Container(
              
 child: Column(
         children: <Widget>[
            Flexible(
 child: Container(
     color: Colors.red,
 ),
            ),
           Row(
               children: <Widget>[
                 Material(
               child: Container(
                 margin: new EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                     icon: Icon(Icons.photo),
                      onPressed: null,
                     color: Colors.black38,
                  ),
               ),
               
            ),
            Material(
               child: Container(
                 margin: new EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                     icon: Icon(Icons.face),
                      onPressed:null,
                     color: Colors.black38,
                  ),
               ),
               
            ),

            Flexible(
               child: TextField(
                  autofocus: true,
                   decoration: InputDecoration.collapsed(
                      hintText: 'Enter Message',
                   ),
               ),
            ),
            Material(
               child:   Container(
                  child: IconButton(
                      icon: Icon(Icons.send),
                        onPressed: null,
                  )
               ) ,
            )
               ],
            )
            
       ],
      ),
           // child: Text("DVfsvs"),
          
              height: _openBottomSheet==true ?  400.0 : null, 
             decoration: BoxDecoration(
                color: Colors.white,
                 borderRadius: BorderRadius.only( topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))
             ),
        ),
      ),
         bottom:0,
   )


    ],
 );
  }
}
