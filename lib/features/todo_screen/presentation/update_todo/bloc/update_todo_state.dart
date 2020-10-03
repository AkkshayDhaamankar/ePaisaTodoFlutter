part of 'update_todo_bloc.dart';

@immutable
abstract class UpdateTodoState extends Equatable {
  final List props1;
  const UpdateTodoState({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => [props1];
}

class UpdateTodoInitial extends UpdateTodoState {}

class UpdateTodoLoading extends UpdateTodoState {}

class UpdateTodoSuccess extends UpdateTodoState {}

class ErrorUpdateTodo extends UpdateTodoState {
  final String message;

  ErrorUpdateTodo({@required this.message}) : super(props1: [message]);
}
