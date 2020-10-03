import 'package:dartz/dartz.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/features/authentication/domain/entities/fb_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, FbUser>> currentUser();
  Future<Either<Failure, FbUser>> signIn(String email, String password);
  Future<Either<Failure, FbUser>> createUser(String email, String password);
  Future<void> signOut();
  Future<bool> isSignedIn();
}
