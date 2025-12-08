import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderCacheProvider = StateNotifierProvider<OrderCacheController, Map<String, dynamic>>(
  (ref) => OrderCacheController(),
);

class OrderCacheController extends StateNotifier<Map<String, dynamic>> {
  OrderCacheController() : super({});

  void saveValue(String key, dynamic value) {
    state = {...state, key: value};
  }

  dynamic getValue(String key) {
    return state[key];
  }

  void clearAll() {
    state = {};
  }
}
