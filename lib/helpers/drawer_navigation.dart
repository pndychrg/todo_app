import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/screens/categories_screen.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/todo_by_category.dart';
import 'package:todo_app/services/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList = <Widget>[];

  CategoryService _categoryService = CategoryService();

  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new TodosByCategory(
                        category: category['name'],
                      ))),
          child: Card(
            child: ListTile(
              leading: Icon(
                Icons.arrow_right,
              ),
              title: Text(
                category['name'],
                style:
                    GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ));
      });
    });
  }

//creating a function to return gradient color
  List<Color> _getGradientColor(BuildContext context) {
    var _grad_color =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? [Colors.white10, Colors.lightBlue]
            : [Colors.blueGrey.shade900.withOpacity(0.7), Colors.black12];
    return _grad_color;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColor(context),
          ),
        ),
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    leading: Icon(
                      Icons.home,
                      size: 30,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    leading: Icon(
                      Icons.view_list,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesScreen()));
                    },
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 5,
            ),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      ),
    );
  }
}
