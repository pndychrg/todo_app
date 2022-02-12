import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/modals/category.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  _showFormDailog(BuildContext context) {
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
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color?>(kpurpleColor)),
                onPressed: () {
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  _categoryService.saveCategory(_category);
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            title: Text(
              "Categories Form",
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                      hintText: "Write A Category",
                      labelText: "Category",
                    ),
                  ),
                  TextField(
                    controller: _categoryDescriptionController,
                    decoration: InputDecoration(
                      hintText: "Write A Description",
                      labelText: "Description",
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kpurpleColor),
            elevation: MaterialStateProperty.all(0.0),
          ),
          onPressed: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: kpurpleColor,
        title: Text("Categories"),
      ),
      body: Center(
        child: Text("Welcome the Categories Screen"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kpurpleColor,
        onPressed: () {
          _showFormDailog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
