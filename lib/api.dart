import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/film.dart';
import './usersettings.dart';
import './private.dart' show apikey;

Future<List> getPopular(page) async {
  print('ok');
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

Future<void> getGenres() async {
  genres = {};
  http.Response response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/genre/movie/list?api_key=dab597a1412879d300c0947e376c8cda&language=en-US'));
  for (int i = 0; i < json.decode(response.body)['genres'].length; i++) {
    print(json.decode(response.body)['genres'][i]);
    genres[json.decode(response.body)['genres'][i]['name']] =
        json.decode(response.body)['genres'][i]['id'];
  }
  print(genres);
}

Future<List> searchByQuery(query) async {
  genres = {};
  http.Response response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=dab597a1412879d300c0947e376c8cda&language=en-US&query=$query&page=1'));
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
