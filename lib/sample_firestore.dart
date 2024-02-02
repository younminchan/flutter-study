import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_practice/model/ChatModel.dart';

class SampleFirestore extends StatefulWidget {
  const SampleFirestore({super.key});

  @override
  State<SampleFirestore> createState() => _SampleFirestoreState();
}

  String collectionName = "chatting";

class _SampleFirestoreState extends State<SampleFirestore> {
  //화면상단에 표시될 제목. final이 붙어 더이상 변경되지 않는다.
  final String title = 'Flutter Firestore talk';
  final String UserName = "TestUser";
  // final String UserName = "OtherUser";

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<QueryDocumentSnapshot> messageList = <QueryDocumentSnapshot>[];
  final List<ChatModel> chatList = <ChatModel>[];

  ScrollController scrollController = ScrollController();
  final textEditController = TextEditingController();

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection(collectionName)
      .orderBy('time', descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //외부터치시 Textfield 내리기
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        //앱 화면이 기본적으로 갖춘 기능을 선언한 위젯
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /** List */
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  //채팅 입력에 따라 scroll 이동
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.jumpTo(scrollController.position.maxScrollExtent);
                    } else {
                      setState(() => null);
                    }
                  });

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                      final Timestamp timestamp = data['timeStamp'];
                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000);

                      if(data['name'] == UserName){
                        print("Myname: ${data['name']}");
                        return MyMessageUI(data, dateTime);
                      } else {
                        print("Othername: ${data['name']}");
                        return OtherMessageUI(data, dateTime);
                      }
                    },
                  );
                },
              ),
            ),

            /** 메세지 입력 */
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Color(0xffffffff),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /** 입력 */
                        Expanded(
                          child: Container(
                            color: Color(0xfff9f9f9),
                            child: Flexible(
                              child: TextField(
                                controller: textEditController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '메세지를 입력해주세요.',
                                ),
                              ),
                            ),
                          ),
                        ),

                        /** 전송 */
                        Container(
                          //color: Colors.greenAccent,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              print("입력한 값: ${textEditController.text}");
                              addMessage(textEditController.text);

                              textEditController.clear(); //입력창 초기화
                              setState(() {
                                //scrollController.jumpTo(scrollController.position.maxScrollExtent); //최하단 스크롤
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff0D60E3), // 버튼의 배경색을 파란색으로 설정
                              // 그 외의 스타일 속성들을 필요에 따라 추가로 설정할 수 있습니다.
                              // ex) textStyle, padding, minimumSize 등
                              //side: BorderSide(color: Colors.greenAccent, width: 3),
                            ),
                            child: Text(
                              style: TextStyle(color: Colors.white),
                              "전송",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            /** Add */
            // ElevatedButton(
            //   onPressed: () {
            //     addDataToFirestore();
            //   },
            //   child: Text('Add Data'),
            // ),

            /** Read */
            // ElevatedButton(
            //   onPressed: () {
            //     readDataFromFirestore();
            //   },
            //   child: Text('Read Data'),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //firestoreSnapshots();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    textEditController.dispose();
  }

  /** Firestore에 데이터 추가하는 함수 */
  // Future<void> addDataToFirestore() async {
  //   try {
  //     final Timestamp timestamp = Timestamp.now();
  //     DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000);
  //
  //     await firestore.collection('flutter').add({
  //       'name': UserName,
  //       'message': "test_${DateTime.now().millisecondsSinceEpoch}",
  //       'timeStamp' : timestamp,
  //       'time' : dateTime,
  //     });
  //
  //     print('Data added to Firestore');
  //   } catch (e) {
  //     print('Error adding data to Firestore: $e');
  //   }
  // }

  /** Firestore에 데이터 추가하는 함수 */
  Future<void> addMessage(String message) async {
    try {
      final Timestamp timestamp = Timestamp.now();
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000);
      
      await firestore.collection(collectionName).doc('MSG_$dateTime').set({
        'name': UserName,
        'message': message,
        'timeStamp' : timestamp,
        'time' : dateTime,
      });

      print('addMessage: $message');
    } catch (e) {
      print('Error adding data to Firestore: $e');
    }
  }

  /** (메세지) 다른사람 */
  Widget OtherMessageUI(Map<String, dynamic> data, DateTime dateTime) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //이름
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: SizedBox(
              child: Text(
                "${data['name']}",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          //메세지
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible( //자동 줄바꿈이 가능한 Flexible
                child: Container(
                  //둥근 박스
                  decoration: BoxDecoration(
                    //BoxDecoration은 안에 color값을 지정해야함
                      color: Color(0x30808080),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(14),
                  child: Text(
                    "${data['message']}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  /** (메세지) 나 */
  Widget MyMessageUI(Map<String, dynamic> data, DateTime dateTime) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //이름
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: SizedBox(
              child: Text(
                "${data['name']}",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          //메세지
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible( //자동 줄바꿈이 가능한 Flexible
                child: Container(
                  //둥근 박스
                  decoration: BoxDecoration(
                    //BoxDecoration은 안에 color값을 지정해야함
                      color: Color(0xfffef01b),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(14),
                  child: Text(
                    "${data['message']}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


















  /** Firestore 데이터 싱크 - 동작을 안하는듯? */
  Future<void> firestoreSnapshots() async {
    StreamBuilder(
        stream: FirebaseFirestore.instance.collection("flutter").orderBy('timeStamp', descending: false).snapshots(),
        builder: ((context, snapshot) {
          try {
            print('snapshot.data?.docChanges.length: ${snapshot.data?.docChanges.length}');
            if (snapshot.data?.docChanges.length != null) {
              print("여기는 들어오나?");
              for (DocumentChange item in snapshot.data!.docChanges) {
                print("firestoreSnapshots ${item.doc.data()}");
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

  /** Firestore에서 데이터 읽어오는 함수 */
  Future<void> readDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('flutter').orderBy('timeStamp', descending: true).get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        print('Name: ${doc['name']}, Age: ${doc['age']}, Email: ${doc['email']}');
      }

      //데이터 추가에 따른 UI 동작
      setState(() {
        messageList.clear();
        messageList.addAll(querySnapshot.docs);

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