import 'package:todo_app/modals/todo.dart';
import 'package:todo_app/repositories/repository.dart';

class TodoService {
  late Repository _repository;

  TodoService() {
    _repository = Repository();
  }
  //saving task
  saveTodo(Todo todo) async {
    return await _repository.insertData("todos", todo.todoMap());
  }

  //reading tasks
  readTodos() async {
    return await _repository.readData("todos");
  }

  //read todos by category
  readTodosByCategory(category) async {
    return await _repository.readDataByColumnName(
        'todos', 'category', category);
  }
}
