class ChatModel {
  final String name; //name
  final String msg; //msg
  final String timeStamp; //timeStamp

  ChatModel(this.name, this.msg, this.timeStamp);
  
  ChatModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        msg = json['msg'],
        timeStamp = json['timeStamp'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'msg': msg,
        'timeStamp': timeStamp,
      };
}
