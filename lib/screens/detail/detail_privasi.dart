import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/screens/changePasswordOtp/forgetPassword.dart';
import 'package:imp_approval/screens/rubahPassword/rubah_password.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/screens/detail/detail_infopribadi.dart';

class PrivasiPage extends StatefulWidget {
  const PrivasiPage({super.key});

  @override
  State<PrivasiPage> createState() => _PrivasiPageState();
}

class _PrivasiPageState extends State<PrivasiPage> {
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
          icon: Icon(LucideIcons.chevronLeft),
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
          padding: EdgeInsets.all(10),
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              // staff id
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text('Staff id',
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: kTextgrey,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text('21233311232',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // no handphone
              Padding(
                padding: EdgeInsets.only(top: 14, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text('No. Handphone',
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: kTextgrey,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text('0878-2099-4530',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          Spacer(),
                          Icon(
                            LucideIcons.phoneCall,
                            color: kBorder,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // email
              Padding(
                padding: EdgeInsets.only(top: 14, bottom: 5),
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
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text('fauzan123@gmail.com',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          Spacer(),
                          Icon(
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
                padding: EdgeInsets.only(top: 14, bottom: 5),
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
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
                              decoration: InputDecoration(
                                hintText:
                                    'Enter your password', // Ganti dengan teks yang sesuai
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(
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
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPassword(),
                            ),
                          );
                    },
                    child: Text("Lupa password?",
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
                              builder: (context) => RubahPassword(),
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
