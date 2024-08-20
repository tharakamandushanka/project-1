import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expence.dart';
import 'package:flutter_application_1/pages/expences.dart';
import 'package:flutter_application_1/server/categories_adapter.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenceModelAdapter());
  Hive.registerAdapter(CategoriesAdapter());
  await Hive.openBox("expenceDatabase");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Expences(),
    );
  }
}
