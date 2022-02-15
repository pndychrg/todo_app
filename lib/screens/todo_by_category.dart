import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/modals/todo.dart';
import 'package:todo_app/services/todo_service.dart';

class TodosByCategory extends StatefulWidget {
  final String category;

  const TodosByCategory({Key? key, required this.category}) : super(key: key);

  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = <Todo>[];
  TodoService _todoService = TodoService();
  getTodosByCategories() async {
    var todos = await _todoService.readTodosByCategory(this.widget.category);
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        model.description = todo['decription'];
        model.todoDate = todo['todoDate'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        _todoList.add(model);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTodosByCategories();
  }

  //background gradient color
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
        appBar: AppBar(
          backgroundColor: kpurpleColor,
          title: Text(this.widget.category),
        ),
        body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5.0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(_todoList[index].todoDate),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            _todoList[index].category ?? "No Category",
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
                            padding: EdgeInsets.only(left: 10, right: 10),
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
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
