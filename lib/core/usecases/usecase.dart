import 'package:chatter/core/exceptions/failures.dart';
import 'package:dartz/dartz.dart';

/// Interface for all use cases with params
abstract class UseCase<Type, Params> {
  Future<Either<Type, Failure>> call(Params params);
}

/// Interface for all use cases without any params
abstract class UseCaseWithoutParams<Type> {
  Future<Either<Type, Failure>> call();
}
