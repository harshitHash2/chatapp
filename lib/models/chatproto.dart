class ChatPeople {
  ChatPeople(
      {required this.username,
      required this.Name,
      required this.url,
      required this.uid,
      required this.msg_id});
  String url;
  String username;
  String Name;
  String uid;
  String msg_id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatPeople &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          Name == other.Name &&
          url == other.url &&
          uid == other.uid &&
          msg_id == other.msg_id;

  @override
  int get hashCode =>
      username.hashCode ^
      Name.hashCode ^
      url.hashCode ^
      uid.hashCode ^
      msg_id.hashCode;
}
