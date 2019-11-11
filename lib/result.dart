import 'package:flutter/material.dart';

class QueryUI extends StatelessWidget {
  final String query;
  final data;

  List<Widget> revealData() {
    List<Widget> uis = [];
    for (int i = 0; i < data.length; i++) {
      uis.add(ListTile(
        title: Text(
            "${data[i]["LocalizedName"]}, ${data[i]["Country"]["LocalizedName"]}"),
      ));
    }
    if (data.length == 0) {
      uis.add(ListTile(
        title: Text("No data found"),
      ));
    }
    return uis;
  }

  QueryUI({@required this.query, @required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 90, right: 10, left: 10, bottom: 10),
        children: <Widget>[
          Text(
            "Search results for \"$query\"",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).accentColor
            ),
          ),
          Column(
            children: revealData(),
          )
        ],
      ),
    );
  }
}
