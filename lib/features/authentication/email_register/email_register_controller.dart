import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/authentication/email_register/email_register_modal.dart';
import 'package:logisticscustomer/features/authentication/email_register/email_register_repo.dart';

class AuthController extends StateNotifier<AsyncValue<EmailRegisterModal?>> {
  final AuthRepository repository;

  AuthController(this.repository) : super(const AsyncValue.data(null));

  Future<void> sendOtpToEmail(String email) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.sendOtp(email);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<EmailRegisterModal?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});
