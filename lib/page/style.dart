import 'package:flutter/material.dart';
import 'dart:convert';

class Style_Page extends StatefulWidget {
  final connection;

  const Style_Page({Key key, this.connection}) : super(key: key);
  @override
  _Style_PageState createState() => _Style_PageState();
}

class _Style_PageState extends State<Style_Page> {
   var _scaffoldKey = new GlobalKey<ScaffoldState>(); 
  var send =false;
  var _lowerValue = 0.0;
  var _brightness = 0.0;
  var color_s = ["Static","Blink","Buzz","Drown","Heart Beat"];

var color_c = ["p1","p2","p3","p4","p5"];
void onn() async{
        widget.connection.output.add(utf8.encode('p'.toString()));
        await widget.connection.output.allSent;
_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Turn on successfully",textAlign: TextAlign.right,),duration: new Duration(seconds: 2),));
  }
  void off()async{
    widget.connection.output.add(utf8.encode('p0'.toString()));
        await widget.connection.output.allSent;
_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Turn Off successfully",textAlign: TextAlign.right,),duration: new Duration(seconds: 2),));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: new ListView(
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text("On / Off"),
                 ),
                
               new Container(
                 child: new Row(
                   children: <Widget>[
                      RaisedButton(
                  child: new Text("On",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    onn();
                  },
                color: Colors.black,
                ),
                SizedBox(
                  width: 10.0,
                ),
                RaisedButton(
                   child: new Text("OFF",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                  off();
                  },
                   color: Colors.pinkAccent,
                ),
                SizedBox(
                  width: 10.0,
                ),
                   ],
                 ),
               )
               ],
           ),
            ),
         Container(
           color: Colors.white,
             child: new ListView.builder(
             shrinkWrap: true,
             physics: ClampingScrollPhysics(),
             itemCount: color_s.length,
             itemBuilder: (context,l){
               return new ListTile(
                 title: new Text(color_s[l]),
                 trailing: RaisedButton(
                  color: Colors.white,
                   child: new Text("send"),

                   onPressed: () async{
                     
                  widget.connection.output.add(utf8.encode(color_c[l].toString()));
        await widget.connection.output.allSent;
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Send color"),
        ));
                     print(color_c[l]);
                   },
                 ),
               );
             },
           ),
         ),
            new Container(
          
          child: Card(
            elevation: 3.0,
            child:  Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new Text("Speed  / Intensity "+_lowerValue.toStringAsFixed(2)),
                    ),
                     Slider(
                    activeColor: Colors.indigoAccent,
                    min: 0.0,
                    max: 5.0,
                    divisions: 5,
                    onChangeEnd: (newRating){
                        var y ='y'+newRating.toString();
                      sl(y);
                    },
                    onChanged: (newRating) {
                      setState(() => _lowerValue = newRating);
                     
                    },
                    value: _lowerValue,
                  ),
               
                  ],
            )
          ),
        ),
        
        new SizedBox(
          height: 20.0,
        )
        ],
      ),
      
    );
  }
  void sl(id)async{
        widget.connection.output.add(utf8.encode(id.toString()));
          await widget.connection.output.allSent;
}
}