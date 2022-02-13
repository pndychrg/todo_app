import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/helpers/drawer_navigation.dart';
import 'package:todo_app/modals/todo.dart';
import 'package:todo_app/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();

  var _selectedValue;
  var _categories = <DropdownMenuItem<Object>>[];

  //for date and time
  DateTime _dateTime = DateTime.now();
  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(200),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat("yyyy-MM-dd").format(_pickedDate);
      });
    }
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  initState() {
    super.initState();
    _loadCategories();
  }

  //function for loading Categories
  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  //success snackbar
  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(
      content: message,
      elevation: 2,
      duration: Duration(seconds: 2),
      // behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7),
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  //Add task dailog box
  _addDailogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text("Add Task"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    style: GoogleFonts.roboto(),
                    controller: _todoTitleController,
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
                    controller: _todoDescriptionController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Write Description",
                    ),
                  ),
                  TextField(
                    style: GoogleFonts.roboto(),
                    controller: _todoDateController,
                    decoration: InputDecoration(
                      labelText: "Date",
                      hintText: "Pick a Date",
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
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
                onPressed: () {
                  Navigator.pop(context);
                  _todoTitleController.clear();
                  _todoDescriptionController.clear();
                  _todoDateController.clear();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color?>(kpurpleColor)),
                onPressed: () async {
                  var todoObject = Todo();
                  todoObject.title = _todoTitleController.text;
                  todoObject.description = _todoDescriptionController.text;
                  todoObject.isFinished = 0;
                  todoObject.category = _selectedValue.toString();
                  todoObject.todoDate = _todoDateController.text;

                  var _todoService = TodoService();
                  var result = await _todoService.saveTodo(todoObject);
                  if (result > 0) {
                    _showSuccessSnackBar(Text("Task Added Successfully"));
                    _todoTitleController.clear();
                    _todoDescriptionController.clear();
                    _todoDateController.clear();

                    Navigator.pop(context);
                  }
                },
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
      key: _globalKey,
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
