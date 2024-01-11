import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/firebase_options.dart';
import 'package:flutter_practice/model/ChatModel.dart';
import 'firebase_options.dart';

class SampleFirestore extends StatefulWidget {
  const SampleFirestore({super.key});

  @override
  State<SampleFirestore> createState() => _SampleFirestoreState();
}

class _SampleFirestoreState extends State<SampleFirestore> {
  //화면상단에 표시될 제목. final이 붙어 더이상 변경되지 않는다.
  final String title = 'SampleFirestore_title';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<String> list = <String>['1', '2'];
  final List<ChatModel> chatList = <ChatModel>[];

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return Scaffold( //앱 화면이 기본적으로 갖춘 기능을 선언한 위젯
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /** List */
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: scrollController,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  height: 50,
                  color: Colors.greenAccent,
                  child: Center(
                    child: Text('Name: ${list[index]}'),
                  ),
                );
              },
            ),
          ),

          /** Add */
          ElevatedButton(
            onPressed: () {
              addDataToFirestore();
            },
            child: Text('Add Data'),
          ),

          /** Read */
          ElevatedButton(
            onPressed: () {
              readDataFromFirestore();
            },
            child: Text('Read Data'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    firestoreSnapshots();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<void> firestoreSnapshots() async {
    StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").orderBy('timeStamp', descending: true).snapshots(),
        builder: ((context, snapshot) {
          try {
            print('snapshot.data?.docChanges.length: ${snapshot.data?.docChanges.length}');
            if (snapshot.data?.docChanges.length != null) {
              for (DocumentChange item in snapshot.data!.docChanges) {

                // if(item.type == DocumentChangeType.added){
                //
                // }
              }

              var addData = snapshot.data?.docChanges.map((e) => ChatModel(e.doc['name'], e.doc['msg'], e.doc['timeStamp']));
              chatList.add(addData as ChatModel);
            }
          } catch (e) {
            print('Error firestoreSnapshots: $e');
          }
          return Container(

          );
        }));
  }

  /** Firestore에 데이터 추가하는 함수 */
  Future<void> addDataToFirestore() async {
    try {
      await firestore.collection('users').add({
        'name': 'John Doe_${DateTime.now().millisecondsSinceEpoch}',
        'age': 30,
        'email': 'johndoe@example.com',
        'timeStamp' : Timestamp.now(),
      });

      print('Data added to Firestore');

      //firesotre 최신화
      await readDataFromFirestore();
    } catch (e) {
      print('Error adding data to Firestore: $e');
    }
  }

  /** Firestore에서 데이터 읽어오는 함수 */
  Future<void> readDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').orderBy('timeStamp', descending: true).get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        print('Name: ${doc['name']}, Age: ${doc['age']}, Email: ${doc['email']}');
      }

      //데이터 추가에 따른 UI 동작
      setState(() {
        list.clear();
        list.addAll(querySnapshot.docs.map((e) => '${e['name']}'));
        scrollController.jumpTo(-1); //최하단 스크롤
      });
    } catch (e) {
      print('Error reading data from Firestore: $e');
    }
  }

  // model 타입예시
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };
}

/** 스타일 공통 처리하는 방법 */
var CommonStyleTest = OutlinedButton.styleFrom(
  //backgroundColor: Colors.red,
  foregroundColor: Colors.purpleAccent,
  side: BorderSide(color: Colors.red, width: 2), //테두리 색상 지정
);

// *TextButton
// 가장 간단한 형태의 버튼
// 테두리 없음. 안에 Text 위젯만 존재

// *ElevatedButton
// 배경색이 칠해진 버튼

// *OutlinedButton
// 테두리가 그려져 있는 버튼

// *IconButton
// Icon을 인자로 받아 아이콘 형태의 버튼 생성