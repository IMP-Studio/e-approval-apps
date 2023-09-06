import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class DetailWfo extends StatefulWidget {
  const DetailWfo({super.key});

  @override
  State<DetailWfo> createState() => _DetailWfoState();
}

class _DetailWfoState extends State<DetailWfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  Icon(
                    LucideIcons.chevronLeft,
                    color: kButton,
                    size: MediaQuery.of(context).size.width * 0.050,
                  ),
                  Text(
                    'Kembali',
                    style: GoogleFonts.montserrat(
                      fontSize: MediaQuery.of(context).size.width * 0.0345,
                      fontWeight: FontWeight.w400,
                      color: kTextoo,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.userCheck,
                size: MediaQuery.of(context).size.width * 0.06,
                color: kTextoo,
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Attendance',
                      style: GoogleFonts.montserrat(
                        fontSize: MediaQuery.of(context).size.width * 0.070,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text(
                      'Complete',
                      style: GoogleFonts.montserrat(
                        color: kTextoo,
                        fontSize: MediaQuery.of(context).size.width * 0.070,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  width: 70,
                  height: 2,
                  color: kTextoo,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: kBorder, width: 1),
                    top: BorderSide(color: kBorder, width: 1),
                  )),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.05,
                        backgroundImage: AssetImage(
                          "assets/img/profil2.png",
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.028,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fauzan Alghifari',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Backend Developer',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: greyText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                                color: kGreenAllow,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.025)),
                            child: Text(
                              "Allowed",
                              style: GoogleFonts.getFont("Montserrat",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.02,
                                  color: kGreen,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 13, bottom: 13, left: 20, right: 30),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Work From Office',
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.039,
                                color: kTextoo,
                                fontWeight: FontWeight.w600,
                              )),
                          Row(
                            children: [
                              Text('27 Agustus 2023',
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.024,
                                    color: greyText,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.08,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Distance",
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.024,
                                  fontWeight: FontWeight.w500,
                                  color: kTextUnselected,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.006,
                              ),
                              Text(
                                "3.04 KM",
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.045,
                          ),
                          Container(
                            width: 1,
                            height: MediaQuery.of(context).size.width * 0.07,
                            decoration: BoxDecoration(color: kTextoo),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.045,
                          ),
                          // Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "IN",
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.024,
                                  fontWeight: FontWeight.w500,
                                  color: kTextUnselected,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.006,
                              ),
                              Text(
                                "08:32 AM",
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.065,
                          ),
                          Container(
                            width: 1,
                            height: MediaQuery.of(context).size.width * 0.07,
                            decoration: BoxDecoration(color: kTextoo),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.065,
                          ),
                          // Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Out",
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.024,
                                  fontWeight: FontWeight.w500,
                                  color: kTextUnselected,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.006,
                              ),
                              Text(
                                "11:32 AM",
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 180.0,
              decoration: BoxDecoration(
                color: kTextUnselectedOpa
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.06,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deskripsi Darurat',
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.034,
                                color: kBlck,
                                fontWeight: FontWeight.w600,
                              )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.006,
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '“ ',
                          style: GoogleFonts.montserrat(
                            color: kPrimary,
                            fontSize: MediaQuery.of(context).size.width * 0.039,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Penyakit tipes saya kambuh yang mengharuskan saya pulang.',
                          style: GoogleFonts.montserrat(
                            color: greyText,
                            fontSize: MediaQuery.of(context).size.width * 0.028,
                          ),
                        ),
                        TextSpan(
                          text: ' ”',
                          style: GoogleFonts.montserrat(
                            color: kPrimary,
                            fontSize: MediaQuery.of(context).size.width * 0.039,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.028,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
