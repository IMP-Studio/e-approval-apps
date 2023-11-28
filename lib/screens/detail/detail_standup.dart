import 'package:flutter/material.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'package:imp_approval/models/standup_model.dart';
class DetailStandUp extends StatefulWidget {
  final StandUps standup;
  const DetailStandUp({super.key, required this.standup});

  @override
  State<DetailStandUp> createState() => _DetailStandUpState();
}

class _DetailStandUpState extends State<DetailStandUp>
    with WidgetsBindingObserver {
  @override
  final double _tinggidesc = 137;
  final double _tinggidescc = 68;

  SharedPreferences? preferences;

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getUserData().then((_) {
      done.text = widget.standup.done?? '';
      doing.text = widget.standup.doing ?? '';
      blocker.text = widget.standup.blocker ?? '';
    });
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

  TextEditingController done = TextEditingController();
  TextEditingController doing = TextEditingController();
  TextEditingController blocker = TextEditingController();

  Future updateStandUp() async {
    int idStandup = widget.standup.id;
    final response = await http.put(
        Uri.parse(
            'https://testing.impstudio.id/approvall/api/standup/update/$idStandup'),
        body: {
          "user_id": preferences
              ?.getInt('user_id')
              .toString(), // make sure this is provided
          "done": done.text,
          "doing": doing.text,
          "blocker": blocker.text,
          "project_id": widget.standup.projectId.toString(),
        });

    print(response.body);
    print('Response status: ${response.statusCode}');
    return json.decode(response.body);
  }
  @override

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
                                "Stand Up",
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
                                  "Buat rencana project mu dengan metode Done, Doing, Blocker",
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
                        "assets/img/hero-image-standupdet.svg",
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

              Container(
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
                              border: Border.all(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  width: 2),
                            ),
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, top: 10, bottom: 10),
                            height: _tinggidescc,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Project',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.montserrat(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        Text(
                                          widget.standup.project ?? ' ',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        // Add more widgets as needed
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          width: 7,
                          height: _tinggidescc,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                                      'Done',
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
                                        enabled: false,
                                        controller: done,
                                        style: GoogleFonts.montserrat(
                                          color: kBlck,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 6,
                                        decoration: InputDecoration.collapsed(
                                          hintText: "",
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

              const SizedBox(
                height: 20,
              ),

              // Doing FORM

              Container(
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
                              border: Border.all(
                                  color: const Color(0xffFF7400), width: 2),
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
                                      'Doing',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.montserrat(
                                        color: const Color(0xffFF7400),
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
                                        enabled: false,
                                        controller: doing,
                                        style: GoogleFonts.montserrat(
                                          color: kBlck,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 6,
                                        decoration: InputDecoration.collapsed(
                                          hintText: "",
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
                            color: Color(0xffFF7400),
                          ),
                          width: 7,
                          height: _tinggidesc,
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // BLOCKER FORM

              Container(
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
                              border: Border.all(
                                  color: const Color(0xffCA4343), width: 2),
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
                                      'Blocker',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.montserrat(
                                        color: const Color(0xffCA4343),
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
                                        enabled: false,
                                        controller: blocker,
                                        style: GoogleFonts.montserrat(
                                          color: kBlck,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 6,
                                        decoration: InputDecoration.collapsed(
                                          hintText: "",
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
                            color: Color(0xffCA4343),
                          ),
                          width: 7,
                          height: _tinggidesc,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
