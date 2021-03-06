import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

///Made by Abhimangal MS 26.12.2019
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: AllMoviesGrid(),
    );
  }
}

//here is the flexible grid in FutureBuilder that map each and every item and add to a gridview with ad card
class AllMoviesGrid extends StatelessWidget {
  //this is should be somewhere else but to keep things simple for you,
  Future<List> fetchAds() async {
    //the link you want to data from, goes inside get
    final response = await http.get('https://blasanka.github.io/watch-ads/lib/data/ads.json');

    if (response.statusCode == 200)
      return json.decode(response.body);
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("All Movies"),
      ),
      body: FutureBuilder<List>(
          future: fetchAds(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return new Padding(
                padding: const EdgeInsets.all(4.0),
                //this is what you actually need
                child: new StaggeredGridView.count(
                  crossAxisCount: 4, // I only need two card horizontally
                  padding: const EdgeInsets.all(2.0),
                  children: snapshot.data.map<Widget>((item) {
                    //Do you need to go somewhere when you tap on this card, wrap using InkWell and add your route
                    return new AdCard(item);
                  }).toList(),

                  //Here is the place that we are getting flexible/ dynamic card for various images
                  staggeredTiles: snapshot.data
                      .map<StaggeredTile>((_) => StaggeredTile.fit(2))
                      .toList(),
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 4.0, // add some space
                ),
              );
            } else {
              return Center(
                  child:
                  new CircularProgressIndicator()); // If there are no data show this
            }
          }),
    );
  }
}

//This is actually not need to be a StatefulWidget but in case, I have it
class AdCard extends StatefulWidget {
  AdCard(this.ad);

  final ad;

  _AdCardState createState() => _AdCardState();
}

class _AdCardState extends State<AdCard> {
  //to keep things readable
  var _ad;
  String _imageUrl;
  String _title;
  String _price;
  String _location;

  void initState() {
    setState(() {
      _ad = widget.ad;
      //if values are not null only we need to show them
      _imageUrl = (_ad['imageUrl'] != '')
          ? _ad['imageUrl']
          : 'https://uae.microless.com/cdn/no_image.jpg';
      _title = (_ad['title'] != '') ? _ad['title'] : '';
      _price = (_ad['price'] != '') ? _ad['price'] : '';
      _location = (_ad['location'] != '') ? _ad['location'] : '';
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(_imageUrl),
          Text(_title),
          Text('\$ $_price'),
          Text(_location),
        ],
      ),
    );
  }
}