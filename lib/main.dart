
import 'package:demo_app/bluetooth.dart';
import 'package:demo_app/page/adjust_page.dart';
import 'package:demo_app/page/style.dart';
import 'package:demo_app/page/timer.dart';
import 'package:demo_app/user_devices.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Signage',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
     /*home: MyHomePage( 
        serveraddress: '64.51.25.xs.21',
        servername: 'text',
      ),*/
    home: User_devices(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  final servername;
  final serveraddress;
  


  const MyHomePage({Key key, this.servername,this.serveraddress}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
static final clientID = 0;
  static final maxMessageLength = 4096 - 3;
  BluetoothConnection connection;
  int currentPage = 0;
  
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;
  GlobalKey bottomNavigationKey = GlobalKey();
 @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.serveraddress).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (
          isConnecting ? Text('Connecting chat to ' + widget.servername + '...') :
          isConnected ? Text('Live chat with ' + widget.servername) :
          Text('Chat log with ' + widget.servername)
        )
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
              iconData: Icons.adjust,
              title: "Adjust",
             ),
          TabData(
              iconData: Icons.style,
              title: "Style",
              ),
          TabData(
              iconData: Icons.timer,
              title: "Timer")
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[Text("Hello"), Text("World")],
        ),
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return Adjust_page(connection: connection,);
      case 1:
        return Style_Page(connection: connection,);
      default:
        return Timer_Page(connection: connection,);
    }
  }
}


class RGB_LED extends StatefulWidget {
  final servername;
  final serveraddress;
  


  const RGB_LED({Key key, this.servername,this.serveraddress}) : super(key: key);
  @override
  _RGB_LEDState createState() => _RGB_LEDState();
}

class _RGB_LEDState extends State<RGB_LED> {
static final clientID = 0;
  static final maxMessageLength = 4096 - 3;
  BluetoothConnection connection;
  int currentPage = 0;
  
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;
  GlobalKey bottomNavigationKey = GlobalKey();
 @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.serveraddress).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (
          isConnecting ? Text('Connecting chat to ' + widget.servername + '...') :
          isConnected ? Text('Live chat with ' + widget.servername) :
          Text('Chat log with ' + widget.servername)
        )
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          
          TabData(
              iconData: Icons.style,
              title: "Style",
              ),
          TabData(
              iconData: Icons.timer,
              title: "Timer")
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[Text("Hello"), Text("World")],
        ),
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
     
      case 0:
        return Style_Page(connection: connection,);
      default:
        return Timer_Page(connection: connection,);
    }
  }
}

