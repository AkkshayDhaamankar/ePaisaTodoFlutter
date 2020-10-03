part of 'sign_in_user_bloc.dart';

@immutable
abstract class SignInUserState extends Equatable {
  final List props1;
  const SignInUserState({this.props1 = const <dynamic>[]});

  @override
  List<Object> get props => [props1];
}

class SignInUserInitial extends SignInUserState {}

class SignInUserLoading extends SignInUserState {}

class SignInUserSuccess extends SignInUserState {
  final FbUser fbUser;

  SignInUserSuccess({@required this.fbUser}) : super(props1: [fbUser]);
}

class ErrorSignInUser extends SignInUserState {
  final String message;

  ErrorSignInUser({@required this.message}) : super(props1: [message]);
}
