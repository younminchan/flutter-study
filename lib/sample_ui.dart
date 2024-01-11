import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

/** Ex1. */
class MyApp1 extends StatelessWidget{
  const MyApp1({super.key});
  // 상태 변경 없는 위젯. 한번 UI가 그려지면 그대로 있음.
  @override
  Widget build(BuildContext context){   // UI 만드는 부분
    return MaterialApp(             // MaterialApp Design(구글 기본 디자인) 사용해서 앱 만듦
      title: 'Flutter App',
      debugShowCheckedModeBanner: false, // 화면에 debug 표시 안보이게 함
      home: Scaffold(
          appBar : AppBar(title: Text("Title")),  //앱의 상단 타이틀
          body : Text("My Flutter App") // 앱화면에 표시되는 text
      ),
    );
  }
}

/** Ex2. */
class MyApp2 extends StatelessWidget{
  const MyApp2({super.key});
  // 상태 변경 없는 위젯. 한번 UI가 그려지면 그대로 있음.

  @override
  Widget build(BuildContext context){   // UI 만드는 부분
    var imageURL = "https://images.pexels.com/photos/912110/pexels-photo-912110.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940";

    return MaterialApp(             // MaterialApp Design(구글 기본 디자인) 사용해서 앱 만듦
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar : AppBar(title: Text("Title")),  //앱의 상단 타이틀
          body : Image.network(imageURL)
      ),
    );
  }
}

/** Ex3. */
class MyApp3 extends StatelessWidget{
  const MyApp3({super.key});
  // 상태 변경 없는 위젯. 한번 UI가 그려지면 그대로 있음.

  @override
  Widget build(BuildContext context){   // UI 만드는 부분
    return MaterialApp(             // MaterialApp Design(구글 기본 디자인) 사용해서 앱 만듦
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar : AppBar(title: Text("Title")),  //앱의 상단 타이틀
          body : Column(
            children: <Widget>[
              Text("My First Flutter App"),
              Text("Lets make our own app~!"),
              Icon(Icons.android, color: Colors.amber)
            ],
          )
      ),
    );
  }
}


/** Ex4. */
class MyApp4 extends StatelessWidget{
  const MyApp4({super.key});
  // 상태 변경 없는 위젯. 한번 UI가 그려지면 그대로 있음.

  @override
  Widget build(BuildContext context){   // UI 만드는 부분
    return MaterialApp(             // MaterialApp Design(구글 기본 디자인) 사용해서 앱 만듦
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar : AppBar(title: Text("Title")),  //앱의 상단 타이틀
          body : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, //위젯 간격 일정하게~!
            children: <Widget>[
              Text("My First Flutter App"),
              Text("Lets make our own app~!"),
              Icon(Icons.android, color: Colors.amber)
            ],

          )
      ),
    );
  }
}


/** Ex5. */
class MyApp5 extends StatefulWidget{
  const MyApp5({super.key});
  // Widget 과 State를 다루는 부분은 분리되어 있음

  @override
  _MyAppState5 createState() => _MyAppState5();
}

class _MyAppState5 extends State<MyApp5> {
  int counter = 0;

  void increaseCounter(){
    setState(() {
      counter++;
    });
  }
  void decreaseCounter(){
    setState(() {
      if(counter > 0){
        counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "First Stateful App",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title : Text("My StatefulWidget"),
        ),
        body : Container(
          padding: const EdgeInsets.all(16.0), // 16씩 패딩

          child: Column(
            children: <Widget>[
              Text(
                  "$counter",
                  style: TextStyle(fontSize: 160.0)
              ),
              Row(  //가로로 위젯 배치
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                    onPressed: () {
                      increaseCounter();
                    },
                  ),
                  MaterialButton(
                    child: Text(
                      "Subtract",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      decreaseCounter();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/** Ex6. - 무한 List 만들기 */
class MyApp6 extends StatelessWidget {
  const MyApp6({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '스타트업 이름 짓기',
      debugShowCheckedModeBanner: false,
      home:RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  // TODO Add build() method
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }


  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) { /*1*/
          if (i.isOdd) return Divider();
          //: 리스트의 홀수 번째 아이템에는 Divider 위젯을 추가합니다. Divider는 리스트 아이템 사이에 구분선을 추가하는 역할을 합니다. /*2*/

          final index = i ~/ 2; //i를 2로 나눈 몫을 result 변수에 저장 /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
            debugPrint("테스트");
          }
          //return _buildRow(_suggestions[index]);
          //return _buttonRow(_suggestions[index]);
          return _buttonRow2(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  Widget _buttonRow(WordPair pair) {
    return MaterialButton(
      color: Colors.deepOrangeAccent,
      //margin: EdgeInsets.all(30.0), //margin 사용 불가능 아래와 같이 수정
      padding: EdgeInsets.fromLTRB(10, 20, 30, 40),
      onPressed: () {},
      child: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  Widget _buttonRow2(WordPair pair) {
    return Container(
      margin: EdgeInsets.all(4.0),
      padding: EdgeInsets.fromLTRB(10, 20, 30, 40),
      color: Colors.amberAccent,
      child: MaterialButton(
        color: Colors.red,
        onPressed: () {  },
        child: Container(
          child: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        ),
      ),
    );
  }
}