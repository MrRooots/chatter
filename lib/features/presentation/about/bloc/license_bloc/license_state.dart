part of 'license_bloc.dart';

enum LicenseStateStatus { loading, successful, failed }

final class LicenseState extends Equatable {
  final LicenseStateStatus status;
  final LicenseData licenses;
  final String message;

  const LicenseState({
    required this.licenses,
    this.status = LicenseStateStatus.loading,
    this.message = '',
  });

  @override
  List<Object> get props => [status, licenses];

  bool get isLoading => status == LicenseStateStatus.loading;

  bool get isSuccess => status == LicenseStateStatus.successful;

  bool get isFailed => status == LicenseStateStatus.failed;

  LicenseState copyWith({
    required LicenseData? licenses,
    final LicenseStateStatus? status,
    final String? message,
  }) =>
      LicenseState(
        status: status ?? this.status,
        message: message ?? this.message,
        licenses: licenses ?? this.licenses,
      );
}
