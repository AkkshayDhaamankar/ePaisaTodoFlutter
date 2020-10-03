part of 'delete_todo_bloc.dart';

@immutable
abstract class DeleteTodoEvent extends Equatable {
  final List props1;
  const DeleteTodoEvent({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => props1;
}

class DeleteTodoItem extends DeleteTodoEvent {
  final String todoId;
  final String uid;
  DeleteTodoItem({
    @required this.todoId,
    @required this.uid,
  }) : super(props1: [todoId, uid]);
}
