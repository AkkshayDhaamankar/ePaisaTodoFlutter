part of 'add_todo_bloc.dart';

@immutable
abstract class AddTodoState extends Equatable {
  final List props1;
  const AddTodoState({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => [props1];
}

class AddTodoInitial extends AddTodoState {}

class AddTodoLoading extends AddTodoState {}

class AddTodoSuccess extends AddTodoState {
  final Todo todo;

  AddTodoSuccess({@required this.todo}) : super(props1: [todo]);
}

class ErrorAddTodo extends AddTodoState {
  final String message;

  ErrorAddTodo({@required this.message}) : super(props1: [message]);
}
