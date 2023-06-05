

class MovieSuggestionModel {
  MovieSuggestionModel({
    required this.title,
    required this.id,
  });
  late final String title;
  late final int id;

  MovieSuggestionModel.fromJson(Map<String, dynamic> json){
    title = json['title'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['id'] = id;
    return _data;
  }
}