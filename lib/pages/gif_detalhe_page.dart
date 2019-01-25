import 'package:flutter/material.dart';

import 'package:share/share.dart';

// É stateless pois não será modificada, não iremos poderemos interagir com ela
class GifDetalhePage extends StatelessWidget {

  final Map _gifMap;

  // Construtor
  GifDetalhePage(this._gifMap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifMap["title"]),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: () {
              Share.share(_gifMap["images"]["fixed_height"]["url"]);
          })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifMap["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
