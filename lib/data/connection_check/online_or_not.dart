import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easypos/utils/dekhao.dart';

enum InternetStatus {online, offline}
class OnlineOrNot {
  InternetStatus _internetStatus = InternetStatus.offline;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  OnlineOrNot() {
    connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
  }

  void dispose() {
    connectivitySubscription.cancel();
  }

  InternetStatus get internetStatus => _internetStatus;

  Future<void> initConnectivity() async {
    
    List<ConnectivityResult> results = [ConnectivityResult.none];
    try {
      results = await _connectivity.checkConnectivity();
    } catch (e) {
      dekhao(e.toString());
      return;
    }

    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    ConnectivityResult result = ConnectivityResult.none;
    // Check the last result in the list to determine current connectivity
    if (results.isNotEmpty) {
      result = results.last;
    }

    switch (result) {
        case ConnectivityResult.wifi:
          _internetStatus = InternetStatus.online;
          break;
        case ConnectivityResult.mobile:
          _internetStatus = InternetStatus.online;
          break;
        case ConnectivityResult.none:
          _internetStatus = InternetStatus.offline;
          break;
        default:
          _internetStatus = InternetStatus.offline;
          break;
      }
  }
}