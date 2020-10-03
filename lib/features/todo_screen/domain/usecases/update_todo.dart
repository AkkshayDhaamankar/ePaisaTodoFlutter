import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/core/usecases/usecase.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/entities/todo.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/repositories/todo_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateTodo implements UseCase<Todo, Params> {
  TodoRepository repository;

  UpdateTodo(this.repository);
  @override
  Future<Either<Failure, Todo>> call(Params params) async {
    return await repository.updateTodo(
        params.uid,
        params.title,
        params.description,
        params.date,
        params.image,
        params.todoId,
        params.imageUrl);
  }
}

class Params extends Equatable {
  final String uid;
  final String title;
  final String description;
  final String date;
  final File image;
  final String todoId;
  final String imageUrl;
  Params(
      {this.uid,
      this.title,
      this.description,
      this.date,
      this.image,
      this.todoId,
      this.imageUrl});

  @override
  List<Object> get props =>
      [uid, title, description, date, image, todoId, imageUrl];
}
