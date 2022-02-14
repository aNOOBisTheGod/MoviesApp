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
        genre_ids = json['genre_ids'],
        votes = json['vote_count'],
        backdrop_path = json['backdrop_path'],
        poster = json['poster_path'],
        original_language = json['original_language'],
        original_title = json['original_title'],
        title = json['title'],
        vote_average = json['vote_average'],
        media_type = json['media_type'],
        overview = json['overview'],
        adult = json['adult'],
        popularity = json['popularity'],
        video = json['video'],
        release_date = json['release_date'];
}
