import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/screens/categories_screen.dart';
import 'package:todo_app/screens/home_screen.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: kredColor,
              ),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/chirag.jpg")),
              accountName: Text(
                "Chirag Pandey",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              accountEmail: Text("Admin"),
            ),
            ListTile(
              title: Text(
                "Home",
                style: TextStyle(fontSize: 20),
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
                style: TextStyle(fontSize: 20),
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
    );
  }
}
