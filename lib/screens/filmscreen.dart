import 'package:flutter/material.dart';
import '../models/film.dart';
import 'package:flutter_glow/flutter_glow.dart';

class FilmScreen extends StatefulWidget {
  Film film;
  FilmScreen(this.film);

  @override
  _FilmScreenState createState() => _FilmScreenState();
}

class _FilmScreenState extends State<FilmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network('https://image.tmdb.org/t/p/w500/' +
                      widget.film.backdrop_path),
                  IconButton(
                      color: Colors.grey[600],
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: GlowText(
                  widget.film.title,
                  blurRadius: 10,
                  glowColor: Theme.of(context).primaryColor,
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  widget.film.vote_average.toString(),
                  style: TextStyle(fontSize: 20),
                ),
                ...List.filled(
                  (widget.film.vote_average + 1) ~/ 2,
                  GlowIcon(Icons.star,
                      color: Theme.of(context).primaryColor,
                      glowColor: Theme.of(context).primaryColor),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Original Language: ${widget.film.original_language}',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  widget.film.overview,
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
