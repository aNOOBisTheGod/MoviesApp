class Film {
  int id;
  List genre_ids;
  int votes;
  String backdrop_path;
  String poster;
  String original_language;
  String original_title;
  String title;
  double vote_average;
  String overview;
  String media_type;
  double popularity;
  String release_date;
  bool video;
  bool adult;
  Film(
      this.id,
      this.genre_ids,
      this.votes,
      this.backdrop_path,
      this.poster,
      this.original_language,
      this.original_title,
      this.title,
      this.vote_average,
      this.media_type,
      this.overview,
      this.adult,
      this.popularity,
      this.video,
      this.release_date);
  Film.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        genre_ids = json['genre_ids'] is List ? json['genre_ids'] : [],
        votes = json['vote_count'] is int ? json['vote_count'] : 0,
        backdrop_path =
            json['backdrop_path'] is String ? json['backdrop_path'] : '',
        poster = json['poster_path'] is String ? json['poster_path'] : '',
        original_language = json['original_language'] is String
            ? json['original_language']
            : '',
        original_title =
            json['original_title'] is String ? json['original_title'] : '',
        title = json['title'] is String
            ? json['title']
            : json['name'] is String
                ? json['name']
                : "",
        vote_average =
            json['vote_average'] is double ? json['vote_average'] : 0,
        media_type = json['media_type'] is String ? json['media_type'] : '',
        overview = json['overview'] is String ? json['overview'] : '',
        adult = json['adult'] is bool ? json['adult'] : false,
        popularity = json['popularity'] is double ? json['popularity'] : 0,
        video = json['video'] is bool ? json['video'] : false,
        release_date =
            json['release_date'] is String ? json['release_date'] : '';
  Map toJson() => {
        'id': id,
        'genre_ids': genre_ids,
        'vote_count': votes,
        'backdrop_path': backdrop_path,
        'poster_path': poster,
        'original_language': original_language,
        'original_title': original_title,
        'title': title,
        'vote_average': vote_average,
        'media_type': media_type,
        'overview': overview,
        'adult': adult,
        'popularity': popularity,
        'video': video,
        'release_date': release_date
      };
}
