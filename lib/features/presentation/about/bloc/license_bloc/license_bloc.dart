import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chatter/features/presentation/about/pages/about/components/license_data.dart';

part 'license_event.dart';

part 'license_state.dart';

class LicenseBloc extends Bloc<LicenseEvent, LicenseState> {
  LicenseBloc() : super(LicenseState(licenses: LicenseData())) {
    on<LicenseLoad>((event, emit) async {
      emit(state.copyWith(
        message: '',
        status: LicenseStateStatus.loading,
        licenses: LicenseData(),
      ));

      try {
        emit(state.copyWith(
          status: LicenseStateStatus.successful,
          message: '',
          licenses: await _buildDependenciesList(),
        ));
      } catch (error) {
        emit(state.copyWith(
          message: error.toString(),
          status: LicenseStateStatus.failed,
          licenses: LicenseData(),
        ));
      }
    });
  }
}

Future<LicenseData> _buildDependenciesList() async {
  return LicenseRegistry.licenses
      .fold<LicenseData>(
          LicenseData(),
          (final LicenseData prev, final LicenseEntry license) =>
              prev..addLicense(license))
      .then((value) => value..packages.sort());
}
