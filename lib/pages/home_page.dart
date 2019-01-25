import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:transparent_image/transparent_image.dart';

import 'gif_detalhe_page.dart';
import 'package:share/share.dart';

const api_trending = "https://api.giphy.com/v1/gifs/trending?api_key=BSt4vv3CptPNkHbQ0AMoiND7xxTMevZB&limit=19&rating=G";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search = '';
  int _offset = 0;

  Future<Map> _getGifs () async {
    http.Response response;
    if (_search == '') {
      response = await http.get(api_trending);
    } else {
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=BSt4vv3CptPNkHbQ0AMoiND7xxTMevZB&q=$_search&limit=25&offset=$_offset&rating=G&lang=en");
    }
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Deu pau');
    }
  }


  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquisa Rápida",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: ((text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              }),
            ),
          ),
          // Ele vai ocupar o espaço restante da coluna então usa-se o Expanded
          Expanded(child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return buildListWaiting();
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return buildListOk(context, snapshot);
                    }
                }
              }
            )
          )
        ],
      ),
    );
  }

  Widget buildListWaiting() {
    return Container(
      width: 200.0,
      height: 200.0,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        // Cor do indicador
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth:  5.0,
      ),
    );
  }

  int _getCount (List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget buildListOk(context, snapshot) {
    // Igual ao list Builder
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
        //itemCount: snapshot.data["data"].length,
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if(_search == null || index < snapshot.data["data"].length) {
            // Widget para que seja possível clicar na imagem
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]1,
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: (){
                  Navigator.push(context,
                    // O construtor recebe um dado então temos que mandar um dado obrigatoriamente
                    MaterialPageRoute(builder: (context) => GifDetalhePage(snapshot.data["data"][index])
                    )
                  );
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          } else {
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70.0,),
                    Text("Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),)
                  ],
                ),
                onTap: (){
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
          }
        }
    );
  }

}












