import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/modals/todo.dart';

class TaskPopUp extends StatelessWidget {
  final Todo todo;
  const TaskPopUp({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Container(
        height: 170,
        child: Card(
          elevation: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      todo.title,
                      style: GoogleFonts.roboto(
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 3,
                height: 0,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Desc: ",
                    style: GoogleFonts.lato(
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    todo.description,
                    style: GoogleFonts.lato(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Text("Category: "),
                  Text(todo.category ?? "No Description"),
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Text("Date: "),
                  Text(todo.todoDate ?? "No Date"),
                ],
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
