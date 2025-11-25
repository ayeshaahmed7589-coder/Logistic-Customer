import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'get_profile_repo.dart';
import 'get_profile_model.dart';

final getProfileControllerProvider =
    StateNotifierProvider<GetProfileController, AsyncValue<GetProfileModel?>>(
        (ref) {
  final repo = ref.watch(getProfileRepositoryProvider);
  return GetProfileController(repo);
});

class GetProfileController
    extends StateNotifier<AsyncValue<GetProfileModel?>> {
  final GetProfileRepository repository;

  GetProfileController(this.repository)
      : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();

    try {
      final data = await repository.getProfile();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
