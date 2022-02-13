import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/helpers/drawer_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var todoTitleController = TextEditingController();
  var todoDescriptionController = TextEditingController();
  var todoDateController = TextEditingController();

  var _selectedValue;

  var _categories;
  _addDailogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text("Create Todo"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    style: GoogleFonts.roboto(),
                    controller: todoTitleController,
                    decoration: InputDecoration(
                      labelText: "Titile",
                      hintText: "Write Todo Title",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    style: GoogleFonts.roboto(),
                    controller: todoDescriptionController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Write Description",
                    ),
                  ),
                  TextField(
                    style: GoogleFonts.roboto(),
                    controller: todoDateController,
                    decoration: InputDecoration(
                      labelText: "Date",
                      hintText: "Pick a Date",
                      prefixIcon: InkWell(
                        onTap: () {},
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  DropdownButtonFormField(
                    value: _selectedValue,
                    items: _categories,
                    hint: Text("Category"),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color?>(kpurpleColor)),
                onPressed: () {},
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addDailogBox(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
