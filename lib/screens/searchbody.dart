import 'package:flutter/material.dart';
import '../api.dart';
import '../widgets/filmcard.dart';
import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class SearchBody extends StatefulWidget {
  const SearchBody({Key? key}) : super(key: key);

  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  bool _isloading = true;

  List data = [];

  @override
  void initState() {
    getData(getRandomString(1));
    super.initState();
  }

  void getData(query) async {
    data = await searchByQuery(query);
    setState(() {
      _isloading = false;
    });
  }

  TextEditingController _queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _isloading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.orange,
          ))
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: TextField(
                    controller: _queryController,
                    onChanged: (e) => getData(e),
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                      hintText: 'insert name of film',
                      iconColor: Theme.of(context).primaryColor,
                      fillColor: Theme.of(context).primaryColor,
                      focusColor: Theme.of(context).primaryColor,
                      hoverColor: Theme.of(context).primaryColor,
                      prefixIconColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
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
              ],
            ),
          );
  }
}
