import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/authentication/otp/verify_otp_modal.dart';
import 'package:logisticscustomer/features/authentication/otp/verify_otp_repo.dart';

class VerifyOtpController extends StateNotifier<AsyncValue<VerifyOtpModel?>> {
  final VerifyOtpRepository repository;

  VerifyOtpController(this.repository) : super(const AsyncValue.data(null));

  Future<void> verifyOtp(String email, String otp) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.verifyOtp(email: email, otp: otp);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final verifyOtpControllerProvider =
    StateNotifierProvider<VerifyOtpController, AsyncValue<VerifyOtpModel?>>((
      ref,
    ) {
      final repo = ref.watch(verifyOtpRepositoryProvider);
      return VerifyOtpController(repo);
    });

// Resent OTP

class ResendOtpController extends StateNotifier<AsyncValue<ResendOtpModel?>> {
  final ResendOtpRepository repository;

  ResendOtpController(this.repository) : super(const AsyncValue.data(null));

  Future<void> resendOtp(String email) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.resendOtp(email);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final resendOtpControllerProvider =
    StateNotifierProvider<ResendOtpController, AsyncValue<ResendOtpModel?>>((
      ref,
    ) {
      final repo = ref.watch(resendOtpRepositoryProvider);
      return ResendOtpController(repo);
    });
