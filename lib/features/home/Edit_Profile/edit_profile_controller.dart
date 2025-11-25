import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'edit_profile_repo.dart';
import 'edit_profile_modal.dart';

final editProfileControllerProvider =
    StateNotifierProvider<
      EditProfileController,
      AsyncValue<UpdateProfileModel?>
    >((ref) {
      final repo = ref.watch(editProfileRepositoryProvider);
      return EditProfileController(repo);
    });

class EditProfileController
    extends StateNotifier<AsyncValue<UpdateProfileModel?>> {
  final EditProfileRepository repo;
  EditProfileController(this.repo) : super(const AsyncValue.loading()) {
    getProfile();
  }

  Future<void> getProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await repo.getProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String dob,
    File? image,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await repo.updateProfile(
        name: name,
        phone: phone,
        dob: dob,
        image: image,
      );
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
