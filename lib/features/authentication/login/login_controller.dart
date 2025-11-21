import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/authentication/login/login_modal.dart';
import 'package:logisticscustomer/features/authentication/login/login_repo.dart';

class LoginController extends StateNotifier<AsyncValue<LoginModel?>> {
  final LoginRepository repository;

  LoginController(this.repository) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.login(email: email, password: password);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<LoginModel?>>((ref) {
  final repo = ref.watch(loginRepositoryProvider);
  return LoginController(repo);
});
