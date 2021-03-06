import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies/widgets/background.dart';
import 'package:movies/widgets/rewiew_card.dart';
import '../models/film.dart';
import 'package:flutter_glow/flutter_glow.dart';
import '../api.dart';
import 'package:movies/usersettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilmScreen extends StatefulWidget {
  Film film;
  FilmScreen(this.film);

  @override
  _FilmScreenState createState() => _FilmScreenState();
}

class _FilmScreenState extends State<FilmScreen> {
  List? reviews;
  bool _isLoading = true;
  bool _isFavourite = false;
  @override
  void initState() {
    checkFavourites();
    getData();
    super.initState();
  }

  void getData() async {
    try {
      reviews = await getReviews(widget.film.id);
    } catch (e) {
      reviews = [];
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> checkFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? prefav = prefs.getString('favourite');
    if (prefav == null) {
      return false;
    }
    List fav = json.decode(prefav);
    for (int e in fav) {
      if (e == widget.film.id) {
        setState(() {
          _isFavourite = true;
        });
        return true;
      }
    }
    setState(() {
      _isFavourite = false;
    });
    return false;
  }

  void changeFavourites() async {
    print(100);
    final prefs = await SharedPreferences.getInstance();
    String? prefav = prefs.getString('favourite');
    if (prefav == null) {
      prefav = '[]';
    }
    List fav = json.decode(prefav);
    if (!await checkFavourites()) {
      fav.add(widget.film.id);
    } else {
      fav.remove(widget.film.id);
    }
    checkFavourites();
    await prefs.setString('favourite', json.encode(fav));
    print(prefs.getString('favourite'));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.film.id);
    return Scaffold(
      body: SafeArea(
        child: AppBackground(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            'https://image.tmdb.org/t/p/w500/' +
                                widget.film.backdrop_path,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  color: Colors.grey[600],
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(Icons.close)),
                              IconButton(
                                  onPressed: () => changeFavourites(),
                                  icon: AnimatedSwitcher(
                                    duration: const Duration(microseconds: 300),
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      return FadeTransition(
                                          opacity: animation, child: child);
                                    },
                                    child: Icon(
                                      Icons.star,
                                      key: ValueKey<bool>(_isFavourite),
                                      color: _isFavourite
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[600],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: GlowText(
                          widget.film.title,
                          blurRadius: 10,
                          glowColor: Theme.of(context).primaryColor,
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                        child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 2,
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: [
                              ...widget.film.genre_ids.map((x) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      genres.keys.firstWhere(
                                          (element) => genres[element] == x,
                                          orElse: () => '._.'),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ))
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          widget.film.overview,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: reviews!.length != 0
                            ? GlowText(
                                'Verified reviews: ',
                                glowColor: Colors.white,
                                blurRadius: 2,
                                style: TextStyle(fontSize: 40),
                              )
                            : GlowText(
                                'No reviews provided',
                                glowColor: Colors.white,
                                blurRadius: 2,
                                style: TextStyle(fontSize: 40),
                              ),
                      ),
                      ListView.builder(
                        itemCount: reviews!.length,
                        itemBuilder: (context, index) {
                          return ReviewCard(reviews![index]);
                        },
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
