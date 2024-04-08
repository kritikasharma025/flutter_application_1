import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home.dart';

import 'package:flutter_application_1/screens/todo_list.dart';

// ignore: unnecessary_import
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  // init the hive
  await Hive.initFlutter();

  // ignore: unused_local_variable
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ignore: prefer_const_constructors
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.yellow),
    );
  }
}
