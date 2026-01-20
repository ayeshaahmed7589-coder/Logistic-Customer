import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown/product_type_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown/product_type_repo.dart';

// product Type Controller
class ProductTypeController
    extends StateNotifier<AsyncValue<List<ProductTypeCategory>>> {
  final ProductTypeRepository repository;

  ProductTypeController(this.repository) : super(const AsyncValue.loading());

  Future<void> loadProductTypes() async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.getProductTypes();

      // Set categoryLabel for each product
      final updatedCategories = response.data.map((category) {
        return ProductTypeCategory(
          category: category.category,
          categoryLabel: category.categoryLabel,
          products: category.products.map((product) {
            return ProductTypeItem(
              id: product.id,
              name: product.name,
              category: product.category,
              description: product.description,
              baseValueMultiplier: product.baseValueMultiplier,
              icon: product.icon,
              categoryLabel: category.categoryLabel, // Set category label
            );
          }).toList(),
        );
      }).toList();

      state = AsyncValue.data(updatedCategories);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Get all items from all categories
  List<ProductTypeItem> getAllItems() {
    return state.when(
      data: (categories) {
        final allItems = <ProductTypeItem>[];
        for (final category in categories) {
          // Add category label as header
          final headerItem = ProductTypeItem(
            id: -1, // Special ID for header
            name: category.categoryLabel,
            category: category.category,
            description: 'Category: ${category.categoryLabel}',
            baseValueMultiplier: 0.0,
            icon: 'category',
            categoryLabel: category.categoryLabel,
          );

          allItems.add(headerItem);
          allItems.addAll(category.products);
        }
        return allItems;
      },
      loading: () => [],
      error: (error, stackTrace) => [],
    );
  }

  // Get items for dropdown (without headers)
  List<ProductTypeItem> getItemsForDropdown() {
    return state.when(
      data: (categories) =>
          categories.expand((category) => category.products).toList(),
      loading: () => [],
      error: (error, stackTrace) => [],
    );
  }

  // Get items grouped by category
  Map<String, List<ProductTypeItem>> getItemsGroupedByCategory() {
    return state.when(
      data: (categories) {
        final map = <String, List<ProductTypeItem>>{};
        for (final category in categories) {
          map[category.categoryLabel] = category.products;
        }
        return map;
      },
      loading: () => {},
      error: (error, stackTrace) => {},
    );
  }
}

// Update providers
final productTypeControllerProvider =
    StateNotifierProvider<
      ProductTypeController,
      AsyncValue<List<ProductTypeCategory>>
    >((ref) {
      final repo = ref.watch(productTypeRepositoryProvider);
      return ProductTypeController(repo);
    });

final productTypeItemsProvider = Provider<List<ProductTypeItem>>((ref) {
  final controller = ref.watch(productTypeControllerProvider.notifier);
  return controller.getAllItems();
});

final productTypeCategoriesProvider = Provider<List<String>>((ref) {
  final state = ref.watch(productTypeControllerProvider);
  return state.when(
    data: (categories) =>
        categories.map((category) => category.categoryLabel).toList(),
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

///////////////////////////////////////
// package Type Controller

class PackagingTypeController extends StateNotifier<AsyncValue<List<PackagingTypeItem>>> {
  final PackagingTypeRepository repository;

  PackagingTypeController(this.repository) : super(const AsyncValue.loading());

  Future<void> loadPackagingTypes() async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.getPackagingTypes();
      state = AsyncValue.data(response.data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Search packaging types
  Future<List<PackagingTypeItem>> searchPackagingTypes(String query) async {
    try {
      final response = await repository.getPackagingTypes();
      final allItems = response.data;

      if (query.isEmpty) {
        return allItems;
      }

      return allItems.where((item) => item.matchesSearch(query)).toList();
    } catch (e) {
      return [];
    }
  }

  // Get item by ID
  PackagingTypeItem? getItemById(int id) {
    return state.when(
      data: (items) => items.firstWhere(
        (item) => item.id == id,
        orElse: () => throw Exception("Item not found"),
      ),
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  // Get item by name
  PackagingTypeItem? getItemByName(String name) {
    return state.when(
      data: (items) => items.firstWhere(
        (item) => item.name == name,
        orElse: () => throw Exception("Item not found"),
      ),
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  // Refresh
  Future<void> refresh() async {
    return loadPackagingTypes();
  }
}

// Update providers
final packagingTypeControllerProvider = StateNotifierProvider<
  PackagingTypeController,
  AsyncValue<List<PackagingTypeItem>>
>((ref) {
  final repo = ref.watch(packagingTypeRepositoryProvider);
  return PackagingTypeController(repo);
});

final packagingTypeItemsProvider = Provider<List<PackagingTypeItem>>((ref) {
  final state = ref.watch(packagingTypeControllerProvider);
  return state.when(
    data: (items) => items,
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});
