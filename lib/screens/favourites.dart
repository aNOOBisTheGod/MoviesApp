import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/filmcard.dart';

class FavouritesScreeen extends StatefulWidget {
  static const routeName = '/favourites';
  const FavouritesScreeen({Key? key}) : super(key: key);

  @override
  _FavouritesScreeenState createState() => _FavouritesScreeenState();
}

class _FavouritesScreeenState extends State<FavouritesScreeen> {
  bool _isloading = true;
  List data = [];
  @override
  void initState() {
    getData();
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor),
            )
          : Container(
              child: SingleChildScrollView(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return FilmCard(data[index]);
                  },
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
              ),
            ),
    );
  }
}
