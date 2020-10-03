import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<Either<Failure, Todo>> createTodo(
      String uid, String title, String description, String date, File image);
  Future<Either<Failure, Todo>> deleteTodo(String uid, String todoId);
  Future<Either<Failure, List<Todo>>> getAllTodo(String uid);
  Future<Either<Failure, Todo>> updateTodo(
      String uid,
      String title,
      String description,
      String date,
      File image,
      String todoId,
      String imageUrl);
}
