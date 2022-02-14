import 'package:flutter/material.dart';
import 'package:movies/widgets/rewiew_card.dart';
import '../models/film.dart';
import 'package:flutter_glow/flutter_glow.dart';
import '../api.dart';
import 'package:movies/usersettings.dart';

class FilmScreen extends StatefulWidget {
  Film film;
  FilmScreen(this.film);

  @override
  _FilmScreenState createState() => _FilmScreenState();
}

class _FilmScreenState extends State<FilmScreen> {
  List? reviews;
  bool _isLoading = true;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    reviews = await getReviews(widget.film.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
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
                          Image.network('https://image.tmdb.org/t/p/w500/' +
                              widget.film.backdrop_path),
                          IconButton(
                              color: Colors.grey[600],
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(Icons.close)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 3,
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: [
                            ...widget.film.genre_ids.map((x) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    genres.keys.firstWhere(
                                        (element) => genres[element] == x),
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
