import 'package:dartz/dartz.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/core/usecases/usecase.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/entities/todo.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/repositories/todo_repository.dart';
import 'package:equatable/equatable.dart';

class GetAllTodo implements UseCaseList<Todo> {
  TodoRepository repository;

  GetAllTodo(this.repository);

  @override
  Future<Either<Failure, List<Todo>>> call(Params params) async {
    return await repository.getAllTodo(params.uid);
  }
}

class Params extends Equatable {
  final String uid;
  Params({this.uid});

  @override
  List<Object> get props => [uid];
}
