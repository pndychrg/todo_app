import 'package:todo_app/modals/todo.dart';
import 'package:todo_app/repositories/repository.dart';

class TodoService {
  late Repository _repository;

  TodoService() {
    _repository = Repository();
  }
  saveTodo(Todo todo) async {
    return await _repository.insertData("todos", todo.todoMap());
  }
}
