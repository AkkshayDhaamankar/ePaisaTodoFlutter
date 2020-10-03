import 'package:epaisa_todo_app/core/usecases/usecase.dart';
import 'package:epaisa_todo_app/features/authentication/domain/repositories/auth_repository.dart';

class GetFbSignedIn implements UseCaseSimple<bool> {
  AuthRepository repository;

  GetFbSignedIn(this.repository);
  @override
  Future<bool> call() async {
    return await repository.isSignedIn();
  }
}
