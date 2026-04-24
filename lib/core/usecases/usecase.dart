import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base class for all use cases.
/// [Type] is the return type on success.
/// [Params] is the input parameter type.
abstract class UseCase<Type, Params> {
  const UseCase();

  Future<Either<Failure, Type>> call(Params params);
}