part of 'license_bloc.dart';

@immutable
abstract class LicenseEvent extends Equatable {
  const LicenseEvent();
}

final class LicenseLoad extends LicenseEvent {
  const LicenseLoad();

  @override
  List<Object?> get props => [];
}
