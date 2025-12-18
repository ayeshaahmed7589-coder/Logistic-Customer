import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';
import 'package:logisticscustomer/features/home/orders/get_all_orders_modal.dart';
import 'package:logisticscustomer/features/home/orders/orders_controller.dart';

import '../../../export.dart';
import 'order details/order_details_screen.dart';

class Orders extends ConsumerStatefulWidget {
  const Orders({super.key});

  @override
  ConsumerState<Orders> createState() => _OrdersState();
}

class _OrdersState extends ConsumerState<Orders> {
  final List<String> _statusFilters = [
    'All',
    'Active',
    'Assigned',
    'Pending',
    'Completed',
    'Cancelled',
  ];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Load orders jab screen open ho
    Future.microtask(() {
      ref.read(orderControllerProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: Column(
        children: [
          // Custom AppBar
          _buildAppBar(),

          // Filter Chips
          _buildFilterChips(),

          // Orders List
          Expanded(
            child: _buildContent(orderState), // Changed this line
          ),
        ],
      ),
    );
  }

  // Build content based on state
  Widget _buildContent(OrderState state) {
    // Show loading only when first loading and no data
    if (state.isLoading && state.orders.isEmpty) {
      return _buildLoadingState();
    }

    // Show error if any
    if (state.error != null) {
      return _buildErrorState(state.error!);
    }

    // Show empty state if no orders
    if (state.orders.isEmpty) {
      return _buildEmptyState();
    }

    // Show orders list
    return _buildOrdersList(state);
  }

  // Custom AppBar
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.electricTeal,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mediumGray.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                txt: "My Orders",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.pureWhite,
              ),
              const SizedBox(height: 4),
              CustomText(
                txt: "Track and manage all your orders",
                fontSize: 14,
                color: AppColors.pureWhite.withOpacity(0.8),
              ),
            ],
          ),
          IconButton(
            onPressed: _refreshOrders,
            icon: const Icon(
              Icons.refresh,
              color: AppColors.pureWhite,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // Filter Chips
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: _statusFilters.map((filter) {
          bool isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: CustomText(
                txt: filter,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.pureWhite : AppColors.mediumGray,
              ),
              selected: isSelected,
              selectedColor: AppColors.electricTeal,
              backgroundColor: AppColors.pureWhite,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
                // Filter orders when filter changes
                if (filter == 'All') {
                  ref.read(orderControllerProvider.notifier).loadOrders();
                } else if (filter == 'Active') {
                  // Active filter ke liye alag logic
                  ref
                      .read(orderControllerProvider.notifier)
                      .filterByStatus(filter);
                } else {
                  ref
                      .read(orderControllerProvider.notifier)
                      .filterByStatus(filter);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.electricTeal
                      : AppColors.mediumGray.withOpacity(0.3),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  // Loading State
  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6, // Skeleton items
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGray.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 80,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGray.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGray.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 60,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGray.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Error State
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: AppColors.mediumGray),
          const SizedBox(height: 16),
          CustomText(
            txt: "Oops! Something went wrong",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
          const SizedBox(height: 8),
          CustomText(
            txt: error,
            fontSize: 14,
            color: AppColors.mediumGray,
            align: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _refreshOrders,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricTeal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, size: 20, color: Colors.white),
                SizedBox(width: 8),
                Text("Try Again", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Orders List
  Widget _buildOrdersList(OrderState state) {
    // Filter orders based on selected filter
    List<AlOrder> filteredOrders = _filterOrders(state.orders);

    // Agar koi order nahi hai
    if (filteredOrders.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(orderControllerProvider.notifier).refreshOrders();
      },
      child: Column(
        children: [
          // Show loading more indicator
          if (state.isLoadingMore)
            Padding(
              padding: const EdgeInsets.all(12),
              child: CircularProgressIndicator(color: AppColors.electricTeal),
            ),

          // Orders list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return _buildOrderCard(order);
              },
            ),
          ),

          // Load more button
          if (state.currentPage < state.meta.lastPage && !state.isLoadingMore)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  ref.read(orderControllerProvider.notifier).loadMoreOrders();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.electricTeal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 20, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Load More", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: AppColors.mediumGray.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          CustomText(
            txt: "No orders found",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
          const SizedBox(height: 8),
          CustomText(
            txt: _selectedFilter == 'All'
                ? "You haven't placed any orders yet"
                : "No ${_selectedFilter.toLowerCase()} orders",
            fontSize: 14,
            color: AppColors.mediumGray,
          ),
          const SizedBox(height: 24),
          if (_selectedFilter == 'All')
            ElevatedButton(
              onPressed: () {
                // Navigate to create order screen
                // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateOrderScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricTeal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Create First Order",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Order Card
  Widget _buildOrderCard(AlOrder order) {
    final date = DateTime.parse(order.createdAt);
    final formattedDate = DateFormat('dd MMM yyyy • hh:mm a').format(date);

    final statusColor = _getStatusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          /// ================= HEADER =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.electricTeal.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      txt: "Order #",
                      fontSize: 12,
                      color: AppColors.mediumGray,
                    ),
                    CustomText(
                      txt: order.orderNumber,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),

                    /// TRACKING CODE
                    if (order.trackingCode.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          CustomText(
                            txt: "Track Order : ",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mediumGray,
                          ),
                          CustomText(
                            txt: order.trackingCode,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.electricTeal,
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: order.trackingCode),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Tracking code copied"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.copy, // 📄📄 double page icon
                              size: 14,
                              color: AppColors.electricTeal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(order.status),
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        txt: order.statusText.toUpperCase(),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ================= BODY =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Route
                Row(
                  children: [
                    Column(
                      children: [
                        _dot(AppColors.electricTeal),
                        Container(
                          width: 2,
                          height: 28,
                          color: AppColors.mediumGray.withOpacity(0.3),
                        ),
                        _dot(AppColors.limeGreen),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _routeText("Pickup", order.pickupCity),
                          const SizedBox(height: 12),
                          _routeText("Delivery", order.deliveryCity),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// Meta info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (order.vehicle.vehicleType.isNotEmpty)
                      _iconText(
                        Icons.local_shipping,
                        order.vehicle.vehicleType,
                      ),
                    if (order.driver.name.isNotEmpty)
                      _iconText(Icons.person_outline, order.driver.name),
                    if (order.totalWeightKg != null &&
                        order.totalWeightKg!.isNotEmpty)
                      _iconText(
                        Icons.scale_outlined,
                        "${order.totalWeightKg} kg",
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                /// Cost & Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (order.finalCost != null && order.finalCost!.isNotEmpty)
                      CustomText(
                        txt: "₹${order.finalCost}",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.electricTeal,
                      ),
                    CustomText(
                      txt: formattedDate,
                      fontSize: 12,
                      color: AppColors.mediumGray,
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ================= FOOTER =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.map_outlined,
                      size: 16,
                      color: AppColors.electricTeal,
                    ),
                    label: const Text(
                      "Track",
                      style: TextStyle(
                        color: AppColors.electricTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.electricTeal,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderDetailsScreen(
                              orderId:
                                  order.id, // ✅ REAL ORDER ID PASS HO RAHI HAI
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.remove_red_eye_outlined,
                        size: 16,
                        color: AppColors.pureWhite,
                      ),
                      label: const Text(
                        "Details",
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.electricTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _routeText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(txt: label, fontSize: 12, color: AppColors.mediumGray),
        CustomText(txt: value, fontSize: 15, fontWeight: FontWeight.w600),
      ],
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.mediumGray),
        const SizedBox(width: 4),
        CustomText(txt: text, fontSize: 12, color: AppColors.mediumGray),
      ],
    );
  }

  // Helper Methods
  List<AlOrder> _filterOrders(List<AlOrder> orders) {
    if (_selectedFilter == 'All') {
      return orders;
    } else if (_selectedFilter == 'Active') {
      return orders.where((order) => order.isActive).toList();
    } else {
      return orders
          .where(
            (order) =>
                order.status.toLowerCase() == _selectedFilter.toLowerCase(),
          )
          .toList();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'assigned':
        return AppColors.electricTeal;
      case 'pending':
        return Colors.orange;
      case 'in_transit':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.mediumGray;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'assigned':
        return Icons.local_shipping;
      case 'pending':
        return Icons.pending;
      case 'in_transit':
        return Icons.directions_car;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  void _refreshOrders() {
    ref.read(orderControllerProvider.notifier).refreshOrders();
  }
}
