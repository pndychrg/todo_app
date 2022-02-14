import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/modals/todo.dart';

class TaskPopUp extends StatelessWidget {
  final Todo todo;
  const TaskPopUp({Key? key, required this.todo}) : super(key: key);

  _showTaskEditDailog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black45),
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        height: 300,
        width: 350,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
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
                      maxLines: 2,
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
              Spacer(
                flex: 1,
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
                  Expanded(
                    child: Text(
                      todo.description ?? "No Description",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Text("Category: "),
                  Text(todo.category ?? "No Description"),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Text("Date: "),
                  Text(todo.todoDate ?? "No Date"),
                ],
              ),
              Spacer(
                flex: 4,
              ),
              //  Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: <Widget>[
              //     Spacer(
              //       flex: 3,
              //     ),
              //     OutlinedButton(
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //       child: Text(
              //         "Close",
              //         style: GoogleFonts.lato(
              //             color: MediaQuery.of(context).platformBrightness ==
              //                     Brightness.light
              //                 ? Colors.black
              //                 : Colors.white),
              //       ),
              //     ),
              //     Spacer(),
              //     OutlinedButton(
              //       style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.all<Color?>(
              //               Colors.lightBlue[400])),
              //       onPressed: () {
              //         // Navigator.pop(context);
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: ((context) =>
              //                     _showTaskEditDailog(context))));
              //       },
              //       child: Text("Edit",
              //           style: GoogleFonts.lato(
              //             color: Colors.white,
              //           )),
              //     ),
              //     Spacer(),
              //     OutlinedButton(
              //       style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all<Color?>(kredColor)),
              //       onPressed: () {},
              //       child: Text("Delete",
              //           style: GoogleFonts.lato(
              //             color: Colors.white,
              //           )),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
