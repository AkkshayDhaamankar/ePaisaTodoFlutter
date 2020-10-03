import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:epaisa_todo_app/core/error/error_message.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/entities/todo.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/usecases/create_todo.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'add_todo_event.dart';
part 'add_todo_state.dart';

class AddTodoBloc extends Bloc<AddTodoEvent, AddTodoState> {
  final CreateTodo createTodo;
  AddTodoBloc({this.createTodo}) : super(AddTodoInitial());

  @override
  Stream<AddTodoState> mapEventToState(
    AddTodoEvent event,
  ) async* {
    if (event is AddTodoItem) {
      yield AddTodoLoading();
      final failureOrSignUpSuccess = await createTodo(Params(
          uid: event.uid,
          title: event.title,
          description: event.description,
          image: event.image,
          date: event.date));

      yield failureOrSignUpSuccess.fold(
          (failure) => ErrorAddTodo(message: _mapFailureToMessage(failure)),
          (todoItem) => AddTodoSuccess(todo: todoItem));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    print("Error Auth");
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
