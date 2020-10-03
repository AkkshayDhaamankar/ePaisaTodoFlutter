import 'package:dartz/dartz.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/core/usecases/usecase.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/entities/todo.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/repositories/todo_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteTodo implements UseCase<Todo, Params> {
  TodoRepository repository;

  DeleteTodo(this.repository);
  Future<Either<Failure, Todo>> call(Params params) async {
    return await repository.deleteTodo(params.uid, params.todoId);
  }
}

class Params extends Equatable {
  final String uid;
  final String todoId;
  Params({this.uid, this.todoId});

  @override
  List<Object> get props => [uid, todoId];
}
