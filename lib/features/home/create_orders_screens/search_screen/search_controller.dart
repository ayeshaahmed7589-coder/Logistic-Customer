import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/delivery_detail_screen.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/search_screen/search_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/search_screen/search_repo.dart';

class ShopifySearchController
    extends StateNotifier<AsyncValue<ShopifySearchModel?>> {
  final ShopifySearchRepo repo;

  ShopifySearchController({required this.repo})
    : super(const AsyncValue.data(null));

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    state = const AsyncValue.loading();

    try {
      final result = await repo.searchProducts(query);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final shopifySearchControllerProvider =
    StateNotifierProvider<
      ShopifySearchController,
      AsyncValue<ShopifySearchModel?>
    >((ref) {
      return ShopifySearchController(
        repo: ref.watch(shopifySearchRepoProvider),
      );
    });

///
class PackageItemsController extends StateNotifier<List<PackageItem>> {
  PackageItemsController() : super([]);

  void addItem(PackageItem item) {
    state = [...state, item];
  }

  void removeItem(int index) {
    state = [...state]..removeAt(index);
  }

  void clear() {
    state = [];
  }
}

final packageItemsProvider =
    StateNotifierProvider<PackageItemsController, List<PackageItem>>(
      (ref) => PackageItemsController(),
    );
