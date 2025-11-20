import 'package:go_router/go_router.dart';
import 'package:logisticscustomer/features/routes/bottom_navbar_route.dart';

final List<GoRoute> appRoutes = [
  ...tripsRoutes,
  // other routes...
];

final GoRouter router = GoRouter(routes: appRoutes);
