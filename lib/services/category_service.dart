import 'package:flutter/foundation.dart';
import 'package:todo_app/modals/category.dart';
import 'package:todo_app/repositories/repository.dart';

class CategoryService {
  late Repository _repository;

  CategoryService() {
    _repository = Repository();
  }
  //saving the category
  saveCategory(Categories category) async {
    return await _repository.insertData("categories", category.categoryMap());
  }

  //getting the category from database
  readCategories() async {
    return await _repository.readData('categories');
  }

  readCategoryById(categoryId) async {
    return await _repository.readDataById('categories', categoryId);
  }

  updateCategory(Categories category) async {
    return await _repository.updateData('categories', category.categoryMap());
  }
}
