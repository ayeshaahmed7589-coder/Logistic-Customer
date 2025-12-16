import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown/product_type_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown/product_type_repo.dart';

class ProductTypeController extends StateNotifier<AsyncValue<ProductTypeData>> {
  final ProductTypeRepository repository;

  ProductTypeController(this.repository) : super(const AsyncValue.loading());

  // Load product types
  Future<void> loadProductTypes() async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.getProductTypes();
      state = AsyncValue.data(response.data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Search product types
  Future<List<ProductTypeItem>> searchProductTypes(String query) async {
    try {
      final response = await repository.getProductTypes();
      final allItems = response.data.getAllItems();

      if (query.isEmpty) {
        return allItems;
      }

      return allItems.where((item) => item.matchesSearch(query)).toList();
    } catch (e) {
      return [];
    }
  }

  // Filter by category
  Future<List<ProductTypeItem>> getProductTypesByCategory(
    String category,
  ) async {
    try {
      final response = await repository.getProductTypes();
      return response.data.getItemsByCategory(category);
    } catch (e) {
      return [];
    }
  }

  // Get item by ID
  ProductTypeItem? getItemById(int id) {
    return state.when(
      data: (data) => data.getAllItems().firstWhere(
        (item) => item.id == id,
        orElse: () => throw Exception("Item not found"),
      ),
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  // Get item by name
  ProductTypeItem? getItemByName(String name) {
    return state.when(
      data: (data) => data.getAllItems().firstWhere(
        (item) => item.name == name,
        orElse: () => throw Exception("Item not found"),
      ),
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  // Refresh
  Future<void> refresh() async {
    return loadProductTypes();
  }
}

// Update providers
final productTypeControllerProvider =
    StateNotifierProvider<ProductTypeController, AsyncValue<ProductTypeData>>((
      ref,
    ) {
      final repo = ref.watch(productTypeRepositoryProvider);
      return ProductTypeController(repo);
    });

// Provider for product type items (for dropdown)
final productTypeItemsProvider = Provider<List<ProductTypeItem>>((ref) {
  final state = ref.watch(productTypeControllerProvider);
  return state.when(
    data: (data) => data.getAllItems(),
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

// Provider for categories
final productTypeCategoriesProvider = Provider<List<String>>((ref) {
  final state = ref.watch(productTypeControllerProvider);
  return state.when(
    data: (data) =>
        data.productTypes.map((category) => category.categoryName).toList(),
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

// Product Type State
class ProductTypeState {
  final List<ProductTypeCategory> categories;
  final List<ProductTypeItem> allItems;
  final List<ProductTypeItem> filteredItems;
  final bool isLoading;
  final bool isSearching;
  final String? error;
  final String searchQuery;
  final String? selectedCategory;

  ProductTypeState({
    this.categories = const [],
    this.allItems = const [],
    this.filteredItems = const [],
    this.isLoading = false,
    this.isSearching = false,
    this.error,
    this.searchQuery = '',
    this.selectedCategory,
  });

  ProductTypeState copyWith({
    List<ProductTypeCategory>? categories,
    List<ProductTypeItem>? allItems,
    List<ProductTypeItem>? filteredItems,
    bool? isLoading,
    bool? isSearching,
    String? error,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return ProductTypeState(
      categories: categories ?? this.categories,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  // Get display items (filtered if search active, otherwise all)
  List<ProductTypeItem> get displayItems {
    return searchQuery.isNotEmpty || selectedCategory != null
        ? filteredItems
        : allItems;
  }

  // Get categories for dropdown
  List<String> get categoryNames {
    return categories.map((category) => category.categoryName).toList();
  }
}

///////////////////////////////////////
// package Type Controller

class PackagingTypeController
    extends StateNotifier<AsyncValue<PackagingTypeData>> {
  final PackagingTypeRepository repository;

  PackagingTypeController(this.repository) : super(const AsyncValue.loading());

  // Load packaging types
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
      final allItems = response.data.packagingTypes;

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
      data: (data) => data.packagingTypes.firstWhere(
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
      data: (data) => data.packagingTypes.firstWhere(
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

// Providers
final packagingTypeControllerProvider =
    StateNotifierProvider<
      PackagingTypeController,
      AsyncValue<PackagingTypeData>
    >((ref) {
      final repo = ref.watch(packagingTypeRepositoryProvider);
      return PackagingTypeController(repo);
    });

// Provider for packaging type items (for dropdown)
final packagingTypeItemsProvider = Provider<List<PackagingTypeItem>>((ref) {
  final state = ref.watch(packagingTypeControllerProvider);
  return state.when(
    data: (data) => data.packagingTypes,
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});
