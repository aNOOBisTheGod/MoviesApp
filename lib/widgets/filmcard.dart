import 'package:flutter/material.dart';
import 'package:movies/screens/filmscreen.dart';
import '../models/film.dart';
import '../usersettings.dart' show genres;

class FilmCard extends StatefulWidget {
  Film film;

  FilmCard(this.film);

  @override
  State<FilmCard> createState() => _FilmCardState();
}

class _FilmCardState extends State<FilmCard> {
  bool preview = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => setState(() {
        preview = !preview;
      }),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => FilmScreen(widget.film))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withAlpha(30),
                  blurRadius: 6.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    0.0,
                    3.0,
                  ),
                ),
              ]),
          child: Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500/${widget.film.poster}',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.grey.withOpacity(0.0),
                        Theme.of(context)
                            .primaryColor
                            .withOpacity(preview ? 1 : 0.5),
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
            ),
            AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              margin: EdgeInsets.only(
                  bottom:
                      preview ? MediaQuery.of(context).size.height * 0.2 : 0),
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(30),
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.bottomLeft,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Text(
                widget.film.title,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            preview
                ? AnimatedContainer(
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.all(30),
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.bottomLeft,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${widget.film.vote_average}',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.start,
                              ),
                              Icon(Icons.star)
                            ],
                          ),
                          Text(
                            'Original language: ${widget.film.original_language}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            'Genres: ${widget.film.genre_ids.map(
                                  (x) => genres.keys.firstWhere(
                                      (element) => genres[element] == x,
                                      orElse: () => 'Incomprehensible'),
                                ).join(', ')}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container()
          ]),
        ),
      ),
    );
  }
}
