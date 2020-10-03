part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  final List props1;
  const AuthState({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => [props1];
}

class Uninitialized extends AuthState {}

class Authenticated extends AuthState {
  final FbUser fbUser;

  Authenticated({@required this.fbUser}) : super(props1: [fbUser]);
}

class Unauthenticated extends AuthState {}

class ErrorAuth extends AuthState {
  final String message;

  ErrorAuth({@required this.message}) : super(props1: [message]);
}
