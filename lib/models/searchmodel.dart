class SearchModel {
  SearchModel({required this.imageURL, required this.username});

  String imageURL;
  String username;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchModel &&
          runtimeType == other.runtimeType &&
          imageURL == other.imageURL &&
          username == other.username;

  @override
  int get hashCode => imageURL.hashCode ^ username.hashCode;
}
