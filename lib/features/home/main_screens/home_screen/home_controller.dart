import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/home_modal.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/home_repo.dart';

class DashboardController extends StateNotifier<AsyncValue<DashboardModel?>> {
  final DashboardRepository repository;

  DashboardController(this.repository)
      : super(const AsyncValue.loading());

  Future<void> loadDashboard() async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.getDashboard();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, AsyncValue<DashboardModel?>>(
  (ref) {
    final repo = ref.watch(dashboardRepositoryProvider);
    return DashboardController(repo);
  },
);
