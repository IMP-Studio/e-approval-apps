import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';

class DetailHistoryResume extends StatefulWidget {
  final Map<String, dynamic> arguments;
  const DetailHistoryResume({super.key, required this.arguments});
  @override
  State<DetailHistoryResume> createState() => _DetailHistoryResumeState();
}

class _DetailHistoryResumeState extends State<DetailHistoryResume>
    with WidgetsBindingObserver {
  Widget shimmerLayout() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(children: [
        const SizedBox(
          height: 10.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.26,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.26,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.26,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.26,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.26,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
      ]),
    );
  }

  SharedPreferences? preferences;

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    getResume();
  }

  Future getResume() async {
    int userId = widget.arguments['user_id'];

    final String baseUrl =
        'https://testing.impstudio.id/approvall/api/presence/resume/$userId';

    var response = await http.get(Uri.parse(baseUrl));
    print("Final API URL: $baseUrl");
    print("API Response: ${response.body}");

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Resume Presensi',
            style: GoogleFonts.montserrat(
              color: kTextoo,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: getResume(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return shimmerLayout();
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.26,
                      decoration: const BoxDecoration(
                          color: kTextoo,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      width: 100,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.26,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data['totalPresence'].toString(),
                                              style: GoogleFonts.getFont(
                                                  'Montserrat',
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.074,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "Total Hadir",
                                              style: GoogleFonts.getFont(
                                                  'Montserrat',
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.034,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                                Container(
                                  width: 1.0,
                                  height: 40.0,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                ),
                                Expanded(
                                  child: Container(
                                      width: 100,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.26,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data['skip'].toString(),
                                              style: GoogleFonts.getFont(
                                                  'Montserrat',
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.074,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "Total Bolos",
                                              style: GoogleFonts.getFont(
                                                  'Montserrat',
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.034,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width * 0.26,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: kTextUnselectedOpa),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Work From Office",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.044,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Metode",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: kTextBlcknw,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.028,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7.0,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 7.0),
                                          constraints:
                                              const BoxConstraints(maxWidth: 100.0),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border: Border.all(
                                                  color: kTextBlcknw)),
                                          child: Text(
                                            "Geolocation",
                                            style: GoogleFonts.getFont(
                                                'Montserrat',
                                                color: kTextBlcknw,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 15,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.19,
                            height: MediaQuery.of(context).size.width * 0.18,
                            decoration: BoxDecoration(
                                color: kTextoo,
                                borderRadius: BorderRadius.circular(100.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Text(
                                  snapshot.data['WFO'].toString(),
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.074,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width * 0.26,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: kTextUnselectedOpa),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Work From Anywhere",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.044,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Jenis",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: kTextBlcknw,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.028,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7.0,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 7.0),
                                          constraints:
                                              const BoxConstraints(maxWidth: 100.0),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border:
                                                  Border.all(color: kGreen)),
                                          child: Text(
                                            "Kesehatan",
                                            style: GoogleFonts.getFont(
                                                'Montserrat',
                                                color: kGreen,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 7.0),
                                          constraints:
                                              const BoxConstraints(maxWidth: 100.0),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border:
                                                  Border.all(color: kTextOren)),
                                          child: Text(
                                            "Keluarga",
                                            style: GoogleFonts.getFont(
                                                'Montserrat',
                                                color: kTextOren,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.020,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 7.0),
                                          constraints:
                                              const BoxConstraints(maxWidth: 100.0),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border:
                                                  Border.all(color: kTextUngu)),
                                          child: Text(
                                            "Pendidikan",
                                            style: GoogleFonts.getFont(
                                                'Montserrat',
                                                color: kTextUngu,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.020,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 15,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.19,
                            height: MediaQuery.of(context).size.width * 0.18,
                            decoration: BoxDecoration(
                                color: kTextoo,
                                borderRadius: BorderRadius.circular(100.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Text(
                                  snapshot.data['telework'].toString(),
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.074,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width * 0.26,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: kTextUnselectedOpa),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Pekerjaan Dinas",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.044,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Metode",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: kTextBlcknw,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.028,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7.0,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 7.0),
                                          constraints:
                                              const BoxConstraints(maxWidth: 100.0),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border: Border.all(
                                                  color: kTextBlcknw)),
                                          child: Text(
                                            "Face Recognition",
                                            style: GoogleFonts.getFont(
                                                'Montserrat',
                                                color: kTextBlcknw,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.020,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 15,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.19,
                            height: MediaQuery.of(context).size.width * 0.18,
                            decoration: BoxDecoration(
                                color: kTextoo,
                                borderRadius: BorderRadius.circular(100.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Text(
                                  snapshot.data['work_trip'].toString(),
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.074,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width * 0.26,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: kTextUnselectedOpa),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Cuti",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.044,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Jenis",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: kTextBlcknw,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.028,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7.0,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 7.0),
                                          constraints:
                                              const BoxConstraints(maxWidth: 100.0),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border:
                                                  Border.all(color: kGreen)),
                                          child: Text(
                                            "Tahunan",
                                            style: GoogleFonts.getFont(
                                                'Montserrat',
                                                color: kGreen,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.020,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 7.0),
                                          constraints:
                                              const BoxConstraints(maxWidth: 100.0),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border:
                                                  Border.all(color: kTextoo)),
                                          child: Text(
                                            "Khusus",
                                            style: GoogleFonts.getFont(
                                                'Montserrat',
                                                color: kTextoo,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.020,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 7.0),
                                          constraints:
                                              const BoxConstraints(maxWidth: 100.0),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border: Border.all(
                                                  color: kTextBlocker)),
                                          child: Text(
                                            "Darurat",
                                            style: GoogleFonts.getFont(
                                                'Montserrat',
                                                color: kTextBlocker,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.020,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 15,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.19,
                            height: MediaQuery.of(context).size.width * 0.18,
                            decoration: BoxDecoration(
                                color: kTextoo,
                                borderRadius: BorderRadius.circular(100.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Text(
                                  snapshot.data['leave'].toString(),
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.074,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
              ); 
            } else {
              return shimmerLayout();
            }
          },
        ));
  }
}
