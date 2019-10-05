import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
void database_create() async {
// Get a location using getDatabasesPath
var databasesPath = await getDatabasesPath();
String path = join(databasesPath, 'database.db');


// open the database
Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
  // When creating the db, create the table
  await db.execute(
      'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, bluetooth_name TEXT, mac_address TEXT, rssi TEXT)');
      
});

print(database);
}

void insert(name,address,condition) async{

var databasesPath = await getDatabasesPath();
String path = join(databasesPath, 'database.db');


Database database = await openDatabase(path, version: 1);

print(name);
print(address);

 // Insert some records in a transaction
 List projetcList = await database.rawQuery('SELECT * FROM Test WHERE mac_address = "${address}"');
  
if(projetcList.length == 1){
Fluttertoast.showToast(
        msg: "Aleady Added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
}else{
await database.transaction((txn) async {
  
  int id1 = await txn.rawInsert(
      'INSERT INTO Test(name, bluetooth_name, mac_address, rssi) VALUES("${name}", "${name}", "${address}", "${condition}" )');
     /* .then((onValue){
        print(onValue.toString());
      }).catchError((onError){
        print(onError.toString());

      });*/
  print('inserted1: $id1');
  Fluttertoast.showToast(
        msg: "Successfully Added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  
});
}

}

void delete(id) async{
  
var databasesPath = await getDatabasesPath();
String path = join(databasesPath, 'database.db');


Database database = await openDatabase(path, version: 1);


  await database
    .rawDelete('DELETE FROM Test WHERE id = "${id}"').then((onValue){
      Fluttertoast.showToast(
        msg: "Deleted Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }).catchError((onError){
      Fluttertoast.showToast(
        msg: "Something Went To Wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    });

}

Future<List> read() async {
    var databasesPath = await getDatabasesPath();
String path = join(databasesPath, 'database.db');


Database database = await openDatabase(path, version: 1);
  List projetcList = await database.rawQuery('SELECT * FROM Test');
  print(projetcList);
  return projetcList;    
}

void update(id,name,rssi) async{
      var databasesPath = await getDatabasesPath();
String path = join(databasesPath, 'database.db');


Database database = await openDatabase(path, version: 1);
await database.rawUpdate(
    'UPDATE Test SET name = ?, rssi = ? WHERE id = ?',
    ['${name}', '${rssi}', '${id}']);
}