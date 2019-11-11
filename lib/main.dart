import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weathify/result.dart';
import 'package:provider/provider.dart';
import 'package:weathify/state.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weathify',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Montserrat"),
        home: ChangeNotifierProvider(
            builder: (_) => WeathifyState(), child: WeathifyHomeWidget()));
  }
}

class WeathifyHomeWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final String url =
      "http://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=API_KEY&q=";
  var data;

  Future getData(WeathifyState state) async {
    state.settFetchingDataStatus(true);
    try {
      var response = await http.get(
        Uri.encodeFull("$url${_searchController.text}"),
      );

      data = json.decode(response.body);
    } catch (e) {
      return "An Error Occurrd: $e";
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<WeathifyState>(context);

    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.2,
              child: Container(child: FlutterLogo(), color: Colors.white)),
        ),
        ListView(
          padding: EdgeInsets.only(top: 130, right: 10, left: 10, bottom: 10),
          children: <Widget>[
            Text(
              "Weathify",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text("Your smart weather bot"),
            Padding(
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  children: <Widget>[
                    (state.getIsFetchingDat())
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                            ))
                        : Container(height: 0, width: 0),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _searchController,
                        cursorColor: Theme.of(context).accentColor,
                        validator: (val) {
                          return (val.isEmpty)
                              ? "You can't leave this out please"
                              : null;
                        },
                        decoration: InputDecoration(
                          labelText: "Enter a location to search",
                          suffixIcon: Icon(Icons.gps_fixed),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                    padding: EdgeInsets.all(13),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        getData(state).then((res) {
                          state.settFetchingDataStatus(false);
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (_) {
                              return QueryUI(
                                  query: _searchController.text, data: res);
                            },
                          ));
                        });
                      }
                    },
                    child: Text("Search"),
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  )),
            ),
          ],
        ),
      ]),
    );
  }
}
