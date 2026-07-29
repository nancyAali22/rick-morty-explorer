import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction over connectivity_plus so repositories depend on an
/// interface, not a concrete package (testable + swappable).
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> result =
        await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
