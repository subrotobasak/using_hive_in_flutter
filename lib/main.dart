import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:using_hive_in_flutter/screens/home_page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HIVE in Flutter',
      home: HomePage(),
    );
  }
}
