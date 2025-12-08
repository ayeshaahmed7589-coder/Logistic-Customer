import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/delivery_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PackageItemsNotifier extends StateNotifier<List<PackageItem>> {
  PackageItemsNotifier() : super([]) {
    loadItems();
  }

  // Load from local cache
  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("manual_items") ?? [];

    final items = data.map((e) => PackageItem.fromMap(jsonDecode(e))).toList();

    state = items;
  }

  // Save to cache - BOTH manual AND shopify items
  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();

    // Save ALL items
    final encoded = state.map((item) => jsonEncode(item.toMap())).toList();

    await prefs.setStringList("manual_items", encoded);
  }

  // Add item
  Future<void> addItem(PackageItem item) async {
    state = [...state, item];
    await saveItems();
  }

  // Remove item
  Future<void> removeItem(int index) async {
    state = [...state]..removeAt(index);
    await saveItems();
  }

  // Clear all items
  Future<void> clearAll() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("manual_items");
  }
}

// final packageItemsProvider =
//     StateNotifierProvider<PackageItemsNotifier, List<PackageItem>>(
//       (ref) => PackageItemsNotifier(),
//     );

// class PackageItemsNotifier extends StateNotifier<List<PackageItem>> {
//   PackageItemsNotifier() : super([]) {
//     loadItems();
//   }

//   // Load from local cache
//   Future<void> loadItems() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = prefs.getStringList("manual_items") ?? [];

//     final items = data.map((e) => PackageItem.fromMap(jsonDecode(e))).toList();

//     state = items;
//   }

//   // Save to cache
//   Future<void> saveItems() async {
//     final prefs = await SharedPreferences.getInstance();

//     final encoded = state.map((item) => jsonEncode(item.toMap())).toList();

//     await prefs.setStringList("manual_items", encoded);
//   }

//   // Add item
//   Future<void> addItem(PackageItem item) async {
//     state = [...state, item];
//     saveItems();
//   }

//   // Remove item
//   Future<void> removeItem(int index) async {
//     state = [...state]..removeAt(index);
//     saveItems();
//   }
// }
