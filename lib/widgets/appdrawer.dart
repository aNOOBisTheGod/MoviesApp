import 'package:flutter/material.dart';
import '../themes.dart' show ThemeModel;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //           primary: Theme.of(context).primaryColor,
            //           maximumSize: Size(200, 100)),
            //       onPressed: () async {
            //         final prefs = await SharedPreferences.getInstance();
            //         var hexCode =
            //             '#${Theme.of(context).primaryColor.value.toRadixString(16).substring(2, 8)}';
            //         await prefs.setString('primaryColor', '$hexCode');
            //       },
            //       child: Row(
            //         children: [Icon(Icons.color_lens), Text('Change theme')],
            //       )),
            // )
          ],
        ),
      );
    });
  }
}
