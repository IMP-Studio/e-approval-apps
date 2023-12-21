import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/methods/api.dart';
import 'package:imp_approval/screens/changePasswordOtp/verificationPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> with WidgetsBindingObserver{
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

  TextEditingController email = TextEditingController();

  void forgetPasswordOtp() async {
    final data = {
      'email': email.text.toString(),
    };
    
    final result = await API().postRequest(route: '/sendotp', data: data);

    print(result.body);
    final response = jsonDecode(result.body);
    if (response['status'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('user_id', response['data']['user_id']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const OTPPage(),
      ));
    }else{
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
          'Verifikasi Email',
          style: GoogleFonts.montserrat(
            color: const Color(0xff000000),
            fontSize: MediaQuery.of(context).size.width * 0.039,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
          onTap: () {
              Navigator.pop(context);
          },
          child: const Icon(
            size: 20,
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
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
                      Text(
                        'Lupa',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xff000000),
                          fontSize: MediaQuery.of(context).size.width * 0.055,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Password?',
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
                          'Untuk mereset kata sandi Anda, masukkan',
                          style: GoogleFonts.montserrat(
                            color: greyText,
                            fontSize: MediaQuery.of(context).size.width * 0.033,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Email yang terdaftar pada akun',
                          style: GoogleFonts.montserrat(
                            color: greyText,
                            fontSize: MediaQuery.of(context).size.width * 0.033,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Anda.',
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
                    margin: const EdgeInsets.only(top: 45),
                    width: 260,
                    height: 45,
                    child: TextFormField(
                      controller: email,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: greyText,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1.0, color: Colors.grey))),
                          child: const Icon(Icons.phone_android_rounded),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(10, 10, 10,
                            10), // Adjust the padding for the input text.
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(8)),
                        hintText: 'example@mail.com',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: greyText,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: InkWell(
                      onTap: () {
                        forgetPasswordOtp();
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
                            "Berikutnya",
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
