part of 'create_user_bloc.dart';

@immutable
abstract class CreateUserState extends Equatable {
  final List props1;
  const CreateUserState({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => [props1];
}

class CreateUserInitial extends CreateUserState {}

class CreateUserLoading extends CreateUserState {}

class CreateUserSuccess extends CreateUserState {
  final FbUser fbUser;

  CreateUserSuccess({@required this.fbUser}) : super(props1: [fbUser]);
}

class ErrorCreateUser extends CreateUserState {
  final String message;

  ErrorCreateUser({@required this.message}) : super(props1: [message]);
}
