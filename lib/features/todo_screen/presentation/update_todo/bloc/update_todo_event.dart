part of 'update_todo_bloc.dart';

@immutable
abstract class UpdateTodoEvent extends Equatable {
  final List props1;
  const UpdateTodoEvent({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => props1;
}

class UpdateTodoItem extends UpdateTodoEvent {
  final String todoId;
  final String uid;
  final String title;
  final String description;
  final String date;
  final File image;
  final String imageUrl;
  UpdateTodoItem({
    @required this.uid,
    @required this.title,
    @required this.description,
    @required this.date,
    @required this.image,
    @required this.imageUrl,
    @required this.todoId,
  }) : super(props1: [todoId, uid, title, description, date, image, imageUrl]);
}
