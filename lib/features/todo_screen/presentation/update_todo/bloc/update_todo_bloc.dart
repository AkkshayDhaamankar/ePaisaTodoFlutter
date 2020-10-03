import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:epaisa_todo_app/core/error/error_message.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/usecases/update_todo.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'update_todo_event.dart';
part 'update_todo_state.dart';

class UpdateTodoBloc extends Bloc<UpdateTodoEvent, UpdateTodoState> {
  final UpdateTodo updateTodo;
  UpdateTodoBloc({this.updateTodo}) : super(UpdateTodoInitial());

  @override
  Stream<UpdateTodoState> mapEventToState(
    UpdateTodoEvent event,
  ) async* {
    if (event is UpdateTodoItem) {
      yield UpdateTodoLoading();
      final failureOrSignUpSuccess = await updateTodo(Params(
          todoId: event.todoId,
          title: event.title,
          uid: event.uid,
          image: event.image,
          description: event.description,
          date: event.date,
          imageUrl: event.imageUrl));
      yield failureOrSignUpSuccess.fold(
          (failure) => ErrorUpdateTodo(message: _mapFailureToMessage(failure)),
          (todoList) => UpdateTodoSuccess());
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
