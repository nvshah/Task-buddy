import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './data/moor_database.dart';
import './ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (_) => AppDatabase().taskDao,
      child: MaterialApp(
        title: 'Task Buddy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}

