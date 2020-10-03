part of 'add_todo_bloc.dart';

@immutable
abstract class AddTodoEvent extends Equatable {
  final List props1;
  const AddTodoEvent({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => props1;
}

class AddTodoItem extends AddTodoEvent {
  final String uid;
  final String title;
  final String description;
  final String date;
  final File image;

  AddTodoItem(
      {@required this.uid,
      @required this.title,
      @required this.description,
      @required this.date,
      @required this.image})
      : super(props1: [uid, title, description, date, image]);
}
