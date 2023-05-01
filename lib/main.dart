import 'package:aqua_phoenix/provider/provider.dart';
import 'package:aqua_phoenix/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Mqttprovider(),
        )
      ],
      child: MaterialApp(
        home: Homepage(),
      ),
    );
  }
}
