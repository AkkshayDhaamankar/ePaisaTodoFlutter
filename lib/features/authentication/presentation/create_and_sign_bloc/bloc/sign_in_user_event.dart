part of 'sign_in_user_bloc.dart';

@immutable
abstract class SignInUserEvent extends Equatable {
  final List props1;
  const SignInUserEvent({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => props1;
}

class SignIn extends SignInUserEvent {
  final String email;
  final String password;

  SignIn({@required this.email, @required this.password})
      : super(props1: [email, password]);
}
