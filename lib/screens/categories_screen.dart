import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  var _editcategoryNameController = TextEditingController();
  var _editcategoryDescriptionController = TextEditingController();

  var _category = Categories();
  var _categoryService = CategoryService();
  var category;

  List<Categories> _categoryList = <Categories>[];

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  //getting all categories from the Database
  getAllCategories() async {
    _categoryList = <Categories>[];
    var categories = await _categoryService.readCategories();
    categories.forEach((categories) {
      setState(() {
        var categoryModel = Categories();
        categoryModel.name = categories['name'];
        categoryModel.description = categories['description'];
        categoryModel.id = categories['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  //Editing Category in the Database
  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editcategoryNameController.text = category[0]['name'] ?? "No Name";
      _editcategoryDescriptionController.text =
          category[0]['description'] ?? "No Description";
    });
    _showEditDailog(context);
  }

  //adding the Categories alert box
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
                onPressed: () async {
                  if (_categoryNameController.text == '') {
                    Navigator.pop(context);
                  } else {
                    _category.name = _categoryNameController.text;
                    _category.description = _categoryDescriptionController.text;
                    // _categoryService.saveCategory(_category);
                    var result = await _categoryService.saveCategory(_category);
                    getAllCategories();
                    Navigator.pop(context);
                  }
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

  //editing the categories edit box
  _showEditDailog(BuildContext context) {
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
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _editcategoryNameController.text;
                  _category.description =
                      _editcategoryDescriptionController.text;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(Text(
                      "Updated The Category",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                      ),
                    ));
                  }
                },
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            title: Text(
              " Edit Categories ",
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editcategoryNameController,
                    decoration: InputDecoration(
                      hintText: "Write A Category",
                      labelText: "Category",
                    ),
                  ),
                  TextField(
                    controller: _editcategoryDescriptionController,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
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
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5.0,
              child: ListTile(
                title: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 2,
                    ),
                    Expanded(
                      child: Text(
                        _categoryList[index].name,
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editCategory(context, _categoryList[index].id);
                      },
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
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
