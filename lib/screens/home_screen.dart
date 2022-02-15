import 'dart:ui';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/helpers/drawer_navigation.dart';
import 'package:todo_app/modals/todo.dart';
import 'package:todo_app/screens/categories_screen.dart';
import 'package:todo_app/screens/todo_by_category.dart';
import 'package:todo_app/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/widgets/top_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();

  var _todoEditTitleController = TextEditingController();
  var _todoEditDescriptionController = TextEditingController();
  var _todoEditDateController = TextEditingController();

  var _selectedValue;
  var _categories = <DropdownMenuItem<Object>>[];

  var _todo = Todo();
  var todo;

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

  //calling todo service
  TodoService? _todoService;
  List<Todo> _todoList = <Todo>[];

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = <Todo>[];

    var todos = await _todoService?.readTodos();
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  @override
  initState() {
    // getAllCategories_home();
    super.initState();
    _loadCategories();
    getAllTodos();
    // getAllCategories_home();
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
                    maxLines: null,
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
                    getAllTodos();
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

  //Task Editing Function
  _editTask(BuildContext context, todoId) async {
    todo = await _todoService?.readTodosById(todoId);
    setState(() {
      _todoEditTitleController.text = todo[0]['title'] ?? "No Title";
      _todoEditDescriptionController.text =
          todo[0]['description'] ?? "No Description";
      _todoEditDateController.text = todo[0]['todoDate'] ?? "No Date";
      _editTaskDailogBox(context);
    });
  }

  // Editing Task DailogBox
  _editTaskDailogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: <Widget>[
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
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
                  _todo.id = todo[0]['id'];
                  _todo.title = _todoEditTitleController.text;
                  _todo.description = _todoEditDescriptionController.text;
                  _todo.todoDate = _todoEditDateController.text;
                  var result = await _todoService!.updateTodo(_todo);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllTodos();
                    _showSuccessSnackBar(Text(
                      "Updated Task Successfully",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                      ),
                    ));
                  }
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            title: Text(" Edit Categories "),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    maxLines: null,
                    style: GoogleFonts.roboto(),
                    controller: _todoEditTitleController,
                    decoration: InputDecoration(
                      labelText: "Titile",
                      hintText: "Write Todo Title",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLines: null,
                    style: GoogleFonts.roboto(),
                    controller: _todoEditDescriptionController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Write Description",
                    ),
                  ),
                  TextField(
                    style: GoogleFonts.roboto(),
                    controller: _todoEditDateController,
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
          );
        });
  }

  // Deleting Task
  _deleteTaskDailogBox(BuildContext context, todoId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: Text("Delete Task"),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color?>(Colors.red[400])),
              onPressed: () async {
                var result = await _todoService?.deleteTodo(todoId);
                if (result > 0) {
                  Navigator.pop(context);
                  getAllTodos();
                  _showSuccessSnackBar(Text(
                    "Deleted Todo Successfully",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    ),
                  ));
                }
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //creating a function to return gradient color
  List<Color> _getGradientColor(BuildContext context) {
    var _grad_color =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? [Colors.purple, Colors.blueAccent]
            : [Colors.purple, Colors.black12];
    return _grad_color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColor(context),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _globalKey,
        appBar: AppBar(
          toolbarHeight: 60,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          backgroundColor: kpurpleColor,
          title: Text(
            "Todo App",
            textAlign: TextAlign.center,
          ),
        ),
        drawer: DrawerNavigation(),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              //todo list
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.purple,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.purple
                      ],
                      stops: [0.0, 0.04, 0.9, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: ListView.builder(
                    itemCount: _todoList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5.0,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(_todoList[index].todoDate),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      _todoList[index].category ??
                                          "No Category",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _todoList[index].title ?? 'No Title',
                                      style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Opacity(
                                        opacity: 0.7,
                                        child: Text(
                                          _todoList[index].description ??
                                              "No Description",
                                          style: GoogleFonts.roboto(),
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      _editTask(context, _todoList[index].id);
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _deleteTaskDailogBox(
                                          context, _todoList[index].id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 3,
          backgroundColor: kpurpleColor,
          onPressed: () {
            _addDailogBox(context);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
