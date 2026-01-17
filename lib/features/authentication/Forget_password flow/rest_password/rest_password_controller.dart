import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rest_password_model.dart';
import 'rest_password_repo.dart';

class RestPasswordController
    extends StateNotifier<AsyncValue<RestPasswordModel?>> {
  final RestPasswordRepository repository;

  RestPasswordController(this.repository) : super(const AsyncValue.data(null));

  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.resetPassword(
        token: token,
        password: password,
        confirmPassword: confirmPassword,
      );
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final restPasswordControllerProvider =
    StateNotifierProvider<
      RestPasswordController,
      AsyncValue<RestPasswordModel?>
    >((ref) {
      final repo = ref.watch(restPasswordRepositoryProvider);
      return RestPasswordController(repo);
    });
