import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SampleAlignment extends StatefulWidget {
  const SampleAlignment({super.key});

  @override
  _SampleAlignment createState() => _SampleAlignment();
}

// **MainAxisSize**
// 실제 column의 경우, 수직으로 배열이 되지만 그 수평쪽의 여백까지 다 차지하고 있다. 이 속성은 그 여백의 유무를 결정한다.
// max : 남는 공간을 모두 차지
// min : 위젯의 크기 만큼만 차지

// **MainAxisAlignment**
// spaceEvenly : 앞 뒤 균등하게 배치
// spaceAround : 첫번째와 마지막 자식의 간격을 그 사이 간격들의 절반으로 배치
// spaceBetween : 첫번째와 마지막 자식을 제외한 간격이 균등 배치
// start : 왼쪽 정렬
// center : 가운데 정렬
// end : 오른쪽 정렬

class _SampleAlignment extends State<SampleAlignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UI 정렬"),
      ),
      body: SingleChildScrollView( //ScrollView 적용!
        child: Column(
          children: [
            _Text('MainAxisAlignment.spaceEvenly'),
            _RectContainer(MainAxisAlignment.spaceEvenly),

            _Text('MainAxisAlignment.spaceAround'),
            _RectContainer(MainAxisAlignment.spaceAround),

            _Text('MainAxisAlignment.spaceBetween'),
            _RectContainer(MainAxisAlignment.spaceBetween),

            _Text('MainAxisAlignment.start'),
            _RectContainer(MainAxisAlignment.start),

            _Text('MainAxisAlignment.center'),
            _RectContainer(MainAxisAlignment.center),

            _Text('MainAxisAlignment.end'),
            _RectContainer(MainAxisAlignment.end),
          ],
        ),
      ),
    );
  }
}

/** 사각형 전체 */
class _RectContainer extends StatelessWidget {
  _RectContainer(this.mainAxisAlignmentName);

  var mainAxisAlignmentName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignmentName,
        children: [
          _RectSample(rectColor: Colors.blue),
          _RectSample(rectColor: Colors.red),
          _RectSample(rectColor: Colors.green),
        ],
      ),
    );
  }
}

/** 사각형 */
class _RectSample extends StatelessWidget {
  _RectSample({this.rectColor});
  var rectColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(100.0),
      width: 100,
      height: 100,
      color: rectColor,
    );
  }
}

/** 글자 */
class _Text extends StatelessWidget {
  _Text(this.title);

  var title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}