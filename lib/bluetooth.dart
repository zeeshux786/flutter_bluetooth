import 'dart:async';
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'database.dart';
import 'main.dart';
import 'test.dart';
  var dropdownValue = 'Static Signage';
class Bluetooth_page extends StatefulWidget {
  @override
  _Bluetooth_pageState createState() => _Bluetooth_pageState();
}

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class _Bluetooth_pageState extends State<Bluetooth_page> {
   List<_DeviceWithAvailability> devices = List<_DeviceWithAvailability>();

  // Availability
  StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
  bool _isDiscovering;

  _Bluetooth_pageState();
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;
  var checkAvailability = false;
  BackgroundCollectingTask _collectingTask;
  
  @override
  void initState() {
    super.initState();
    _isDiscovering = checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    // Setup a list of the bonded devices
    FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices.map(        
          (device) => _DeviceWithAvailability(device, checkAvailability ? _DeviceAvailability.maybe : _DeviceAvailability.yes)
        ).toList();
      });
    });
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() { _bluetoothState = state; });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() { _address = address; });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() { _name = name; });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }
  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var _device = i.current;
          if (_device.device == r.device) {
              _device.availability = _DeviceAvailability.yes;
              _device.rssi = r.rssi;
          }
        }
      });
    });
    
    _discoveryStreamSubscription.onDone(() {
      setState(() { _isDiscovering = false; });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  bool _autoAcceptPairingRequests = false;

  @override
  Widget build(BuildContext context) {
    
    List<BluetoothDeviceListEntry> list = devices.map((_device) => BluetoothDeviceListEntry(
      device: _device.device,
      rssi: _device.rssi,
      enabled: _device.availability == _DeviceAvailability.yes,
      onTap: () {
           showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: DropDw(),
          
         
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
                insert(_device.device.name,_device.device.address,dropdownValue.toString());
              },
            ),
          ],
        );
      },
    );
    
     
        //Navigator.of(context).pop(_device.device);
       /* showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              title: new Text("waiting for connecting...."),
              content: Container(
            height: 200.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
            );
          },
        
        );*/
      },
      onLongPress: (){},
    )).toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _restartDiscovery,
        child:   _isDiscovering ? 
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
            : Icon(Icons.refresh)
      ),
      appBar: new AppBar(
        title: new Text("Bluetooth turn on"),
        
      ),
      body:new ListView(
        children: <Widget>[
          Container(
            child: Card(
              child: SwitchListTile(
                title: const Text('Enable Bluetooth'),
                value: _bluetoothState.isEnabled,
                onChanged: (bool value) {
                  // Do the request and update with the true value then
                  future() async { // async lambda seems to not working
                    if (value)
                      await FlutterBluetoothSerial.instance.requestEnable();
                    else
                      await FlutterBluetoothSerial.instance.requestDisable();
                  }
                  future().then((_) {
                    setState(() {});
                  });
                },
              ),
            )
          ),
          new ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: list,
          )
        ],
      )
    );
  }
  
 BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;
void connecting(server) {

  
   /*  BluetoothConnection.toAddress(server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

     
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });*/
}
}




class DataSample {
  double temperature1;
  double temperature2;
  double waterpHlevel;
  DateTime timestamp;

  DataSample({this.temperature1, this.temperature2, this.waterpHlevel, this.timestamp});
}

class BackgroundCollectingTask extends Model
{
  static BackgroundCollectingTask of(BuildContext context, {bool rebuildOnChange = false}) =>
      ScopedModel.of<BackgroundCollectingTask>(context, rebuildOnChange: rebuildOnChange);
  
  final BluetoothConnection _connection;
  List<int> _buffer = List<int>();

  // @TODO , Such sample collection in real code should be delegated 
  // (via `Stream<DataSample>` preferably) and then saved for later
  // displaying on chart (or even stright prepare for displaying).
  List<DataSample> samples = List<DataSample>(); // @TODO ? should be shrinked at some point, endless colleting data would cause memory shortage.

  bool inProgress;

  BackgroundCollectingTask._fromConnection(this._connection) {
    _connection.input.listen((data) {
      _buffer += data;

      while (true) {
        // If there is a sample, and it is full sent
        int index = _buffer.indexOf('t'.codeUnitAt(0));
        if (index >= 0 && _buffer.length - index >= 7) {
          final DataSample sample = DataSample(
            temperature1: (_buffer[index + 1] + _buffer[index + 2] / 100),
            temperature2: (_buffer[index + 3] + _buffer[index + 4] / 100),
            waterpHlevel: (_buffer[index + 5] + _buffer[index + 6] / 100),
            timestamp: DateTime.now()
          );
          _buffer.removeRange(0, index + 7);

          samples.add(sample);
          notifyListeners(); // Note: It shouldn't be invoked very often - in this example data comes at every second, but if there would be more data, it should update (including repaint of graphs) in some fixed interval instead of after every sample.
          //print("${sample.timestamp.toString()} -> ${sample.temperature1} / ${sample.temperature2}");
        }
        // Otherwise break
        else {
          break;
        }
      }
    }).onDone(() {
      inProgress = false;
      notifyListeners();
    });
  }

  static Future<BackgroundCollectingTask> connect(BluetoothDevice server) async {
    final BluetoothConnection connection = await BluetoothConnection.toAddress(server.address);
    return BackgroundCollectingTask._fromConnection(connection);
  }

  void dispose() {
    _connection.dispose();
  }

  Future<void> start() async {
    inProgress = true;
    _buffer.clear();
    samples.clear();
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Future<void> cancel() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.finish();
  }

  Future<void> pause() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.output.allSent;
  }

  Future<void> reasume() async {
    inProgress = true;
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Iterable<DataSample> getLastOf(Duration duration) {
    DateTime startingTime = DateTime.now().subtract(duration);
    int i = samples.length;
    do {
      i -= 1;
      if (i <= 0) {
        break;
      }
    }
    while (samples[i].timestamp.isAfter(startingTime));
    return samples.getRange(i, samples.length);
  }
}

class DropDw extends StatefulWidget {
  @override
  _DropDwState createState() => _DropDwState();
}

class _DropDwState extends State<DropDw> {
  @override
  Widget build(BuildContext context) {
    return   DropdownButton<String>(
        value: dropdownValue,
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          color: Colors.deepPurple
        ),
       
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
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
          );
  }
}