import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/film.dart';
import './usersettings.dart';
import './private.dart' show apikey;

Future<List> getPopular(page) async {
  if (userGenres.length > 0) {
    return genreSearch(page);
  }
  http.Response response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/trending/all/day?api_key=$apikey&page=$page'));
  Map res = json.decode(response.body);
  List films = res['results'];
  List result = [];
  for (int i = 0; i < films.length; i++) {
    try {
      result.add(Film.fromJson(films[i]));
    } catch (e) {
      print(i);
    }
  }
  await getGenres();
  return result;
}

Future<List> genreSearch(page) async {
  String genres = userGenres.join(',');
  http.Response response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/discover/movie?api_key=$apikey&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=$genres&with_watch_monetization_types=free'));
  Map res = json.decode(response.body);
  List films = res['results'];

  List result = [];
  for (int i = 0; i < films.length; i++) {
    try {
      result.add(Film.fromJson(films[i]));
    } catch (e) {
      print(e);
    }
  }
  print(films);
  return result;
}

Future<void> getGenres() async {
  genres = {};
  http.Response response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/genre/movie/list?api_key=$apikey&language=en-US'));
  for (int i = 0; i < json.decode(response.body)['genres'].length; i++) {
    genres[json.decode(response.body)['genres'][i]['name']] =
        json.decode(response.body)['genres'][i]['id'];
  }
}

Future<List> searchByQuery(query) async {
  genres = {};
  http.Response response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=$apikey&language=en-US&query=$query&page=1'));
  Map res = json.decode(response.body);
  List films = res['results'];
  List result = [];
  for (int i = 0; i < films.length; i++) {
    try {
      result.add(Film.fromJson(films[i]));
    } catch (e) {
      print(i);
    }
  }
  return result;
}

Future<List> getReviews(int id) async {
  http.Response response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/$id/reviews?api_key=$apikey&language=en-US&page=1'));
  Map res = json.decode(response.body);
  return res['results'];
}

Future<Film> getFilm(int id) async {
  http.Response response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/$id?api_key=$apikey&language=en-US'));
  Map<String, dynamic> res = json.decode(response.body);
  Film film = Film.fromJson(res);
  return film;
}
