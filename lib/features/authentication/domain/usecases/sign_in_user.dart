import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:epaisa_todo_app/core/usecases/usecase.dart';
import 'package:epaisa_todo_app/features/authentication/domain/entities/fb_user.dart';
import 'package:epaisa_todo_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SignInUser implements UseCase<FbUser, Params> {
  AuthRepository repository;

  SignInUser(this.repository);

  @override
  Future<Either<Failure, FbUser>> call(Params params) async {
    return await repository.signIn(params.email, params.password);
  }
}

class Params extends Equatable {
  final String email;
  final String password;

  Params({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
