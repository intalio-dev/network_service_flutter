import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core_utils/core_utils.dart';
import 'package:network_service/src/models/network_connectivity_model.dart';

class NetworkStatusService {
  static final NetworkStatusService instance = NetworkStatusService._internal();

  factory NetworkStatusService() => instance;
  final Connectivity _connectivity = Connectivity();
  NetworkConnectivityModel networkConnectivityModel = NetworkConnectivityModel(
    hasInternet: false,
    connectivityResult: ConnectivityResult.none,
  );

  ConnectivityResult get currentConnectivity =>
      networkConnectivityModel.connectivityResult;

  bool get hasNetworkAccess => networkConnectivityModel.hasInternet;
  final StreamController<NetworkConnectivityModel> _streamController =
      StreamController<NetworkConnectivityModel>.broadcast();

  late Stream<NetworkConnectivityModel> connectionChangeStream =
      _streamController.stream;

  NetworkStatusService._internal();

  static void _printClassLog(Object? object) {
    AppLogs.debugLog(object, runtimeType: instance.runtimeType);
  }

  void init() {
    _printClassLog('Initialized NetworkStatus');

    _connectivity.onConnectivityChanged.listen(_updateConnectivityListener);

    _periodicCheck();
  }

  Future<void> waitForInternetConnection(
      {Duration checkDuration = const Duration(milliseconds: 500)}) async {
    while (!hasNetworkAccess) {
      await Future.delayed(checkDuration);
    }
  }

  Duration get _getPeriodicCheckDuration =>
      Duration(seconds: networkConnectivityModel.hasInternet ? 15 : 5);
  Duration _periodicCheckDuration = const Duration(seconds: 1);

  void _periodicCheck() async {
    if (_periodicCheckDuration != _getPeriodicCheckDuration) {
      _periodicCheckDuration = _getPeriodicCheckDuration;
      _printClassLog('Started periodic check every $_periodicCheckDuration');
    }
    List<ConnectivityResult> connectivityResults =
        await _connectivity.checkConnectivity();

    for (var result in connectivityResults) {
      _addStreamEvent(
        hasInternet: await _hasInternetAccess(),
        connectivityResult: result,
      );
    }
    await Future.delayed(_periodicCheckDuration);
    _periodicCheck();
  }

  void updateInternetStatus() async {
    if (currentConnectivity != ConnectivityResult.none) {
      _addStreamEvent(hasInternet: await _hasInternetAccess());
    }
  }

  Future<void> _updateConnectivityListener(
      List<ConnectivityResult> connectivityResults) async {
    for (var result in connectivityResults) {
      _addStreamEvent(
        hasInternet: await _hasInternetAccess(),
        connectivityResult: result,
      );
    }
  }

  void _addStreamEvent(
      {bool? hasInternet, ConnectivityResult? connectivityResult}) {
    if ((hasInternet != null &&
            hasInternet != networkConnectivityModel.hasInternet) ||
        (connectivityResult != null &&
            connectivityResult !=
                networkConnectivityModel.connectivityResult)) {
      var newData = NetworkConnectivityModel(
        hasInternet: hasInternet ?? networkConnectivityModel.hasInternet,
        connectivityResult:
            connectivityResult ?? networkConnectivityModel.connectivityResult,
      );
      networkConnectivityModel = newData;
      _streamController.add(newData);
      AppLogs.successLog(newData, runtimeType: runtimeType);
    }
  }

  Future<bool> _hasInternetAccess() async {
    late bool status = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        status = true;
        AppLogs.successLog('Internet Connected', runtimeType: runtimeType);
      } else {
        status = false;
        AppLogs.errorLog('No Internet', runtimeType: runtimeType);
      }
    } on SocketException catch (_) {
      status = false;
      AppLogs.errorLog('No Internet', runtimeType: runtimeType);
    }
    return status;
  }
}
