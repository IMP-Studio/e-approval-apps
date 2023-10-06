import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DetailHistoryResume extends StatefulWidget {
  const DetailHistoryResume({super.key});

  @override
  State<DetailHistoryResume> createState() => _DetailHistoryResumeState();
}

class _DetailHistoryResumeState extends State<DetailHistoryResume> {
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
      body: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.26,
              decoration: BoxDecoration(
                  color: kTextoo,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              width: 100,
                              height: MediaQuery.of(context).size.width * 0.26,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "48",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.074,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Total Hadir",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
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
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                        Expanded(
                          child: Container(
                              width: 100,
                              height: MediaQuery.of(context).size.width * 0.26,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "48",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.074,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Total Bolos",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
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
          SizedBox(
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.044,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Metode",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kTextBlcknw,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 7.0),
                                  constraints: BoxConstraints(maxWidth: 100.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      border: Border.all(color: kTextBlcknw)),
                                  child: Text(
                                    "Face Recognition",
                                    style: GoogleFonts.getFont('Montserrat',
                                        color: kTextBlcknw,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
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
                          "48",
                          style: GoogleFonts.getFont('Montserrat',
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.074,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.044,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Jenis",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kTextBlcknw,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 7.0),
                                  constraints: BoxConstraints(maxWidth: 100.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      border: Border.all(color: kGreen)),
                                  child: Text(
                                    "Kesehatan",
                                    style: GoogleFonts.getFont('Montserrat',
                                        color: kGreen,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 7.0),
                                  constraints: BoxConstraints(maxWidth: 100.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      border: Border.all(color: kTextOren)),
                                  child: Text(
                                    "Keluarga",
                                    style: GoogleFonts.getFont('Montserrat',
                                        color: kTextOren,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.020,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 7.0),
                                  constraints: BoxConstraints(maxWidth: 100.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      border: Border.all(color: kTextUngu)),
                                  child: Text(
                                    "Pendidikan",
                                    style: GoogleFonts.getFont('Montserrat',
                                        color: kTextUngu,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
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
                          "48",
                          style: GoogleFonts.getFont('Montserrat',
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.074,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.044,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Metode",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kTextBlcknw,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 7.0),
                                  constraints: BoxConstraints(maxWidth: 100.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      border: Border.all(color: kTextBlcknw)),
                                  child: Text(
                                    "Face Recognition",
                                    style: GoogleFonts.getFont('Montserrat',
                                        color: kTextBlcknw,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
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
                          "48",
                          style: GoogleFonts.getFont('Montserrat',
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.074,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.044,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Jenis",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kTextBlcknw,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 7.0),
                                  constraints: BoxConstraints(maxWidth: 100.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      border: Border.all(color: kGreen)),
                                  child: Text(
                                    "Tahunan",
                                    style: GoogleFonts.getFont('Montserrat',
                                        color: kGreen,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.020,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 7.0),
                                  constraints: BoxConstraints(maxWidth: 100.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      border: Border.all(color: kTextoo)),
                                  child: Text(
                                    "Khusus",
                                    style: GoogleFonts.getFont('Montserrat',
                                        color: kTextoo,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.020,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 7.0),
                                  constraints: BoxConstraints(maxWidth: 100.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      border: Border.all(color: kTextBlocker)),
                                  child: Text(
                                    "Darurat",
                                    style: GoogleFonts.getFont('Montserrat',
                                        color: kTextBlocker,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
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
                          "48",
                          style: GoogleFonts.getFont('Montserrat',
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.074,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
