part of 'delete_todo_bloc.dart';

@immutable
abstract class DeleteTodoState extends Equatable {
  final List props1;
  const DeleteTodoState({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => [props1];
}

class DeleteTodoInitial extends DeleteTodoState {}

class DeleteTodoLoading extends DeleteTodoState {}

class DeleteTodoSuccess extends DeleteTodoState {}

class ErrorDeleteTodo extends DeleteTodoState {
  final String message;

  ErrorDeleteTodo({@required this.message}) : super(props1: [message]);
}
