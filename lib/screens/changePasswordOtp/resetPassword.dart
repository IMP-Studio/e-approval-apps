import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/methods/api.dart';
import 'package:imp_approval/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> with WidgetsBindingObserver{
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance!.addObserver(this);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void resetPassword() async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt('user_id');
    final otpSave = preferences.getInt('otp_code');
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    print('$otpSave');
    print('$preferences');

    final data = {
      'user_id': userId.toString(),
      'new_password': newPassword.toString(),
      'new_password_confirmation': confirmPassword.toString(),
      'otp_code': otpSave.toString()
    };

    final result = await API().postRequest(route: '/resetPasswordOtp', data: data);

    print(result.body);
    final response = jsonDecode(result.body);
    final status = response['status'];
    final message = response['message'];

    if (status == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.toString()),
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
              padding:
                  const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Buat ',
                          style: GoogleFonts.montserrat(
                            color: hitamText,
                            fontSize: MediaQuery.of(context).size.width * 0.055,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Password Baru',
                          style: GoogleFonts.montserrat(
                            color: blueText,
                            fontSize: MediaQuery.of(context).size.width * 0.055,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Kombinasikan angka, huruf kapital, simbol',
                    style: GoogleFonts.montserrat(
                      color: greyText,
                      fontSize: MediaQuery.of(context).size.width * 0.033,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'dan tanda baca.',
                    style: GoogleFonts.montserrat(
                      color: greyText,
                      fontSize: MediaQuery.of(context).size.width * 0.033,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password Baru',
                          style: GoogleFonts.montserrat(
                            color: greyText,
                            fontSize: MediaQuery.of(context).size.width * 0.033,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 45,
                          child: TextFormField(
                            controller: newPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            style: GoogleFonts.montserrat(color: kText),
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              hintStyle: GoogleFonts.poppins(color: kIcon),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: greyText,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Konfirmasi Password',
                          style: GoogleFonts.montserrat(
                            color: greyText,
                            fontSize: MediaQuery.of(context).size.width * 0.033,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 45,
                          child: TextFormField(
                            controller: confirmPasswordController,
                            style: GoogleFonts.montserrat(color: kText),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              hintStyle: GoogleFonts.poppins(color: kIcon),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: greyText,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: InkWell(
                      onTap: () {
                         resetPassword();
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0XFF4381CA),
                        ),
                        child: Center(
                          child: Text(
                            "Buat Password",
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
