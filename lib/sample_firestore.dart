import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/model/ChatModel.dart';

class SampleFirestore extends StatefulWidget {
  const SampleFirestore({super.key});

  @override
  State<SampleFirestore> createState() => _SampleFirestoreState();
}

class _SampleFirestoreState extends State<SampleFirestore> {
  //화면상단에 표시될 제목. final이 붙어 더이상 변경되지 않는다.
  final String title = 'SampleFirestore_title';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<QueryDocumentSnapshot> messageList = <QueryDocumentSnapshot>[];
  final List<ChatModel> chatList = <ChatModel>[];

  ScrollController scrollController = ScrollController();

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('flutter')
      .orderBy('time', descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {

    return Scaffold( //앱 화면이 기본적으로 갖춘 기능을 선언한 위젯
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

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                    final Timestamp timestamp = data['timeStamp'];
                    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000);


                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(10),
                            color: Color(0xff808080),
                            child: Column(
                              children: [
                                Text("age: ${data['age']} / email: ${data['email']}"),
                                Text("timestamp: $dateTime"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );

                    // return ListTile(
                    //   tileColor: Colors.red,
                    //   title: Text(data['name']),
                    //   subtitle: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text("age: ${data['age']} / email: ${data['email']}"),
                    //       Text("timestamp: $dateTime"),
                    //     ],
                    //   ),
                    // );
                  },
                );

              },
            ),

            // <기존 코드 백업>
            // child: ListView.builder(
            //   reverse: true,
            //   controller: scrollController,
            //   itemCount: messageList.length,
            //   itemBuilder: (BuildContext context, int index){
            //     return Container(
            //       height: 50,
            //       color: Colors.greenAccent,
            //       child: Center(
            //         child: Text('Name: ${messageList[index]['name']} / Age: ${messageList[index]['age']} / Email: ${messageList[index]['email']}'),
            //       ),
            //     );
            //   },

          ),

          /** (메세지) 다른사람 */
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.green, //나중에 삭제
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //이름
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: SizedBox(
                      child: Text("UserName")
                  ),
                ),

                //메세지
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible( //자동 줄바꿈이 가능한 Flexible
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Color(0xfffef01b),
                        child: Text("Message"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /** (메세지) 나 */
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    color: Color(0xfffef01b),
                    child: Column(
                      children: [
                        Text("이름"),
                        Text("메세지"),
                      ],
                    ),
                  ),
                ),
              ],
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
    //firestoreSnapshots();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  /** Firestore에 데이터 추가하는 함수 */
  Future<void> addDataToFirestore() async {
    try {
      final Timestamp timestamp = Timestamp.now();
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000);

      await firestore.collection('flutter').add({
        'name': 'John Doe_${DateTime.now().millisecondsSinceEpoch}',
        'age': 30,
        'email': 'johndoe@example.com',
        'timeStamp' : timestamp,
        'time' : dateTime,
      });

      print('Data added to Firestore');

      //firesotre 최신화
      //await readDataFromFirestore();
    } catch (e) {
      print('Error adding data to Firestore: $e');
    }
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