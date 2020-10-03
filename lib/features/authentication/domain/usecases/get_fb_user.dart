import 'package:dartz/dartz.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/core/usecases/usecase.dart';
import 'package:epaisa_todo_app/features/authentication/domain/entities/fb_user.dart';
import 'package:epaisa_todo_app/features/authentication/domain/repositories/auth_repository.dart';

class GetFbUser implements UseCase<FbUser, NoParams> {
  AuthRepository repository;

  GetFbUser(this.repository);

  @override
  Future<Either<Failure, FbUser>> call(NoParams params) async {
    return await repository.currentUser();
  }
}
