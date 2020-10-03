import 'package:dartz/dartz.dart';
import 'package:epaisa_todo_app/core/error/failures.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/usecases/get_all_todo.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseList<Type> {
  Future<Either<Failure, List<Type>>> call(Params params);
}

abstract class UseCaseSimple<Type> {
  Future<Type> call();
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
