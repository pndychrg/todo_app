import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/helpers/drawer_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kpurpleColor,
        title: Text(
          "Todo App",
          textAlign: TextAlign.center,
        ),
      ),
      drawer: DrawerNavigation(),
    );
  }
}
