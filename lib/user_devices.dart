import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'bluetooth.dart';
import 'database.dart';
import 'main.dart';

class User_devices extends StatefulWidget {
  @override
  _User_devicesState createState() => _User_devicesState();
}

class _User_devicesState extends State<User_devices> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =  new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    // TODO: implement initState
    database_create();
    super.initState();
     WidgetsBinding.instance
      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Bluetooth"),
      ),
     
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
      child: new ListView(
        children: <Widget>[
          Card(
              child: new ListTile(
              onTap: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Bluetooth_page()));
              },
              title: new Text("Paired Devices Select"),
            ),
          ),
          new Container(
            padding: EdgeInsets.all(20.0),
            child: new Text("Select Devices"),
          ),
          FutureBuilder(
            future: _refresh(),
            builder: (context, projectSnap) {
               if(!projectSnap.hasData)
               return Center(
                 child: new Text("No data Found"),
               );
              return new ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: projectSnap.data.length,
                itemBuilder: (context,k){
                  var condition =  projectSnap.data[k]['rssi'];
                  return new ListTile(
                    title: new Text(projectSnap.data[k]['name']+" (${condition})"),
                    subtitle: new Text(projectSnap.data[k]['mac_address']),
                    trailing: new FlatButton(
                      child: new Text("Delete",style: TextStyle(color: Colors.white),),
                      color: Colors.red,
                      onPressed: (){
                        delete(projectSnap.data[k]['id']);
                        setState(() {
                          
                        });
                      },
                    ),
                    onLongPress: (){
                       showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: DropDws(
            data: condition,
            name: projectSnap.data[k]['name'],
          ),
          
         
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
             new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Save"),
              onPressed: () {
               update(projectSnap.data[k]['id'],_text.text,dropdownValues);
               setState(() {
                 
               });
               // insert(_device.device.name,_device.device.address,dropdownValue.toString());
              },
            ),
          ],
        );
      },
    );
                    },
                    onTap: (){
                      projectSnap.data[k]['rssi'] == "RGB Signage"
                      ? 
                        Navigator.push(context, PageTransition(type: PageTransitionType.fade,child: MyHomePage(
                        serveraddress: projectSnap.data[k]['mac_address'],
                        servername: projectSnap.data[k]['name']
                        
                      )))
                      :
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade,child: RGB_LED(
                        serveraddress: projectSnap.data[k]['mac_address'],
                        servername: projectSnap.data[k]['name']
                        
                      )));
                    },
                  );
                },
              );
            }
          )
        ],
      ),
    ),
    );
  }
    Future<List> _refresh() async{
    await new Future.delayed(new Duration(seconds: 3));
    
    return read();
   
  }
  void refr(){
    setState(() {
      
    });
  }
}

  var dropdownValues;
  TextEditingController _text = TextEditingController();
class DropDws extends StatefulWidget {
  final data;
  final name;
  const DropDws({Key key, this.data,this.name}) : super(key: key);
  @override
  _DropDwsState createState() => _DropDwsState();
}

class _DropDwsState extends State<DropDws> {

  @override
  void initState() {
    // TODO: implement initState
  setState(() {
   dropdownValues = widget.data; 
   _text.text = widget.name;
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   Container(
      height: 95.0,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _text,
            decoration: InputDecoration(
              hintText: 'Name'
            ),
          ),
          DropdownButton<String>(
          hint: Text("data"),
          value: dropdownValues,
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            color: Colors.black
          ),
         
          onChanged: (String newValue) {
            setState(() {
              dropdownValues = newValue;
            });
          },
          items: <String>['Static Signage', 'RGB Signage']
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toList(),
            )
        ],
      ),
    );
  }
}