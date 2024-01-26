import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _checkConnection();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetSnackbar();
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  void _showNoInternetSnackbar() {
    Get.rawSnackbar(
      messageText: const Text(
        'TIDAK ADA JARINGAN',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
      isDismissible: false,
      duration: const Duration(days: 1),
      backgroundColor: Colors.red[400]!,
      icon: const Icon(
        Icons.wifi_off_rounded,
        color: Colors.white,
        size: 25,
      ),
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.GROUNDED,
    );
  }
}
