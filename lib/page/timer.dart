import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:demo_app/page/schedule/schedule_1.dart';
import 'package:demo_app/page/schedule/schedule_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

List<String> on_aray = [''];
List<String> on_val = ['0'];

var off_aray = ['text'];
var off_val = [0];


class Timer_Page extends StatefulWidget {
  final connection;

  const Timer_Page({Key key, this.connection}) : super(key: key);

  @override
  _Timer_PageState createState() => _Timer_PageState();
}

class _Timer_PageState extends State<Timer_Page> {
  final _scaf = GlobalKey<ScaffoldState>();
  var _s_on = false;
  var _s_off = false;
  final format = DateFormat("HH:mm");
  var val = '';
  void on_send(){
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     key: _scaf,
      body: new ListView(
        children: <Widget>[
       Schedule_1(scaf: _scaf,connection: widget.connection),
       Schedule_2(scaf: _scaf,connection: widget.connection),
        ],
      ),
    );
  }
}