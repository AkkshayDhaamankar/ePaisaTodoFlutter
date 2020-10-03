part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  final List props1;
  const AuthEvent({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => props1;
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {}

class LoggedOut extends AuthEvent {}
