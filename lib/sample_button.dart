import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SampleButton extends StatelessWidget {
  const SampleButton({super.key}); //required: 꼭 선언해주어야 하는 값
  final String title = 'SampleButton_title'; //화면상단에 표시될 제목. final이 붙어 더이상 변경되지 않는다.

  @override
  Widget build(BuildContext context) {
    return Scaffold( //앱 화면이 기본적으로 갖춘 기능을 선언한 위젯
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //1. 간단한 형태의 버튼 / 테두리 없음, 안에 Text 위젯만 존재
            TextButton(
                onPressed: () {},
                style: CommonStyleTest,
                child: Container(
                  child: Text('TextButton'),
                  color: Colors.red,
                )),

            //2. 배경색이 칠해진 버튼
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent, // 버튼의 배경색을 파란색으로 설정
                  // 그 외의 스타일 속성들을 필요에 따라 추가로 설정할 수 있습니다.
                  // ex) textStyle, padding, minimumSize 등
                  side: BorderSide(color: Colors.greenAccent, width: 3),
                ),
                child: Container(
                  child: Text('Elevated button'),
                  color: Colors.deepOrange,
                )),

            //3. 테두리가 그려져 있는 버튼
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  //backgroundColor: Colors.red,
                  foregroundColor: Colors.purpleAccent,
                  side: BorderSide(color: Colors.red, width: 2), //테두리 색상 지정
                ),
                onPressed: () {},
                child: Container(
                  child: Text('outlined button'),
                  color: Colors.blueAccent,
                )),

            //4. Icon을 인자로 받아 아이콘 형태의 버튼 생성
            IconButton(onPressed: () {}, icon: Icon(Icons.star)),
          ],
        ),
      ),
    );
  }
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
