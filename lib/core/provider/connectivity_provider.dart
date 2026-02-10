import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/connectivity_service.dart';


final connectivityProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});