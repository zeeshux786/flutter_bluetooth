import 'package:demo_app/color_json/color.dart';
import 'package:demo_app/components/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:convert';
var colors_value = ['test',Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFF0000FF), Color(0xFFFFFF00), Color(0xFF00FFFF),Color(0xFFFF00FF),Color(0xFFFFFFFF)];
var Color_names = ['clasic','255,000,000', '000,255,000', '000,000,255', '255,255,000', '000,255,255', '255,000,255', '255,255,255'];
class Adjust_page extends StatefulWidget {
  final connection;

  const Adjust_page({Key key, this.connection}) : super(key: key);
  @override
  _Adjust_pageState createState() => _Adjust_pageState();
}

class _Adjust_pageState extends State<Adjust_page> {
    var _scaffoldKey = new GlobalKey<ScaffoldState>(); 
  final double dogAvatarSize = 150.0;
  Color currentColor = Color(0xffff0000);
  // This is the starting value of the slider.
  double _sliderValue = 0.0;
  bool _switch = true;
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
          body: new Column(
          children: <Widget>[
           Padding(
             padding: const EdgeInsets.all(5.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 IconButton(
                  icon: Icon(Icons.color_lens,size: 40.0,
                  color: Colors.yellowAccent,),
                  onPressed: (){
                    pick_color(context);
                  },
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
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 5.0,
              child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                CircleColorPicker(
                  radius: 70.0,
                  thumbRadius: 10,
                  colorListener: (int value) {
                    setState(() {
                      currentColor = Color(value);
                    });
                  },
                ),
                SizedBox(height: 20),
                BarColorPicker(
                  width: 300,
                  thumbColor: Colors.white,
                  cornerRadius: 10,
                  pickMode: PickMode.Color,
                  colorListener: (int value) {
                    setState(() {
                      currentColor = Color(value);
                    });
                  }),
                SizedBox(height: 20),
                BarColorPicker(
                  cornerRadius: 10,
                  pickMode: PickMode.Grey,
                  colorListener: (int value) {
                    setState(() {
                      currentColor = Color(value);
                    });
                  }),
                SizedBox(height: 20),
                RaisedButton(
                  onPressed: () async{
                    var r = currentColor.red.toString().padLeft(3, '0');
                    var g = currentColor.green.toString().padLeft(3, '0');
                    var b = currentColor.blue.toString().padLeft(3, '0');
                    
                    
                
                    var reg_color = 'c1'+ r.toString() +','+ g.toString() +','+ b.toString();
             
                    widget.connection.output.add(utf8.encode(reg_color.toString()));
          await widget.connection.output.allSent;
           _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Send color"),
          ));
                 
              },
                  color: currentColor,
                  child: Text('Send',style: TextStyle(
                    color: Colors.white
                  ),),
                ),
                new SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
            ),
          new Container(
            
            child: Card(
              elevation: 3.0,
              child: Column(
               children: <Widget>[
                 new Padding(
                      padding: EdgeInsets.only(top: 3.0),
                      child: new Text("Intensity ${_sliderValue}"),
                    ),
                   
                  Slider(
                      activeColor: Colors.indigoAccent,
                      onChangeEnd: (val){
                        var e ='z'+val.toString();
                        sl(e);
                      },
                      min: 0.0,
                      max: 5.0,
                      divisions: 5,
                      onChanged: (newRating) {
                        setState(() => _sliderValue = newRating);
                      
                      },
                      value: _sliderValue,
                    ),
               ],
              ),
            ),
          ),
           Container(
          
          height: 70.0,
          child: Card(
            elevation: 3.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context,k){
                
                 return Container(
                   child: k == 0 ? new Padding(
                            padding: EdgeInsets.only(top:25.0,left: 10.0),
                            child: new Text("Classic",style: TextStyle(fontWeight: FontWeight.bold),),
                          ) : 
                          k  == 7 ? 
                          GestureDetector(
                            onTap: () async{
                           var reg = 'c2' + Color_names[k];
               widget.connection.output.add(utf8.encode(reg.toString()));
          await widget.connection.output.allSent;
           _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Send color"),
          ));
                            },
                            child: Container(
                          margin: EdgeInsets.all(5.0),
                          width: 50.0,
                          height: 20.0,
                          child: new Card(
                            elevation: 3.0,
                            color: Colors.white,
                        
                          ),
                        ),
                          )
                          :
                           GestureDetector(
                            onTap: () async{
                           var reg = 'c2' + Color_names[k];
               widget.connection.output.add(utf8.encode(reg.toString()));
          await widget.connection.output.allSent;
           _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Send color"),
          ));
                            },
                            child: Container(
                          margin: EdgeInsets.all(5.0),
                          width: 50.0,
                          height: 20.0,
                          child: new Card(
                            color:colors_value[k],
                          
                          ),
                        ),
                          )
                 );
              },
              ),
          )),
          
          ],
        ),
    );
  }
 Color pickerColor = Color(0xff443a49);


// ValueChanged<Color> callback
void changeColor(Color color) {
  setState(() => pickerColor = color);
}
void pick_color(context){
  showDialog(
    context: context,
    child: AlertDialog(
    title: const Text('Pick a color!'),
    content: SingleChildScrollView(
      child: ColorPicker(
        pickerColor: pickerColor,
        onColorChanged: changeColor,
        //enableLabel: true,
        pickerAreaHeightPercent: 0.8,
       // enableAlpha: true,
      ),
      // Use Material color picker:
      //
      // child: MaterialPicker(
      //   pickerColor: pickerColor,
      //   onColorChanged: changeColor,
      //   enableLabel: true, // only on portrait mode
      // ),
      //
      // Use Block color picker:
      //
      // child: BlockPicker(
      //   pickerColor: currentColor,
      //   onColorChanged: changeColor,
      // ),
    ),
    actions: <Widget>[
      FlatButton(
        child: const Text('Got it'),
        onPressed: () {
          setState(() => currentColor = pickerColor);
          Navigator.of(context).pop();
        },
      ),
    ],
  ),

  );
}
void sl(id)async{
        widget.connection.output.add(utf8.encode(id.toString()));
          await widget.connection.output.allSent;
}
}