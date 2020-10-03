import 'package:epaisa_todo_app/features/authentication/domain/repositories/auth_repository.dart';

class GetFbSignOut {
  AuthRepository repository;

  GetFbSignOut(this.repository);
  Future<void> call() async {
    return await repository.signOut();
  }
}
