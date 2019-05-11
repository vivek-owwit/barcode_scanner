import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_scanner/Screens/scanned_items_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qr_scanner/models/note.dart';
import 'package:qr_scanner/Database/database_helper.dart';

import 'package:simple_permissions/simple_permissions.dart';

import '../main.dart';

int count=0;

class ScannerApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
   return ScannerAppState();
 }
}


class ScannerAppState extends State<ScannerApp> {
  String _reader='';
  Permission permission= Permission.Camera;

  DatabaseHelper helper = DatabaseHelper();

  Note note;


  @override


  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.pinkAccent,
      home:new Scaffold(
        body:Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              new RaisedButton(

                splashColor: Colors.pinkAccent,
                color: Colors.red,
                child: new Text("Scan Barcode",style: new TextStyle(fontSize: 20.0,color: Colors.white),),
                onPressed: scan,
              ),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
              ),
              new RaisedButton(

                splashColor: Colors.pinkAccent,
                color: Colors.red,
                child: new Text("View Scanned items",style: new TextStyle(fontSize: 20.0,color: Colors.white),),
                onPressed: (){
                 // updateListView();
                  Navigator.push(context, MaterialPageRoute(builder:
                      (BuildContext context) =>  scanned_items()));
                },
              ),
              new Padding(padding: const EdgeInsets.symmetric(vertical: 20.0), ),
              new Text('$_reader',softWrap: true, style: new TextStyle(fontSize: 30.0,color: Colors.blue),),

            ],
          ),
        ),
      ),
    );
  }

//  Future navigateToscanned_items(context) async {
//    Navigator.push(context, MaterialPageRoute(builder: (context) => scanned_items()));
//  }

    requestPermission() async {
    PermissionStatus result = await SimplePermissions.requestPermission(permission);
    setState(()=> new SnackBar
       (backgroundColor: Colors.red,content: new Text(" $result"),),
    );}


    scan() async {
    count=0;
    try {
         String reader= await BarcodeScanner.scan();

      if (!mounted) {
        return;
      }

         setState(() => this._reader=reader
         );


    } on PlatformException catch(e) {
      if(e.code==BarcodeScanner.CameraAccessDenied) {requestPermission();}
      else{setState(()=> _reader = "null");}
    }on FormatException{
      setState(() => _reader = 'null');
    } catch (e) {
      setState(() => _reader = 'null');
    }

    updateDescription();
    _save();

  }





  // Update the description of Note object
  void updateDescription() {
    note.description = _reader;
  }


  // Save data to database
  void _save() async {

    int result;
    if (note.description == null ) {
      result = 0;
    } else { // Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}
