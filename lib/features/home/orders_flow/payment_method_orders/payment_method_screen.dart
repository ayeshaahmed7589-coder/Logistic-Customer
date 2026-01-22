import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/colors.dart';

import '../../../../common_widgets/custom_button.dart';
import '../../order_successful.dart';
import '../all_orders/orders_controller.dart';
import '../create_orders_screens/calculate_quotes/calculate_quote_controller.dart';
import '../create_orders_screens/fetch_order/place_order_controller.dart' hide orderControllerProvider;
import '../create_orders_screens/fetch_order/place_order_modal.dart';
import '../create_orders_screens/order_cache_provider.dart';
import 'payment_method_model.dart';

class PaymentMethodModal extends ConsumerStatefulWidget {
  final PaymentData paymentData;

  const PaymentMethodModal({super.key, required this.paymentData});

  @override
  ConsumerState<PaymentMethodModal> createState() => _PaymentMethodModalState();
}

class _PaymentMethodModalState extends ConsumerState<PaymentMethodModal> {
  bool get walletEnabled => widget.paymentData.wallet.sufficient;
  int selectedMethod = 0;

  bool hasCalculatedQuotes = false;

  // UPDATED: Place Order Function
  Future<void> _placeOrder(BuildContext context) async {
    try {
      final cache = ref.read(orderCacheProvider);
      final isMultiStop = cache["is_multi_stop_enabled"] == "true";
      final bestQuote = ref.read(bestQuoteProvider);

      if (bestQuote == null) {
        throw Exception("Please select a quote first");
      }

      print("🎯 Placing ${isMultiStop ? 'Multi-Stop' : 'Standard'} Order...");

      // ✅ PRE-VALIDATION FOR MULTI-STOP
      if (isMultiStop) {
        print("🔍 Validating multi-stop data...");

        // Check cache values
        final quantity = cache["quantity"]?.toString();
        final weight = cache["total_weight"]?.toString();

        print("Cache check - quantity: $quantity, weight: $weight");

        if (quantity == null ||
            quantity.isEmpty ||
            int.tryParse(quantity) == 0) {
          print("⚠️  Quantity missing in cache, calculating from stops...");

          final stopsCount =
              int.tryParse(cache["route_stops_count"]?.toString() ?? "0") ?? 0;
          int totalQty = 0;
          double totalWeight = 0.0;

          for (int i = 1; i <= stopsCount; i++) {
            final qty =
                int.tryParse(cache["stop_${i}_quantity"]?.toString() ?? "1") ??
                1;
            final wgt =
                double.tryParse(
                  cache["stop_${i}_weight"]?.toString() ?? "50",
                ) ??
                50.0;

            totalQty += qty;
            totalWeight += wgt;
          }

          // Save to cache
          ref
              .read(orderCacheProvider.notifier)
              .saveValue("quantity", totalQty.toString());
          ref
              .read(orderCacheProvider.notifier)
              .saveValue("total_weight", totalWeight.toString());

          print("✅ Calculated and saved: Qty=$totalQty, Weight=$totalWeight");
        }
      }

      final repository = ref.read(placeOrderRepositoryProvider);
      OrderResponse orderResponse;

      if (isMultiStop) {
        print("🔄 Preparing multi-stop order data...");
        final request = await repository.prepareMultiStopOrderData();

        // ✅ FINAL SANITY CHECK
        print("🔍 FINAL CHECK:");
        print("Quantity: ${request.quantity}");
        print("Weight Per Item: ${request.weightPerItem}");

        if (request.quantity < 1 || request.weightPerItem < 0.01) {
          print("❌ Values invalid, forcing minimum values");

          // Force minimum values
          final fixedRequest = MultiStopOrderRequestBody(
            productTypeId: request.productTypeId,
            packagingTypeId: request.packagingTypeId,
            quantity: request.quantity < 1 ? 1 : request.quantity,
            weightPerItem: request.weightPerItem < 0.01
                ? 0.01
                : request.weightPerItem,
            isMultiStop: true,
            selectedQuote: request.selectedQuote,
            stops: request.stops,
            serviceType: request.serviceType,
            priority: request.priority,
            paymentMethod: request.paymentMethod,
            addOns: request.addOns,
            specialInstructions: request.specialInstructions,
            declaredValue: request.declaredValue,
          );

          orderResponse = await repository.placeMultiStopOrder(
            request: fixedRequest,
          );
        } else {
          orderResponse = await repository.placeMultiStopOrder(
            request: request,
          );
        }
      } else {
        final request = await repository.prepareStandardOrderData();
        orderResponse = await repository.placeStandardOrder(request: request);
      }

      // Clear cache after successful order
      ref.read(orderCacheProvider.notifier).clearCache();

      // Update controller state
      ref.read(orderControllerProvider.notifier).state = AsyncData(
        orderResponse,
      ) as OrderState;

      // Check if order was successful
      if (orderResponse.success) {
        final order = orderResponse.data.order;
        final orderNumber = order.orderNumber;
        final totalAmount = order.finalCost.toStringAsFixed(2);

        print("✅ Order placed successfully!");
        print("Order Number: $orderNumber");
        print("Total Amount: R$totalAmount");

        // Navigate to order success screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => OrderSuccessful(
              orderNumber: orderNumber,
              totalAmount: totalAmount,
            ),
          ),
          (route) => false,
        );
      } else {
        throw Exception(orderResponse.message);
      }
    } catch (e) {
      print("❌ Error placing order: $e");

      String errorMsg = e.toString();
      if (errorMsg.contains("quantity") ||
          errorMsg.contains("weight_per_item")) {
        errorMsg =
            "Please ensure all stops have at least 1 item and valid weight. "
            "Go back to multi-stop screen and add quantities.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderControllerProvider);
    final quoteState = ref.watch(quoteControllerProvider);
    final bestQuote = ref.watch(bestQuoteProvider);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 🔹 Drag Handle
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          /// 🔹 Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Payment methods",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔹 Cash
          paymentTile(
            index: 0,
            title: "Wallet payment",
            subtitle: walletEnabled
                ? "Wallet balance available"
                : "Insufficient balance",
            icon: Icons.money,
            enabled: walletEnabled,
          ),
          const SizedBox(height: 10),

          /// 🔹 Credit Card
          paymentTile(
            index: 1,
            title: "Add Creadit Card",
            subtitle: "Expires 09/25",
            icon: Icons.credit_card,
          ),
          const SizedBox(height: 10),

          /// 🔹 pay later
          paymentTile(
            index: 2,
            title: "Pay Later",
            subtitle: "Pay at your convenience",
            icon: Icons.watch_later_outlined,
          ),

          const SizedBox(height: 24),

          /// 🔹 Add Payment Method Button
          // Place Order Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final isOrderLoading = orderState.isLoading;
                        final hasQuotes =
                            hasCalculatedQuotes &&
                            quoteState.value != null &&
                            quoteState.value!.quotes.isNotEmpty;

                        bool canPlaceOrder = hasQuotes && bestQuote != null;

                        return CustomButton(
                          text: isOrderLoading
                              ? "Placing Order..."
                              : "Place Order",
                          backgroundColor: canPlaceOrder
                              ? AppColors.electricTeal
                              : AppColors.lightGrayBackground,
                          borderColor: canPlaceOrder
                              ? AppColors.electricTeal
                              : AppColors.electricTeal,
                          textColor: canPlaceOrder
                              ? AppColors.pureWhite
                              : AppColors.electricTeal,
                          onPressed: canPlaceOrder && !isOrderLoading
                              ? () => _placeOrder(context)
                              : null,
                        );
                      },
                    ),
                  ),
        ],
      ),
    );
  }

  Widget paymentTile({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    bool enabled = true,
  }) {
    final isSelected = selectedMethod == index;

    return InkWell(
      onTap: enabled ? () => setState(() => selectedMethod = index) : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.electricTeal : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.electricTeal),
            ],
          ),
        ),
      ),
    );
  }
}
