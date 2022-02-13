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
        _todoList.add(model);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTodosByCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _todoList[index].title ?? 'No Title',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                subtitle: Opacity(
                  opacity: 0.5,
                  child: Text(
                    _todoList[index].description ?? "No Description",
                    style: GoogleFonts.roboto(),
                  ),
                ),
                trailing: Text(_todoList[index].todoDate),
              ),
            ),
          );
        },
      ),
    );
  }
}
