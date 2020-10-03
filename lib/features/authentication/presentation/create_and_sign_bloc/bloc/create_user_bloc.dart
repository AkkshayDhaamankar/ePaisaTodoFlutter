import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:epaisa_todo_app/core/error/error_message.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/features/authentication/domain/entities/fb_user.dart';
import 'package:epaisa_todo_app/features/authentication/domain/usecases/create_fb_user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'create_user_event.dart';
part 'create_user_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  final CreateFbUser createFbUser;
  CreateUserBloc({@required this.createFbUser}) : super(CreateUserInitial());

  @override
  Stream<CreateUserState> mapEventToState(
    CreateUserEvent event,
  ) async* {
    if (event is SignUp) {
      yield CreateUserLoading();
      final failureOrSignUpSuccess = await createFbUser(
          Params(email: event.email, password: event.password));
      yield failureOrSignUpSuccess.fold(
          (failure) => ErrorCreateUser(message: _mapFailureToMessage(failure)),
          (fbUser) => CreateUserSuccess(fbUser: fbUser));
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
