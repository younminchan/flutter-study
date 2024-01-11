import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/sample_button.dart';
import 'package:flutter_practice/sample_firestore.dart';
import 'package:flutter_practice/sample_ios_dialog.dart';
import 'package:flutter_practice/sample_ui.dart';
import 'package:flutter_practice/smaple_alignment.dart';
import 'package:native_ios_dialog/native_ios_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  runApp(const MaterialApp(
    title: '메인페이지',
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    firestoreInit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "title",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('메인페이지'),
        ),
        body: Container(
          width: double.maxFinite,
          color: Colors.lightBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SampleAlignment()));
                },
                child: Container(
                  color: Colors.yellow,
                  child: Text(
                    'Sample 정렬',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SampleButton()));
                },
                child: Container(
                  color: Colors.greenAccent,
                  child: Text(
                    'Sample 버튼',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CupertinoApp(
                    home: HomePage()
                  )));
                },
                child: Container(
                  color: Colors.greenAccent,
                  child: Text(
                    'Sample IOS_dialog',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SampleFirestore()));
                },
                child: Container(
                  color: Colors.greenAccent,
                  child: Text(
                    'Sample Firestore',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> firestoreInit() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Error initFirestore: $e');
    }
  }
}