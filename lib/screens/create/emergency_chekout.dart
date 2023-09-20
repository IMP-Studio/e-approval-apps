import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/screens/create/create_detail_standup.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Emergency extends StatefulWidget {
  const Emergency({super.key});

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  SharedPreferences? preferences;

  void initState() {
    super.initState();
    getUserData().then((_) {});
  }

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

  TextEditingController emergency = TextEditingController();

  Future emergencyCheckOut() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    final response = await http.post(
        Uri.parse(
            'https://testing.impstudio.id/approvall/api/presence/emergency?user_id=$userId'),
        body: {
          "emergency_description": emergency.text,
        });

    print(response.body);
    print('Response status: ${response.statusCode}');
    return json.decode(response.body);
  }

  @override
  final double _tinggidesc = 150;
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.chevronLeft,
                      color: kButton,
                    ),
                    Text(
                      'Kembali',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: kButton,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.center,
                child: Icon(
                  LucideIcons.briefcase,
                  color: Color.fromRGBO(67, 129, 202, 1),
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              // HERO
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.35,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [kTextoo, kTextoo])),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.007,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chek Out Darurat",
                                style: GoogleFonts.getFont('Montserrat',
                                    textStyle: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.055,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  "Memungkinkan karyawan untuk check out lebih awal, karena situasi darurat",
                                  style: GoogleFonts.getFont('Montserrat',
                                      textStyle: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SvgPicture.asset(
                        "assets/img/emergency.svg",
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),

              // FORM CREATE

              const SizedBox(
                height: 20,
              ),

              // NAMA PROJECT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(2),
                                bottomRight: Radius.circular(2),
                              ),
                              border: Border.all(color: kTextoo, width: 2),
                            ),
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, top: 10, bottom: 10),
                            height: _tinggidesc,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Deskripsi',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.montserrat(
                                        color: kTextoo,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      TextFormField(
                                        controller: emergency,
                                        style: GoogleFonts.montserrat(
                                          color: kBlck,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 7,
                                        decoration: InputDecoration.collapsed(
                                          hintText:
                                              "Berikan deskripsi mengenai alasan check out daruratmu",
                                          hintStyle: GoogleFonts.montserrat(
                                            color: kTextUnselected,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                        Container(
                          decoration: const BoxDecoration(
                            color: kTextoo,
                          ),
                          width: 7,
                          height: _tinggidesc,
                        ),
                      ],
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 110,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            emergencyCheckOut().then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainLayout()));
                              // Navigator.pop(context);
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: kButton,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Kirim'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
