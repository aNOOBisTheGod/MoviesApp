import 'package:flutter/material.dart';
import 'package:movies/screens/favourites.dart';
import '../themes.dart' show ThemeModel;
import 'package:provider/provider.dart';
import '../screens/introduction.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Drawer(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              automaticallyImplyLeading: false,
              title: Text(themeNotifier.isDark ? "Dark Mode" : "Light Mode"),
              actions: [
                IconButton(
                    icon: Icon(themeNotifier.isDark
                        ? Icons.nightlight_round
                        : Icons.wb_sunny),
                    onPressed: () {
                      themeNotifier.isDark
                          ? themeNotifier.isDark = false
                          : themeNotifier.isDark = true;
                    }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      maximumSize: Size(200, 100)),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(FavouritesScreeen.routeName),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.star),
                      ),
                      Text('Favourites')
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      maximumSize: Size(200, 100)),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(IntoduceScreen.routeName),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FaIcon(FontAwesomeIcons.fireAlt),
                      ),
                      Text('Epic introduction')
                    ],
                  )),
            )
          ],
        ),
      );
    });
  }
}
