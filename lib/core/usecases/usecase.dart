import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base class for all use cases.
/// [T] is the return T on success.
/// [Params] is the input parameter T.
abstract class UseCase<T, Params> {
  const UseCase();

  Future<Either<Failure, T>> call(Params params);
}