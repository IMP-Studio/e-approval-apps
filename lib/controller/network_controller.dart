import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override 
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  bool _isSnackbarVisible = false;
      String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + '';
    }
  }


  void showCustomSnackbar(String message, String submessage, Color backgroundColor, Icon customIcon) {
  if (_isSnackbarVisible) {
    Get.closeCurrentSnackbar();
  }

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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [customIcon],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.65,
                          child: Text(
                            message,
                            style: GoogleFonts.getFont('Montserrat',
                                textStyle: TextStyle(
                                    color: kBlck,
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
                          truncateText(submessage, 48),
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
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
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



  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
  if (connectivityResult == ConnectivityResult.none) {
    showCustomSnackbar(
      'PLEASE CONNECT TO THE INTERNET', 
      'Your device seems offline. Connect to continue.',
      Colors.red[400]!, 
      const Icon(Icons.wifi_off, color: Colors.red, size: 35)
    );
  } else {
    if (_isSnackbarVisible) {
      Get.closeCurrentSnackbar();
      _isSnackbarVisible = false;
    }
  }
}




}