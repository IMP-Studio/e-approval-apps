import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/methods/api.dart';
import 'package:imp_approval/screens/changePasswordOtp/forgetPassword.dart';
import 'package:imp_approval/screens/changePasswordOtp/resetPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> with WidgetsBindingObserver{
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance!.addObserver(this);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

  final TextEditingController otpControllers = TextEditingController();
  final TextEditingController otpControllers2 = TextEditingController();
  final TextEditingController otpControllers3 = TextEditingController();
  final TextEditingController otpControllers4 = TextEditingController();
  final TextEditingController otpControllers5 = TextEditingController();
  final TextEditingController otpControllers6 = TextEditingController();

  void verificationOtp() async {
    String otpCode = otpControllers.text +
        otpControllers2.text +
        otpControllers3.text +
        otpControllers4.text +
        otpControllers5.text +
        otpControllers6.text;


    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt('user_id');

    print('$userId');

    final data = {
      'otp_code': otpCode.toString(),
      'user_id': userId.toString(),
    };
    final result = await API().postRequest(route: '/verifyotp', data: data);

    print(result.body);
    final response = jsonDecode(result.body);
    if (response['status'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('user_id', response['data']['user_id']);
      await preferences.setInt('otp_code', response['data']['otp_code']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResetPassword(),
      ));
    }else if (response['status'] == 400 && response['message'].contains('OTP code expired, Try Again') ){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
       Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ForgetPassword(),
      ));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'].toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Verifikasi No Telp',
          style: GoogleFonts.montserrat(
            color: const Color(0xff000000),
            fontSize: MediaQuery.of(context).size.width * 0.039,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const Icon(
          size: 20,
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Verification',
                        style: GoogleFonts.montserrat(
                          color: blueText,
                          fontSize: MediaQuery.of(context).size.width * 0.055,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Kami akan mengirimkan kode OTP melalui',
                          style: GoogleFonts.montserrat(
                            color: greyText,
                            fontSize: MediaQuery.of(context).size.width * 0.033,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'SMS untuk membantu Anda mengakses',
                          style: GoogleFonts.montserrat(
                            color: greyText,
                            fontSize: MediaQuery.of(context).size.width * 0.033,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'kembali akun Anda',
                          style: GoogleFonts.montserrat(
                            color: greyText,
                            fontSize: MediaQuery.of(context).size.width * 0.033,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    width: 260,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 43,
                          width: 39,
                          child: TextFormField(
                            controller: otpControllers,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: greyText,
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 43,
                          width: 39,
                          child: TextFormField(
                            controller: otpControllers2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: greyText,
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 43,
                          width: 39,
                          child: TextFormField(
                            controller: otpControllers3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: greyText,
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 43,
                          width: 39,
                          child: TextFormField(
                            controller: otpControllers4,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: greyText,
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 43,
                          width: 39,
                          child: TextFormField(
                            controller: otpControllers5,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: greyText,
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 43,
                          width: 39,
                          child: TextFormField(
                            controller: otpControllers6,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: greyText,
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: InkWell(
                      onTap: () {
                        verificationOtp();
                      },
                      child: Container(
                        width: 265,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0XFF4381CA),
                        ),
                        child: Center(
                          child: Text(
                            "Verifikasi OTP",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                              fontWeight: FontWeight.normal,
                              color: kBackground,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
