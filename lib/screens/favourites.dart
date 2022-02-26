import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/filmcard.dart';
import 'dart:math';

class DrawClip extends CustomClipper<Path> {
  double move = 0;
  double slice = pi;
  DrawClip(this.move);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    double xCenter1 = size.width * 0.3;
    double xCenter2 = size.width * 0.7;
    double yCenter1 = size.height * 0.6 + 50 * cos(move * slice);
    double yCenter2 = size.height * 0.6 - 50 * cos(move * slice);
    path.quadraticBezierTo(
        xCenter1, yCenter1, size.width * 0.5, size.height * 0.6);
    path.quadraticBezierTo(xCenter2, yCenter2, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class FavouritesScreeen extends StatefulWidget {
  static const routeName = '/favourites';
  const FavouritesScreeen({Key? key}) : super(key: key);

  @override
  _FavouritesScreeenState createState() => _FavouritesScreeenState();
}

class _FavouritesScreeenState extends State<FavouritesScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Favourite films'),
      ),
      body: Favourites(),
    );
  }
}

class Favourites extends StatefulWidget {
  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites>
    with SingleTickerProviderStateMixin {
  bool _isloading = true;
  AnimationController? _controller;

  List data = [];

  @override
  void initState() {
    getData();
    super.initState();
    _controller = AnimationController(
      value: 0.0,
      duration: Duration(seconds: 10),
      upperBound: 1,
      lowerBound: -1,
      vsync: this,
    )..repeat();
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? fav = prefs.getString('favourite');
    for (int e in json.decode(fav!)) {
      data.add(await getFilm(e));
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  void dispose() {
    _controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller!,
                builder: (BuildContext context, child) {
                  return ClipPath(
                    clipper: DrawClip(_controller!.value),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors:
                                Theme.of(context).brightness == Brightness.dark
                                    ? [Color(0xFFE0647B), Color(0xFFFCDD89)]
                                    : [Color(0xFFd25ce6), Color(0xFFf90047)]),
                      ),
                    ),
                  );
                },
              ),
              Container(
                padding: EdgeInsets.only(bottom: 60),
                child: Text(
                  'Favourites',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 46,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (_isloading)
            const Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          else ...[
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 5 / 6,
                crossAxisCount: MediaQuery.of(context).size.width ~/ 300,
              ),
              padding: EdgeInsets.only(right: 30, left: 30),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return FilmCard(data[index]);
              },
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          ]
        ],
      ),
    );
  }
}
