import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/detail/detail_request_cuti.dart';
import 'package:imp_approval/screens/detail/detail_request_perjadin.dart';
import 'package:imp_approval/screens/detail/detail_request_wfa.dart';
import 'package:imp_approval/screens/home.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool isExpanded = false;

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: kTextoo,
                  size: MediaQuery.of(context).size.width * 0.050,
                ),
              ),
              SizedBox(
                width: 6.0,
              ),
              Text(
                "Kembali",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  fontSize: MediaQuery.of(context).size.width * 0.0345,
                  fontWeight: FontWeight.w400,
                  color: kTextoo,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                LucideIcons.userCheck,
                size: MediaQuery.of(context).size.width * 0.06,
                color: kTextoo,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.13,
                        height: MediaQuery.of(context).size.width * 0.003,
                        decoration: BoxDecoration(
                            color: kTextoo,
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text(
                            "Permintaan",
                            style: GoogleFonts.getFont('Montserrat',
                                textStyle: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.044,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "Terkini",
                            style: GoogleFonts.getFont('Montserrat',
                                textStyle: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.044,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "Pantau permintaan WFA,",
                        style: GoogleFonts.getFont('Montserrat',
                            textStyle: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0344,
                                fontWeight: FontWeight.w600,
                                color: kTextBlcknw)),
                      ),
                      Text(
                        "Perjadin & Cuti",
                        style: GoogleFonts.getFont('Montserrat',
                            textStyle: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0344,
                                fontWeight: FontWeight.w600,
                                color: kTextBlcknw)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Column(
                  children: <Widget>[
                    GFAccordion(
                      onToggleCollapsed: (isExpandedNow) {
                        setState(() {
                          isExpanded = isExpandedNow;
                        });
                      },
                      collapsedIcon: Icon(
                        Icons.abc,
                        color: Colors.transparent,
                      ),
                      expandedIcon: Icon(
                        Icons.abc,
                        color: Colors.transparent,
                      ),
                      collapsedTitleBackgroundColor: Colors.transparent,
                      expandedTitleBackgroundColor: Colors.transparent,
                      contentBackgroundColor: Colors.transparent,
                      titleChild: Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          // height: 55.0,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 1.0))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 6.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Icon(
                                          isExpanded
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons
                                                  .keyboard_arrow_down_rounded,
                                          size: 16,
                                          color: kTextBlcknw,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Semua",
                                          style: GoogleFonts.getFont(
                                              "Montserrat",
                                              color: kTextBlcknw,
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0344,
                                              height: 1.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      contentChild: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DetailRequestWfa()));
                            },
                            child: Container(
                              // margin: EdgeInsets.only(right: 5.0),
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: kTextUnselectedOpa))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Fathir Akmal Burhanuddin",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.034,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.006,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Row(
                                          children: [
                                            Flexible(
                                                child: Text(
                                              truncateText(
                                                  "Lorem ipsum dolor sit amet consectetur. Vestibulum pretium pharetra cursus non massa",
                                                  80),
                                              style: GoogleFonts.getFont(
                                                  "Montserrat",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.025,
                                                  color: kTextBlcknw,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "JENIS",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                color: kTextUnselected,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text(
                                            ":",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                color: kTextUnselected,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text(
                                            "WFA",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "23 Agustus",
                                                  style: GoogleFonts.getFont(
                                                      "Montserrat",
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.025,
                                                      color: kTextBlcknw,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.008,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  decoration: BoxDecoration(
                                                      color: kYelwPending,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.0255)),
                                                  child: Text(
                                                    "Pending",
                                                    style: GoogleFonts.getFont(
                                                        "Montserrat",
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.025,
                                                        color: kYelwNew,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DetailRequestPerjadin()));
                            },
                            child: Container(
                              // margin: EdgeInsets.only(right: 5.0),
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: kTextUnselectedOpa))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Fathir Akmal Burhanuddin",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.034,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.006,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.attach_file_rounded,
                                              color: kTextUnselected,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.034,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.008,
                                            ),
                                            Text(
                                              "Send Files",
                                              style: GoogleFonts.getFont(
                                                  "Montserrat",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.030,
                                                  color: kBlck,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "JENIS",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                color: kTextUnselected,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text(
                                            ":",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                color: kTextUnselected,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text(
                                            "Perjadin",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "23 Agustus",
                                                  style: GoogleFonts.getFont(
                                                      "Montserrat",
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.025,
                                                      color: kTextBlcknw,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.008,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  decoration: BoxDecoration(
                                                      color: kGreenAllow,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.0255)),
                                                  child: Text(
                                                    "Allowed",
                                                    style: GoogleFonts.getFont(
                                                        "Montserrat",
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.025,
                                                        color: kGreen,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DetailRequestCuti()));
                            },
                            child: Container(
                              // margin: EdgeInsets.only(right: 5.0),
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: kTextUnselectedOpa))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Fathir Akmal Burhanuddin",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.034,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.006,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Row(
                                          children: [
                                            Flexible(
                                                child: Text(
                                              truncateText(
                                                  "Lorem ipsum dolor sit amet consectetur. Vestibulum pretium pharetra cursus non massa",
                                                  80),
                                              style: GoogleFonts.getFont(
                                                  "Montserrat",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.025,
                                                  color: kTextBlcknw,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "JENIS",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                color: kTextUnselected,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text(
                                            ":",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                color: kTextUnselected,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text(
                                            "Cuti",
                                            style: GoogleFonts.getFont(
                                                "Montserrat",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "23 Agustus",
                                                  style: GoogleFonts.getFont(
                                                      "Montserrat",
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.025,
                                                      color: kTextBlcknw,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.008,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  decoration: BoxDecoration(
                                                      color: kRedreject,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.0255)),
                                                  child: Text(
                                                    "Reject",
                                                    style: GoogleFonts.getFont(
                                                        "Montserrat",
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.025,
                                                        color: kTextBlocker,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
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
