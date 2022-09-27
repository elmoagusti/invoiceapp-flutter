import 'package:flutter/material.dart';
import '../ui/home.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  // const App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
