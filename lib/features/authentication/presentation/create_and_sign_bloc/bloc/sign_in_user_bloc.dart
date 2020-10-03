import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:epaisa_todo_app/core/error/error_message.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/features/authentication/domain/entities/fb_user.dart';
import 'package:epaisa_todo_app/features/authentication/domain/usecases/sign_in_user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'sign_in_user_event.dart';
part 'sign_in_user_state.dart';

class SignInUserBloc extends Bloc<SignInUserEvent, SignInUserState> {
  final SignInUser signInUser;
  SignInUserBloc({@required this.signInUser}) : super(SignInUserInitial());

  @override
  Stream<SignInUserState> mapEventToState(
    SignInUserEvent event,
  ) async* {
    if (event is SignIn) {
      yield SignInUserLoading();
      final failureOrSignInSuccess = await signInUser(
          Params(email: event.email, password: event.password));
      yield failureOrSignInSuccess.fold(
          (failure) => ErrorSignInUser(message: _mapFailureToMessage(failure)),
          (fbUser) => SignInUserSuccess(fbUser: fbUser));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    print("Error Auth");
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
