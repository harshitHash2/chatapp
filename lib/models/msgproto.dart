class MsgPro {
  MsgPro(
      {required this.text,
      required this.isRead,
      required this.time,
      required this.uid});
  String text;
  bool isRead;
  String time;
  String uid;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MsgPro &&
          text == other.text &&
          isRead == other.isRead &&
          time == other.time &&
          uid == other.uid;

  @override
  int get hashCode =>
      text.hashCode ^ isRead.hashCode ^ time.hashCode ^ uid.hashCode;
}
