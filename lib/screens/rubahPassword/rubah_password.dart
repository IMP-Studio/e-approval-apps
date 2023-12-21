import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/methods/api.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RubahPassword extends StatefulWidget {
  const RubahPassword({super.key});

  @override
  State<RubahPassword> createState() => _RubahPasswordState();
}

class _RubahPasswordState extends State<RubahPassword> with WidgetsBindingObserver{
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

  bool _isPasswordVisible = false;

  bool _konfirPasswordVisible = false;
  bool validateOldPassPopUp = true;

  
  final TextEditingController newpassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController validateOldPass = TextEditingController();

  void changePassword() async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt('user_id');

    print('$userId');

      final data = {
      'user_id': userId.toString(),
      'new_password': newpassword.text.toString(),
      'new_password_confirmation': confirmPassword.text.toString(),
      'validate': validateOldPass.text.toString(),
    };

    final result = await API().postRequest(route: '/resetPasswordWithoutOtp', data: data);

    print(result.body);
    final response = jsonDecode(result.body);
    if (response['status'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(response['message']),
        ),
      );
      Navigator.of(context).pop();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(response['message'].toString()),
        ),
      );
    }

  }

  Widget _modalvalidasipass(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Validasi Password",
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          )),
      actions: [
        CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Batal",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: kTextBlocker,
                  fontWeight: FontWeight.w600,
                ))),
        CupertinoDialogAction(
            onPressed: () {
                if (validateOldPassPopUp) {
                changePassword();
                   setState(() {
                    validateOldPassPopUp = false;
                  });
                  Navigator.pop(context);
                }else {
                  Navigator.pop(context);
                }
            },
            child: Text("Kirim",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ))),
      ],
      content: Column(
        children: [
          Text(
              'Masukkan password saat ini untuk konfirmasi sebelum mengubah password baru.',
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 10),
          CupertinoTextField(
            controller: validateOldPass,
            obscureText: true, // Gunakan status _isPasswordVisible
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            placeholder: 'Masukan password',
            placeholderStyle: GoogleFonts.montserrat(
              fontSize: 14,
              color: kTextgrey,
              fontWeight: FontWeight.w500,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyText, width: 0.5),
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground3,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: kButton,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LucideIcons.chevronLeft),
        ),
        title: Text(
          'Privasi',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                // password
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Text(
                          'Password',
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: kTextgrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: newpassword,
                                obscureText:
                                    !_isPasswordVisible, // Gunakan status _isPasswordVisible
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Masukkan password baru',
                                  hintStyle: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  // Diperlukan jika ini berada dalam StatefulWidget
                                  _isPasswordVisible =
                                      !_isPasswordVisible; // Ubah status ketika ikon diklik
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: kBorder,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      
                // konfirmasi password
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Text(
                          'Konfirmasi password',
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: kTextgrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: confirmPassword,
                                obscureText: !_konfirPasswordVisible,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Konfirmasi password',
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _konfirPasswordVisible =
                                      !_konfirPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _konfirPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: kBorder,
                                shadows: const [
                                  Shadow(color: Colors.transparent),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 120,
                      child: ElevatedButton(
                      onPressed: () {
                      validateOldPassPopUp = true;
                          if (validateOldPassPopUp)
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _modalvalidasipass(context);
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: kButton,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Konfirmasi'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
