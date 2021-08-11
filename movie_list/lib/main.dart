import 'package:flutter/material.dart';
import 'package:movie_list/screens/login_screen.dart';
import 'package:movie_list/screens/photo_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple
      ),
      home: LoginScreen(),
    );
  }
}