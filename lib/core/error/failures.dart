import 'package:equatable/equatable.dart';

/// Base type returned to the presentation layer on any failure.
/// The UI never sees raw exceptions — only these typed Failures,
/// so Cubits can render the right state (network/server/unknown) safely.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on the server.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}

class ExportFailure extends Failure {
  const ExportFailure([super.message = 'Could not export data to Excel.']);
}
