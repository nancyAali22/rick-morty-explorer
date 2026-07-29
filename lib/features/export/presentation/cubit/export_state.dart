import 'package:equatable/equatable.dart';

enum ExportStatus { idle, exporting, success, error }

class ExportState extends Equatable {
  final ExportStatus status;
  final String? filePath;
  final String? errorMessage;

  const ExportState({
    this.status = ExportStatus.idle,
    this.filePath,
    this.errorMessage,
  });

  factory ExportState.idle() => const ExportState();

  ExportState copyWith({
    ExportStatus? status,
    String? filePath,
    String? errorMessage,
  }) {
    return ExportState(
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, filePath, errorMessage];
}
