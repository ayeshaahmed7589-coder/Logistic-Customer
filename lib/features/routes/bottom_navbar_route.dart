import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticscustomer/features/bottom_navbar/bottom_navbar_screen.dart';

final List<GoRoute> tripsRoutes = [
  GoRoute(
    path: '/trips_bottom_navbar',
    name: 'Trips Bottom NavBar',
    builder: (BuildContext context, GoRouterState state) {
      final int initialIndex = state.extra as int? ?? 0;
      return TripsBottomNavBarScreen(initialIndex: initialIndex);
    },
  ),
];
