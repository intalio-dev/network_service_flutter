import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivityModel {
  bool hasInternet;
  ConnectivityResult connectivityResult;

  NetworkConnectivityModel({
    required this.hasInternet,
    required this.connectivityResult,
  });
  @override
  String toString() {
    return 'ConnectedTo: ${connectivityResult.name} || Has network access: $hasInternet';
  }
}
