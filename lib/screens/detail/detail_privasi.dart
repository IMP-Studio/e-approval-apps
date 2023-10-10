import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/screens/changePasswordOtp/forgetPassword.dart';
import 'package:imp_approval/screens/rubahPassword/rubah_password.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/screens/detail/detail_infopribadi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class PrivasiPage extends StatefulWidget {
  const PrivasiPage({super.key});

  @override
  State<PrivasiPage> createState() => _PrivasiPageState();
}

class _PrivasiPageState extends State<PrivasiPage> with WidgetsBindingObserver{
  
  SharedPreferences? preferences;

  bool isLoading = false;
  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
  WidgetsBinding.instance!.addObserver(this);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

    getUserData().then((_) {
      print(preferences?.getInt('user_id'));
    });
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
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              // email
              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text('Email',
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: kTextgrey,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text('${preferences?.getString('email')}',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          const Spacer(),
                          const Icon(
                            LucideIcons.mail,
                            color: kBorder,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // password
              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 5),
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
                              initialValue: 'inipassword',
                              enabled: false,
                              obscureText:
                                  true, // Ini akan menyembunyikan input password
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                hintText:
                                    'Enter your password', // Ganti dengan teks yang sesuai
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Icon(
                            LucideIcons.lock,
                            color: kBorder,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                   onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const ForgetPassword(),
                                          ),
                                        );
                                  },
                    child: Text("Lupa password",
                        style: GoogleFonts.montserrat(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: kTextBlocker,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RubahPassword(),
                            ),
                          );
                    },
                    child: Text("Ubah password",
                        style: GoogleFonts.montserrat(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: kTextgrey,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
