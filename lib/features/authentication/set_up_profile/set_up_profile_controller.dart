import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'set_up_profile_repo.dart';
import 'set_up_profile_modal.dart';

class SetUpProfileController
    extends StateNotifier<AsyncValue<SetUpProfileModel?>> {
  final SetUpProfileRepository repository;

  SetUpProfileController(this.repository) : super(const AsyncValue.data(null));

  Future<void> completeProfile({
    required String verificationToken,
    required String name,
    required String phone,
    required String dob,
    File? profilePhoto,
  }) async {
    state = const AsyncLoading();

    try {
      final result = await repository.completeProfile(
        verificationToken: verificationToken,
        name: name,
        phone: phone,
        dob: dob,
        profilePhoto: profilePhoto,
      );

      // ---- TOKEN SAVE KARNA (NULL-SAFE) ----
      final token = result.data?.accessToken;

      if (token != null && token.isNotEmpty) {
        await LocalStorage.saveToken(token);
        print("🎉 Token Saved Successfully => $token");
      } else {
        print("⚠️ Token NULL or EMPTY — NOT Saved");
      }

      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final setUpProfileControllerProvider =
    StateNotifierProvider<
      SetUpProfileController,
      AsyncValue<SetUpProfileModel?>
    >((ref) {
      final repo = ref.watch(setUpProfileRepositoryProvider);
      return SetUpProfileController(repo);
    });

// dropdown

// company_controller.dart
class CompanyController extends StateNotifier<AsyncValue<CompanyData>> {
  final CompanyRepository _repository;

  CompanyController(this._repository) : super(const AsyncValue.loading()) {
    loadCompanies();
  }

  Future<void> loadCompanies() async {
    try {
      state = const AsyncValue.loading();
      final response = await _repository.getCompanies();
      state = AsyncValue.data(response.data);
    } catch (e, stackTrace) {
      print("Error in CompanyController: $e");
      print("Stack trace: $stackTrace");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void refresh() {
    loadCompanies();
  }
}

final companyControllerProvider =
    StateNotifierProvider<CompanyController, AsyncValue<CompanyData>>((ref) {
      final repository = ref.watch(companyRepositoryProvider);
      return CompanyController(repository);
    });
