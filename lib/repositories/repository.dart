import 'package:sqflite/sqflite.dart';
import "package:todo_app/repositories/database_connection.dart";

class Repository {
  late DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _databaseConnection.setDatabase();

  //Inserting Data to Table
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  //read data from table
  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  //reading data by id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  //Updating data
  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: "id=?", whereArgs: [data['id']]);
  }

  //deleting data from table
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection
        .rawDelete("DELETE FROM ${table} WHERE id= ${itemId} ");
  }

  // Read Data table by column name
  readDataByColumnName(table, columnName, columnValue) async {
    var connection = await database;
    return await connection
        .query(table, where: "${columnName}=?", whereArgs: [columnValue]);
  }
}
