import 'package:flutter/material.dart';
import '../usersettings.dart';
import '../functions.dart';

class FiltersPopup extends StatefulWidget {
  const FiltersPopup({Key? key}) : super(key: key);

  @override
  _FiltersPopupState createState() => _FiltersPopupState();
}

class _FiltersPopupState extends State<FiltersPopup> {
  bool _filters = false;
  bool _filtersChanged = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: !_filters ? 0 : MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: getThemeColor(context)),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: genres.keys.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  userGenres.contains(genres[genres.keys.toList()[index]])
                      ? userGenres.remove(genres[genres.keys.toList()[index]])
                      : userGenres.add(genres[genres.keys.toList()[index]]);
                  _filtersChanged = true;
                  setState(() {});
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                      color: userGenres
                              .contains(genres[genres.keys.toList()[index]])
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Theme.of(context).primaryColor)),
                  child: Center(child: Text('${genres.keys.toList()[index]}')),
                ),
              ),
            );
          }),
    );
  }
}
