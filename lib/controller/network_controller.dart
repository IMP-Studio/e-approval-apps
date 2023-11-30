import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool isConnected = true.obs;
  RxString connectionType = ''.obs;
  bool _isSnackbarVisible = false;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _checkInitialConnectivity() async {
    ConnectivityResult initialConnectivity = await _connectivity.checkConnectivity();
    _updateConnectionStatus(initialConnectivity);
    _updateConnectionType(initialConnectivity);
  }

  void _updateConnectionType(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        connectionType.value = 'Mobile Network';
        break;
      case ConnectivityResult.wifi:
        connectionType.value = 'WiFi';
        break;
      case ConnectivityResult.ethernet:
        connectionType.value = 'Ethernet';
        break;
      case ConnectivityResult.bluetooth:
        connectionType.value = 'Bluetooth';
        break;
      case ConnectivityResult.vpn:
        connectionType.value = 'VPN';
        break;
      case ConnectivityResult.other:
        connectionType.value = 'Other';
        break;
      case ConnectivityResult.none:
        connectionType.value = 'None';
        break;
    }
  }

  Future<bool> _isConnectedToInternet() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) async {
    _updateConnectionType(connectivityResult);

    bool isInternetConnected = await _isConnectedToInternet();

    if (connectivityResult == ConnectivityResult.none || !isInternetConnected) {
      isConnected.value = false;

      if (!_isSnackbarVisible) {
        _isSnackbarVisible = true;

        Get.rawSnackbar(
          messageText: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wifi_off_sharp,
                                color: Colors.red,
                                size: 35,
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: Get.width * 0.65,
                                child: Text(
                                  'PLEASE CONNECT TO THE INTERNET',
                                  style: GoogleFonts.getFont('Montserrat',
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: Get.width * 0.034,
                                          fontWeight: FontWeight.w600)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                              ),
                              Text(
                                truncateText('Your device seems offline. Connect to continue.', 48),
                                style: GoogleFonts.getFont(
                                  'Montserrat',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 5,
                height: 49,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          duration: const Duration(days: 365),
          snackPosition: SnackPosition.TOP,
          isDismissible: false,
        );
      }
    } else {
      isConnected.value = true;
      if (_isSnackbarVisible) {
        Get.closeCurrentSnackbar();
        _isSnackbarVisible = false;
      }
    }
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + '';
    }
  }
}


   

