import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:qr_scanner/models/note.dart';
import 'package:qr_scanner/Database/database_helper.dart';

// ignore: camel_case_types
class scanned_items extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return scan_list();
  }
}

// ignore: camel_case_types
  class scan_list extends State<scanned_items> {

    DatabaseHelper databaseHelper = DatabaseHelper();
    List<Note> noteList;
    int count = 0;


    @override


  Widget build(BuildContext context) {

      if (noteList == null) {
        noteList = List<Note>();
        updateListView();
      }


    return WillPopScope(

      onWillPop: (){
        moveToLastScreen();
      },

    child: Scaffold(

      appBar: AppBar(
        title: Text('Scanned Items'),
      ),//Appbar

      body: getscanlistView(),
    ));//Scaffold
  }
  ListView getscanlistView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Text(this.noteList[position].Seq.toString()),
            ),

            title: Text(this.noteList[position].description),
          ),
        );
      },
    );
  }
  void moveToLastScreen() {
    Navigator.pop(context);

  }

    void updateListView() {

      final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((database) {

        Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
        noteListFuture.then((noteList) {
          setState(() {
            this.noteList = noteList;
            this.count = noteList.length;
          });
        });
      });
    }
}
