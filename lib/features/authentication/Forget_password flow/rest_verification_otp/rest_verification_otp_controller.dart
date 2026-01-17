import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'rest_verification_otp_model.dart';
import 'rest_verification_otp_repo.dart';

class VerifyResetOtpController
    extends StateNotifier<AsyncValue<VerifyResetOtpModel?>> {
  final VerifyResetOtpRepository repository;

  VerifyResetOtpController(this.repository)
    : super(const AsyncValue.data(null));

  Future<void> verifyResetOtp(String email, String otp) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.verifyResetOtp(email: email, otp: otp);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final verifyResetOtpControllerProvider =
    StateNotifierProvider<
      VerifyResetOtpController,
      AsyncValue<VerifyResetOtpModel?>
    >((ref) {
      final repo = ref.watch(verifyResetOtpRepositoryProvider);
      return VerifyResetOtpController(repo);
    });

class ResendResetOtpController
    extends StateNotifier<AsyncValue<ResendResetOtpModel?>> {
  final ResendResetOtpRepository repository;

  ResendResetOtpController(this.repository)
    : super(const AsyncValue.data(null));

  Future<void> resendResetOtp(String email) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.resendResetOtp(email);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final resendResetOtpControllerProvider =
    StateNotifierProvider<
      ResendResetOtpController,
      AsyncValue<ResendResetOtpModel?>
    >((ref) {
      final repo = ref.watch(resendResetOtpRepositoryProvider);
      return ResendResetOtpController(repo);
    });
