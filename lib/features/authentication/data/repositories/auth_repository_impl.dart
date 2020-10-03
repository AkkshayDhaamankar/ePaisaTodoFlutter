import 'package:epaisa_todo_app/core/error/exceptions.dart';
import 'package:epaisa_todo_app/core/network/network_info.dart';
import 'package:epaisa_todo_app/features/authentication/data/datasources/fb_auth_data_source.dart';
import 'package:epaisa_todo_app/features/authentication/domain/entities/fb_user.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:epaisa_todo_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
      {@required this.firebaseAuthDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, FbUser>> createUser(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        networkInfo.isConnected;
        final fbUser = await firebaseAuthDataSource.createUser(email, password);
        return Right(fbUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, FbUser>> currentUser() async {
    final fbUser = await firebaseAuthDataSource.currentUser();
    return Right(fbUser);
  }

  @override
  Future<Either<Failure, FbUser>> signIn(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        networkInfo.isConnected;
        final fbUser = await firebaseAuthDataSource.signIn(email, password);
        return Right(fbUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<void> signOut() async {
    return await firebaseAuthDataSource.signOut();
  }

  @override
  Future<bool> isSignedIn() async {
    return await firebaseAuthDataSource.isSignedIn();
  }
}
