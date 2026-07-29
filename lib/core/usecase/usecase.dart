import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Contract every use case must follow: one execution method, typed
/// input Params, typed Type result wrapped in Either<Failure, Type>.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Marker for use cases that take no parameters.
class NoParams {
  const NoParams();
}
