import 'dart:io';
import 'package:epaisa_todo_app/core/error/exceptions.dart';
import 'package:epaisa_todo_app/core/network/firestore_service.dart';
import 'package:epaisa_todo_app/core/network/network_info.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/entities/todo.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/repositories/todo_repository.dart';
import 'package:meta/meta.dart';

class TodoRepositoryImpl implements TodoRepository {
  final NetworkInfo networkInfo;

  TodoRepositoryImpl({@required this.networkInfo});

  @override
  Future<Either<Failure, Todo>> createTodo(String uid, String title,
      String description, String date, File image) async {
    if (await networkInfo.isConnected) {
      try {
        print(title);
        final todoItem = await FirestoreService.addTodoItem(
            uid, title, description, date, image);
        return Right(todoItem);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Todo>> deleteTodo(String uid, String todoId) async {
    if (await networkInfo.isConnected) {
      try {
        final todoItem = await FirestoreService.deleteTodoItem(uid, todoId);
        return Right(todoItem);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getAllTodo(String uid) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(
      String uid,
      String title,
      String description,
      String date,
      File image,
      String todoId,
      String imageUrl) async {
    if (await networkInfo.isConnected) {
      try {
        print(title);
        final todoItem = await FirestoreService.updateTodoItem(
            uid, title, description, date, image, imageUrl, todoId);
        return Right(todoItem);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }
}
