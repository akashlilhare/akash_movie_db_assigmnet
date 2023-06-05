class MovieDetailModel {
  MovieDetailModel({
    required this.adult,
    required this.backdropPath,
     required this.budget,
     required this.homepage,
    required this.id,
    required this.imdbId,
    required this.genres,

    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,

    required this.releaseDate,
    required this.revenue,
    required this.runtime,
     required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  late final bool adult;
  late final String backdropPath;
  late final int budget;
  late final String homepage;
  late final List<Genres> genres;
  late final List<SpokenLanguages> spokenLanguages;

  late final int id;
  late final String imdbId;
  late final String originalLanguage;
  late final String originalTitle;
  late final String overview;
  late final double popularity;
  late final String posterPath;

  late final String releaseDate;
  late final int revenue;
  late final int runtime;
  late final String status;
  late final String tagline;
  late final String title;
  late final bool video;
  late final double voteAverage;
  late final int voteCount;

  MovieDetailModel.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];

    budget = json['budget'];
    homepage = json['homepage'];
    id = json['id'];
    imdbId = json['imdb_id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    genres = List.from(json['genres']).map((e)=>Genres.fromJson(e)).toList();

    spokenLanguages = List.from(json['spoken_languages']).map((e)=>SpokenLanguages.fromJson(e)).toList();

    releaseDate = json['release_date'];
    revenue = json['revenue'];
    runtime = json['runtime'];

    status = json['status'];
    tagline = json['tagline'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }
}

class Genres {
  Genres({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Genres.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

}

class SpokenLanguages {
  SpokenLanguages({
    required this.englishName,
    required this.iso_639_1,
    required this.name,
  });
  late final String englishName;
  late final String iso_639_1;
  late final String name;

  SpokenLanguages.fromJson(Map<String, dynamic> json){
    englishName = json['english_name'];
    iso_639_1 = json['iso_639_1'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['english_name'] = englishName;
    _data['iso_639_1'] = iso_639_1;
    _data['name'] = name;
    return _data;
  }
}