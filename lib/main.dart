import 'package:flutter/material.dart';
import 'package:flutter_buscador_gifs/pages/home_page.dart';

void main () {
  runApp(MaterialApp(
      home: HomePage(),
      theme: ThemeData(primaryColor: Colors.blueAccent, hintColor: Colors.white)
  ));
}