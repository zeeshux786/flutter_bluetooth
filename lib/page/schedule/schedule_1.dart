import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


List<String> on_aray = [''];
List<String> on_val = ['0'];

var off_aray = ['text'];
var off_val = [0];
class Schedule_1 extends StatefulWidget {
  final scaf;
  final connection;

  const Schedule_1({Key key, this.scaf,this.connection}) : super(key: key);
  @override
  _Schedule_1State createState() => _Schedule_1State();
}

class _Schedule_1State extends State<Schedule_1> {
   
  var _s_on = false;
  var _s_off = false;
  final format = DateFormat("HH:mm");
  var val = '';
  var times;
  void on_send() async{
    on_aray.forEach((f){
     if(f == 'MO'){
       val = '1';
     }else if(f == 'TU'){
      val = val + '2';
     }else if(f == 'WE'){
      val = val + '3';
     }else if(f == 'TH'){
      val = val +  '4';
     }else if(f == 'FR'){
      val = val +   '5';
     }else if(f == 'SA'){
      val = val +    '6';
     }else if(f == 'SU'){
        val = val +  '7';
     }
    });
     var t =val.padRight(7,'0');
      var send = 'so' + times+ t;
      
    widget.connection.output.add(utf8.encode(send));
        await widget.connection.output.allSent;
widget.scaf.currentState.showSnackBar(new SnackBar(content: new Text("Schedule On Request Send",textAlign: TextAlign.left,),duration: new Duration(seconds: 2),));
  on_aray.clear();
    val = '';
  send = '';
  t = '';
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
         child: Card(

           elevation: 5.0,
           child: new Column(
            children: <Widget>[
              Container(
                color: Colors.pink,
                 child: new ListTile(
                  title: new Text("Schedule ON",style: TextStyle(color: Colors.white),),
                ),
              ),
                new Container(
          
          child: Card(
            elevation: 3.0,
            child: ListTile(
              title: new Text("Schedule On"),
              trailing: new Container(
                width: 190.0,
                child: new Row(
                children: <Widget>[
                  FlatButton(
                child: new Text("Send",style: TextStyle(color: Colors.white),),
                color: Colors.pinkAccent,
                onPressed: (){
                   on_send();
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              FlatButton(
                child: new Text("Off",style: TextStyle(color: Colors.white),),
                color: Colors.pinkAccent,
                onPressed: () async{
                  var send = 'to';
                     widget.connection.output.add(utf8.encode(send));
        await widget.connection.output.allSent;
widget.scaf.currentState.showSnackBar(new SnackBar(content: new Text("Turn Off Request Send",textAlign: TextAlign.left,),duration: new Duration(seconds: 2),));
  
                },
              )
                ],
              ),
              )
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: new Container(
            
            child: Card(
              elevation: 3.0,
              child:  DateTimeField(
                decoration: InputDecoration(
                  labelText: 'Time',
          
                ),
          format: format,
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,

              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
          var  houra = time.hour;
          var mints = time.minute;
            var tim = houra.toString() +':'+ mints.toString().padLeft(2,'0');
           setState(() {
             times = tim;
           });
            return DateTimeField.convert(time);
          },
      ),
          ),
          ),
        ),
        new Container(
          child: Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.all(3.0),
                    child: new Text("Select Day"),
                  ),
                   new Container(
          height: 100.0,
          child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: new Text("Repeat"),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                   
                    GestureDetector(
                      onTap: (){
                         
                  var dat= on_aray.contains("MO");
                  if(dat){
                      widget.scaf.currentState.showSnackBar(new SnackBar(
                        duration: Duration(seconds: 1),
                        content: new Text("Already Exist"),
                      ));
                  }else{
               
                  //  on_val.add('1');
                         on_aray.add('MO'); 
                         setState(() {
                           
                         });
                        }
                      },
                      child: new CircleAvatar(
                        radius: 20.0,
                        child: Text("MO"),
                      ),
                    ),
                    new SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                      onTap: (){
                       var dat= on_aray.contains("TU");
                  if(dat){
                      widget.scaf.currentState.showSnackBar(new SnackBar(
                        duration: Duration(seconds: 1),
                        content: new Text("Already Exist"),
                      ));
                  }else{
                   //  on_val.add('2');
                         on_aray.add('TU'); 
                         setState(() {
                           
                         });
                        }
                      },
                      child: new CircleAvatar(
                        radius: 20.0,
                        child: Text("TU"),
                      ),
                    ),
                    new SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                      onTap: (){
                           var dat= on_aray.contains("WE");
                  if(dat){
                      widget.scaf.currentState.showSnackBar(new SnackBar(
                        duration: Duration(seconds: 1),
                        content: new Text("Already Exist"),
                      ));
                  }else{
                  //   on_val.add('3');
                         on_aray.add('WE'); 
                         setState(() {
                           
                         });
                        }
                      },
                      child: new CircleAvatar(
                        radius: 20.0,
                        child: Text("WE"),
                      ),
                    ),
                    new SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                       onTap: (){
                               var dat= on_aray.contains("TH");
                  if(dat){
                      widget.scaf.currentState.showSnackBar(new SnackBar(
                        duration: Duration(seconds: 1),
                        content: new Text("Already Exist"),
                      ));
                  }else{
                   //  on_val.add('4');
                         on_aray.add('TH'); 
                         setState(() {
                           
                         });
                        }
                       },
                      child: new CircleAvatar(
                        radius: 20.0,
                        child: Text("TH"),
                      ),
                    ),
                    new SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                       onTap: (){
                                    var dat= on_aray.contains("FR");
                  if(dat){
                      widget.scaf.currentState.showSnackBar(new SnackBar(
                        duration: Duration(seconds: 1),
                        content: new Text("Already Exist"),
                      ));
                  }else{
                  //   on_val.add('5');
                         on_aray.add('FR'); 
                         setState(() {
                           
                         });
                        }
                       },
                      child: new CircleAvatar(
                        radius: 20.0,
                        child: Text("FR"),
                      ),
                    ),
                    new SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                       onTap: (){
                                    var dat= on_aray.contains("SA");
                  if(dat){
                      widget.scaf.currentState.showSnackBar(new SnackBar(
                        duration: Duration(seconds: 1),
                        content: new Text("Already Exist"),
                      ));
                  }else{
                    // on_val.add('6');
                         on_aray.add('SA'); 
                         setState(() {
                           
                         });
                        }
                       },
                      child: new CircleAvatar(
                        radius: 20.0,
                        child: Text("SA"),
                      ),
                    ),
                    new SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                       onTap: (){
                                    var dat= on_aray.contains("SU");
                  if(dat){
                      widget.scaf.currentState.showSnackBar(new SnackBar(
                        duration: Duration(seconds: 1),
                        content: new Text("Already Exist"),
                      ));
                  }else{
                  //   on_val.add('7');
                         on_aray.add('SU'); 
                         setState(() {
                           
                         });
                        }
                       },
                      child: new CircleAvatar(
                        radius: 20.0,
                        child: Text("SU"),
                      ),
                    ),
                    
                  ],
                ),
              )
          ),
        ),
        new Container(
          height: 80.0,
          width: MediaQuery.of(context).size.width,
          child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: on_aray.length,
                  itemBuilder: (context,l){
                    print(on_aray.length);
                    return l == 0 ?  Container(
                      width: 80.0,
                      child: new Row(
                        children: <Widget>[
                          
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new Text("Selected"),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                   
                   ],
                  ),
                ) :  Container(
                  width: 60.0,
                      child: new Row(
                        children: <Widget>[
                   
                    GestureDetector(
                      onTap: (){
                     // on_val.remove(l.toString());
                        on_aray.remove(on_aray[l]);
                       var ok =  on_val.remove(l);
                        print(ok);
                        setState(() {
                          
                        });
                      },
                      child: new CircleAvatar(
                        radius: 20.0,
                        child: Text(on_aray[l]),
                      ),
                    ),
                    new SizedBox(
                      width: 5.0,
                    ),
                   ],
                  ),
                );
                  },
                )
              )
          ),
        ),

        
                ],
              ),
            ),
          ),
        ),
        new SizedBox(
          height: 10.0,
        )
            ],
          ),
                  ),
        );
  }
}