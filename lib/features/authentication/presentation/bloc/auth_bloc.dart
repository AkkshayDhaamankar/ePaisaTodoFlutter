import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:epaisa_todo_app/core/error/error_message.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/core/usecases/usecase.dart';
import 'package:epaisa_todo_app/features/authentication/domain/entities/fb_user.dart';
import 'package:epaisa_todo_app/features/authentication/domain/usecases/get_fb_signOut.dart';
import 'package:epaisa_todo_app/features/authentication/domain/usecases/get_fb_signedIn.dart';
import 'package:epaisa_todo_app/features/authentication/domain/usecases/get_fb_user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  GetFbSignedIn fbSignedIn;
  GetFbUser fbUser;
  GetFbSignOut fbSignOut;
  AuthBloc(
      {@required this.fbSignedIn,
      @required this.fbUser,
      @required this.fbSignOut})
      : super(Uninitialized());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      print("AppStarted");
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await fbSignedIn();
      if (isSignedIn) {
        final fbUserDataOrFailure = await fbUser(NoParams());
        yield fbUserDataOrFailure.fold(
            (failure) => ErrorAuth(message: _mapFailureToMessage(failure)),
            (fbUser) => Authenticated(fbUser: fbUser));
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    final fbUserDataOrFailure = await fbUser(NoParams());
    yield fbUserDataOrFailure.fold(
        (failure) => ErrorAuth(message: _mapFailureToMessage(failure)),
        (fbUser) => Authenticated(fbUser: fbUser));
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    fbSignOut();
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
