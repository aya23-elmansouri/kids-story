import 'package:flutter/material.dart';
import 'start_screen.dart'; 

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.pink),
    home: StartScreen(),
  ));
}
