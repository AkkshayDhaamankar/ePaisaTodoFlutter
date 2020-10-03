import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:epaisa_todo_app/core/error/error_message.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/usecases/delete_todo.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'delete_todo_event.dart';
part 'delete_todo_state.dart';

class DeleteTodoBloc extends Bloc<DeleteTodoEvent, DeleteTodoState> {
  final DeleteTodo deleteTodo;
  DeleteTodoBloc({this.deleteTodo}) : super(DeleteTodoInitial());

  @override
  Stream<DeleteTodoState> mapEventToState(
    DeleteTodoEvent event,
  ) async* {
    if (event is DeleteTodoItem) {
      yield DeleteTodoLoading();
      final failureOrSignUpSuccess =
          await deleteTodo(Params(uid: event.uid, todoId: event.todoId));
      yield failureOrSignUpSuccess.fold(
          (failure) => ErrorDeleteTodo(message: _mapFailureToMessage(failure)),
          (todoItem) => DeleteTodoSuccess());
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
