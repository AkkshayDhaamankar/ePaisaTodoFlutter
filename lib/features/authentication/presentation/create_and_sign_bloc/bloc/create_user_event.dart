part of 'create_user_bloc.dart';

@immutable
abstract class CreateUserEvent extends Equatable {
  final List props1;
  const CreateUserEvent({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => props1;
}

class SignUp extends CreateUserEvent {
  final String email;
  final String password;

  SignUp({@required this.email, @required this.password})
      : super(props1: [email, password]);
}
