import 'package:qr_scanner/models/note.dart';
import 'package:sqflite/sqflite.dart';//sqflite plugin
import 'dart:async';
import 'dart:io';// to deal with files and folders
import 'package:path_provider/path_provider.dart'; // for android
import 'package:path/path.dart'; // for ios


 class DatabaseHelper {

   static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
   static Database _database;                // Singleton Database

   String noteTable = 'Scanneditems';
   String colSeq = 'Seq';
   String colDescription = 'description';

   DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

   factory DatabaseHelper() {

     if (_databaseHelper == null) {
       _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
     }
     return _databaseHelper;
   }

   // getter for our database
   Future<Database> get database async {

     if (_database == null) {
       _database = await initializeDatabase();
     }
     return _database;
   }

   // database initialization
   Future<Database> initializeDatabase() async {
     // Get the directory path for both Android and iOS to store database.
     Directory directory = await getApplicationDocumentsDirectory();
     String path = directory.path + 'notes.db';

     // Open/create the database at a given path
     var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
     return notesDatabase;
   }

   // Create Database
   void _createDb(Database db, int newVersion) async {
     await db.execute('CREATE TABLE $noteTable($colSeq INTEGER PRIMARY KEY AUTOINCREMENT, $colDescription TEXT)');
   }

   // Fetch Operation: Get all note objects from database
   Future<List<Map<String, dynamic>>> getNoteMapList() async {
     Database db = await this.database;
     var result = await db.query(noteTable, orderBy: '$colSeq ASC');
     return result;
   }


   // Insert Operation: Insert a Note object to database
   Future<int> insertNote(Note note) async {
     Database db = await this.database;
     var result = await db.insert(noteTable, note.toMap());
     return result;
   }

   // Get number of Note objects in database
   Future<int> getCount() async {
     Database db = await this.database;
     List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
     int result = Sqflite.firstIntValue(x);
     return result;
   }

   // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
   Future<List<Note>> getNoteList() async {

     var noteMapList = await getNoteMapList(); // Get 'Map List' from database
     int count = noteMapList.length;         // Count the number of map entries in db table

     List<Note> noteList = List<Note>();
     // For loop to create a 'Note List' from a 'Map List'
     for (int i = 0; i < count; i++) {
       noteList.add(Note.fromMapObject(noteMapList[i]));
     }

     return noteList;
   }


 }