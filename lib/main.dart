import 'package:flutter/material.dart';
import 'Screens/Home_screen.dart';
import 'Screens/scanned_items_list.dart';

void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Barcode Sacnner',
      debugShowCheckedModeBanner: false,
      // Set Raceway as the default app font
      theme: ThemeData(
        fontFamily: 'Roboto',

      ),//Theme data
        home: ScannerApp(),
    );// Material App
  }


//  State<StatefulWidget> createState() {
//    return MyAppState();
//  }
}

