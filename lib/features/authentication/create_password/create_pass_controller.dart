import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/authentication/create_password/create_pass_modal.dart';
import 'package:logisticscustomer/features/authentication/create_password/create_pass_repo.dart';

class CreatePasswordController
    extends StateNotifier<AsyncValue<CreatePasswordModel?>> {
  final CreatePasswordRepository repository;

  CreatePasswordController(this.repository)
      : super(const AsyncValue.data(null));

  Future<void> createPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.createPassword(
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

final createPasswordControllerProvider = StateNotifierProvider<
    CreatePasswordController, AsyncValue<CreatePasswordModel?>>((ref) {
  final repo = ref.watch(createPasswordRepositoryProvider);
  return CreatePasswordController(repo);
});
