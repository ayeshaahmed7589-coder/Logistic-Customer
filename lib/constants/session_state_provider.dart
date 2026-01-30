import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SessionStatus {
  active,
  expired,
  refreshing,
}

final sessionProvider =
    StateProvider<SessionStatus>((ref) => SessionStatus.active);
