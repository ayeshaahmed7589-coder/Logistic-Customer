import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/bottom_navbar/bottom_navbar_screen.dart';
import 'package:logisticscustomer/features/home/orders_flow/all_orders/orders.dart';

import '../../../../common_widgets/custom_text.dart';
import '../../../../constants/colors.dart';
import 'order_tracking_controller.dart';
import 'order_tracking_model.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final String trackingCode;

  const OrderTrackingScreen({super.key, required this.trackingCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderTrackingControllerProvider(trackingCode));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: CustomText(txt: "Order Tracking"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.electricTeal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, size: 20),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> TripsBottomNavBarScreen(initialIndex: 1,)));
          }
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (model) {
          final order = model!.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _statusHeader(order),
                const SizedBox(height: 20),
                _progressSection(order),
                const SizedBox(height: 20),

                /// 👇 ROUTE (SINGLE / MULTI)
                order.isMultiStop
                    ? _multiStopTimeline(order.stops)
                    : _singleRouteCard(order),

                const SizedBox(height: 20),
                _driverCard(order),
                const SizedBox(height: 20),
                _vehicleCard(order),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusHeader(order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.electricTeal,
            AppColors.electricTeal.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.orderNumber,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            order.statusLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Tracking Code: ${order.trackingCode}",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _progressSection(order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Progress ${order.progressPercent}%",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: order.progressPercent / 100,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            color: AppColors.electricTeal,
          ),
        ),
      ],
    );
  }

  Widget _singleRouteCard(order) {
  return _infoCard(
    title: "Route Details",
    icon: Icons.route,
    children: [
      _row("Pickup", order.pickupAddress),
      _row("Delivery", order.deliveryAddress),
    ],
  );
}

Widget _multiStopTimeline(List<TrackOrderStop> stops) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.timeline, color: AppColors.electricTeal),
            SizedBox(width: 10),
            Text(
              "Route Timeline",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ...stops.map((stop) => _stopTile(stop)).toList(),
      ],
    ),
  );
}

Widget _stopTile(TrackOrderStop stop) {
  Color statusColor;

  switch (stop.status) {
    case "completed":
      statusColor = Colors.green;
      break;
    case "arrived":
      statusColor = AppColors.electricTeal;
      break;
    case "skipped":
      statusColor = Colors.orange;
      break;
    default:
      statusColor = Colors.grey;
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: stop.isCurrent
          ? AppColors.electricTeal.withOpacity(0.08)
          : Colors.grey[50],
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: statusColor.withOpacity(0.4)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: statusColor,
              child: Text(
                stop.sequence.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              stop.type.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const Spacer(),
            Text(
              stop.statusLabel,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
        Text(
          stop.contactName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          "${stop.address}, ${stop.city}",
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),

        if (stop.arrivalTime != null) ...[
          const SizedBox(height: 6),
          Text(
            "Arrived: ${stop.arrivalTime}",
            style: const TextStyle(fontSize: 12),
          ),
        ],

        if (stop.departureTime != null) ...[
          const SizedBox(height: 4),
          Text(
            "Departed: ${stop.departureTime}",
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ],
    ),
  );
}

 

  Widget _driverCard(order) {
    return _infoCard(
      title: "Driver Details",
      icon: Icons.person,
      children: [
        _row("Name", order.driver.name),
        _row("Phone", order.driver.phone),
        _row("Rating", "${order.driver.rating} ⭐"),
      ],
    );
  }

  Widget _vehicleCard(order) {
    return _infoCard(
      title: "Vehicle Details",
      icon: Icons.local_shipping,
      children: [
        _row("Vehicle", "${order.vehicle.make} ${order.vehicle.model}"),
        _row("Type", order.vehicle.type),
        _row("Registration", order.vehicle.registration),
      ],
    );
  }

  Widget _infoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.electricTeal),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          Spacer(),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
