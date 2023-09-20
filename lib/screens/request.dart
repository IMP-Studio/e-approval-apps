import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/screens/detail/detail_absensi.dart';
import 'package:imp_approval/screens/detail/detail_request_cuti.dart';
import 'package:imp_approval/screens/detail/detail_request_perjadin.dart';
import 'package:imp_approval/screens/detail/detail_request_wfa.dart';
import 'package:imp_approval/screens/detail/detail_wfo.dart';
import 'package:imp_approval/screens/home.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:math';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class RequestScreen extends StatefulWidget {
  final dynamic profile;
  const RequestScreen({super.key, required this.profile});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  SharedPreferences? preferences;

  void initState() {
    super.initState();
    getUserData().then((_) {
      print(preferences?.getInt('user_id'));
      getAbsensiAll();
      getAbsensiRejected();
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

  Future getAbsensiAll() async {
    int userId = preferences?.getInt('user_id') ?? 0;

    String baseURL =
        'https://testing.impstudio.id/approvall/api/presence?id=${widget.profile['user_id']}';
    // String commonParams = '&status=pending';

    String specificParams;
    if (widget.profile['permission'] == 'head_of_tribe') {
      specificParams = '&status=pending,rejected,allowed&permission=ordinary_employee';
    } else if (widget.profile['permission'] == 'human_resource') {
      specificParams =
          '&status=allow_HT,rejected,allowed&permission=head_of_tribe,ordinary_employee';
    } else {
      specificParams = '';
    }

    final String urlj = '$baseURL?$specificParams';

    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    print(urlj);
    return jsonDecode(response.body);
  }
  Future getAbsensiRejected() async {
    int userId = preferences?.getInt('user_id') ?? 0;

    final String urlj =  'https://testing.impstudio.id/approvall/api/presence?id=${widget.profile['user_id']}&status=rejected';

    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    print(urlj);
    return jsonDecode(response.body);
  }

  bool isExpanded = false;

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + '...';
    }
  }

  String categoryText(String? category) {
    switch (category) {
      case 'WFO':
        return 'WFO';
      case 'telework':
        return 'WFA';
      case 'work_trip':
        return 'Perjadin';
      case 'leave':
        return 'Cuti';
      default:
        return 'Unknown';
    }
  }

  Widget _buildCategoryContainer(String category, Map<String, dynamic> data) {
    if (category == 'telework') {
      return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Row(
          children: [
            Flexible(
              child: Text(
                truncateText(data['category_description'] ?? '', 80),
                style: GoogleFonts.getFont(
                  "Montserrat",
                  fontSize: MediaQuery.of(context).size.width * 0.025,
                  color: kTextBlcknw,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (category == 'work_trip') {
      return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Row(
          children: [
            Icon(
              Icons.attach_file_rounded,
              color: kTextUnselected,
              size: MediaQuery.of(context).size.width * 0.034,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.008,
            ),
            Text(
              "Send Files",
              style: GoogleFonts.getFont(
                "Montserrat",
                fontSize: MediaQuery.of(context).size.width * 0.030,
                color: kBlck,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else if (category == 'leave') {
      return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Row(
          children: [
            Flexible(
              child: Text(
                truncateText(data['type_description'] ?? '', 80),
                style: GoogleFonts.getFont(
                  "Montserrat",
                  fontSize: MediaQuery.of(context).size.width * 0.025,
                  color: kTextBlcknw,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(); // Default empty container for any other cases.
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget getStatusRow(String status) {
      Color containerColor;
      Color textColor;
      String text;

      switch (status) {
        case 'rejected':
          containerColor = Color(0xffF9DCDC);
          textColor =
              Color(0xffCA4343); // Or any color that matches well with red.
          text = 'Rejected';
          break;
        case 'pending':
          containerColor = Color(0xffFFEFC6);
          textColor =
              Color(0xffFFC52D); // Black usually matches well with yellow.
          text = 'Pending';
          break;
        case 'allowed':
          containerColor = kGreenAllow; // Assuming kGreenAllow is green
          textColor = kGreen; // Your green color for text
          text = 'Allowed';
          break;
        case '':
          containerColor = kGreenAllow; // Assuming kGreenAllow is green
          textColor = kGreen; // Your green color for text
          text = 'Allowed';
          break;
        case 'allow_HT':
          containerColor = Color(0xffFFEFC6);
          textColor =
              Color(0xffFFC52D); // Black usually matches well with yellow.
          text = 'Pending';
          break;
        default:
          containerColor = Colors.grey;
          textColor = Colors.white;
          text = 'Unknown Status';
      }

      return Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.0255)),
            child: Text(
              text,
              style: GoogleFonts.getFont("Montserrat",
                  fontSize: MediaQuery.of(context).size.width * 0.025,
                  color: textColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainLayout(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_rounded,
                      color: kTextoo,
                      size: MediaQuery.of(context).size.width * 0.050,
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
                                      MediaQuery.of(context).size.width * 0.044,
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
                                      MediaQuery.of(context).size.width * 0.044,
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
              FutureBuilder(
                  future: getAbsensiAll(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data?['data'] == null ||
                          snapshot.data['data'].isEmpty) {
                        return Center(
                          child: Container(
                            color: Colors.white,
                          ),
                        );
                      }
                      var limitedData = snapshot.data['data'].toList();
                         
                      return Column(
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
                                            color: kTextUnselectedOpa,
                                            width: 1.0))),
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
                                                    ? Icons
                                                        .keyboard_arrow_up_rounded
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
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: limitedData.length,
                                          itemBuilder: (context, index) {
                                             String currentStatus = snapshot.data['data'][index]['status'] ?? '';

    Widget statusWidget = getStatusRow(currentStatus);
                                            print(snapshot.data['data']);
                                            print(limitedData[index]
                                                ['entry_time']);
                                            print(snapshot.data['data'][index]
                                                ['entry_time']);
                                            // String currentStatus = snapshot
                                            //     .data['status'][index];
                                            // Widget statusWidget =
                                            //     getStatusRow(currentStatus);

                                            return GestureDetector(
                                              onTap: () {
                                                String category = snapshot
                                                        .data['data'][index][
                                                    'category']; // Assuming your data has a 'category' key.

                                                Widget detailPage;

                                                switch (category) {
                                                  case 'WFO':
                                                    detailPage =
                                                        DetailWfo(
                                                            absen: snapshot
                                                                    .data[
                                                                'data'][index]);
                                                    break;
                                                  case 'telework':
                                                    detailPage =
                                                        DetailRequestWfa(
                                                            absen: snapshot
                                                                    .data[
                                                                'data'][index]);
                                                    break;
                                                  case 'work_trip':
                                                    detailPage =
                                                        DetailRequestPerjadin(
                                                            absen: snapshot
                                                                    .data[
                                                                'data'][index]);
                                                    break;
                                                  case 'leave':
                                                    detailPage =
                                                        DetailRequestCuti(
                                                            absen: snapshot
                                                                    .data[
                                                                'data'][index]);
                                                    break;
                                                  default:
                                                    detailPage = DetailAbsensi(
                                                        absen: snapshot
                                                                .data['data']
                                                            [index]);
                                                    break;
                                                }

                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      detailPage,
                                                ));
                                              },
                                              child: Container(
                                                // margin: EdgeInsets.only(right: 5.0),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.0),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                kTextUnselectedOpa))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              snapshot.data[
                                                                          'data']
                                                                      [index][
                                                                  'nama_lengkap'],
                                                              style: GoogleFonts.getFont(
                                                                  "Montserrat",
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.034,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.006,
                                                        ),
                                                        //if leave
                                                        _buildCategoryContainer(
                                                            snapshot.data[
                                                                        'data']
                                                                    [index]
                                                                ['category'],
                                                            snapshot.data[
                                                                'data'][index]),
                                                        SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "JENIS",
                                                              style: GoogleFonts.getFont(
                                                                  "Montserrat",
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.025,
                                                                  color:
                                                                      kTextUnselected,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Text(
                                                              ":",
                                                              style: GoogleFonts.getFont(
                                                                  "Montserrat",
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.025,
                                                                  color:
                                                                      kTextUnselected,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Text(
                                                              categoryText(snapshot
                                                                          .data[
                                                                      'data'][index]
                                                                  ['category']),
                                                              style: GoogleFonts.getFont(
                                                                  "Montserrat",
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.025,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 20.0),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    DateFormat('dd MMMM').format(DateTime.parse(snapshot.data['data'][index]
                                                                            [
                                                                            'date']) ??
                                                                        DateTime
                                                                            .now()),
                                                                    style: GoogleFonts.getFont(
                                                                        "Montserrat",
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.025,
                                                                        color:
                                                                            kTextBlcknw,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.008,
                                                              ),
                                                              statusWidget
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: GFAccordion(
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
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: kTextUnselectedOpa,
                                  width: 1.0,
                                ),
                              ),
                            ),
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
                                                ? Icons
                                                    .keyboard_arrow_up_rounded
                                                : Icons
                                                    .keyboard_arrow_down_rounded,
                                            size: 16,
                                            color: kTextBlcknw,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2, // You can adjust the width as needed
                                            height: 10.0,
                                            color: Colors.grey[300],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          // contentChild: Container(),
                        ),
                      );
                    }
                  }),

                  

              FutureBuilder(
                  future: getAbsensiRejected(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data?['data'] == null ||
                          snapshot.data['data'].isEmpty) {
                        return Center(
                          child: Container(
                            color: Colors.white,
                          ),
                        );
                      }
                      var limitedData = snapshot.data['data'].toList();

                      return Column(
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
                                            color: kTextUnselectedOpa,
                                            width: 1.0))),
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
                                                    ? Icons
                                                        .keyboard_arrow_up_rounded
                                                    : Icons
                                                        .keyboard_arrow_down_rounded,
                                                size: 16,
                                                color: kTextBlcknw,
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                "Rejected",
                                                style: GoogleFonts.getFont(
                                                    "Montserrat",
                                                    color: kTextBlcknw,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: limitedData.length,
                                          itemBuilder: (context, index) {
                                            String currentStatus = snapshot.data['data'][index]['status'];

    Widget statusWidget = getStatusRow(currentStatus);
                                            print(snapshot.data['data']);
                                            print(limitedData[index]
                                                ['entry_time']);
                                            print(snapshot.data['data'][index]
                                                ['entry_time']);
                                            // String currentStatus = snapshot
                                            //     .data['status'][index];
                                            // Widget statusWidget =
                                            //     getStatusRow(currentStatus);

                                            return GestureDetector(
                                              onTap: () {
                                                String category = snapshot
                                                        .data['data'][index][
                                                    'category']; // Assuming your data has a 'category' key.

                                                Widget detailPage;

                                                switch (category) {
                                                  case 'telework':
                                                    detailPage =
                                                        DetailRequestWfa(
                                                            absen: snapshot
                                                                    .data[
                                                                'data'][index]);
                                                    break;
                                                  case 'work_trip':
                                                    detailPage =
                                                        DetailRequestPerjadin(
                                                            absen: snapshot
                                                                    .data[
                                                                'data'][index]);
                                                    break;
                                                  case 'leave':
                                                    detailPage =
                                                        DetailRequestCuti(
                                                            absen: snapshot
                                                                    .data[
                                                                'data'][index]);
                                                    break;
                                                  default:
                                                    detailPage = DetailAbsensi(
                                                        absen: snapshot
                                                                .data['data']
                                                            [index]);
                                                    break;
                                                }

                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      detailPage,
                                                ));
                                              },
                                              child: Container(
                                                // margin: EdgeInsets.only(right: 5.0),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.0),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                kTextUnselectedOpa))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              snapshot.data[
                                                                          'data']
                                                                      [index][
                                                                  'nama_lengkap'],
                                                              style: GoogleFonts.getFont(
                                                                  "Montserrat",
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.034,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.006,
                                                        ),
                                                        //if leave
                                                        _buildCategoryContainer(
                                                            snapshot.data[
                                                                        'data']
                                                                    [index]
                                                                ['category'],
                                                            snapshot.data[
                                                                'data'][index]),
                                                        SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "JENIS",
                                                              style: GoogleFonts.getFont(
                                                                  "Montserrat",
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.025,
                                                                  color:
                                                                      kTextUnselected,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Text(
                                                              ":",
                                                              style: GoogleFonts.getFont(
                                                                  "Montserrat",
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.025,
                                                                  color:
                                                                      kTextUnselected,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Text(
                                                              categoryText(snapshot
                                                                          .data[
                                                                      'data'][index]
                                                                  ['category']),
                                                              style: GoogleFonts.getFont(
                                                                  "Montserrat",
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.025,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 20.0),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    DateFormat('dd MMMM').format(DateTime.parse(snapshot.data['data'][index]
                                                                            [
                                                                            'date']) ??
                                                                        DateTime
                                                                            .now()),
                                                                    style: GoogleFonts.getFont(
                                                                        "Montserrat",
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.025,
                                                                        color:
                                                                            kTextBlcknw,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.008,
                                                              ),
                                                              statusWidget
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: GFAccordion(
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
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: kTextUnselectedOpa,
                                  width: 1.0,
                                ),
                              ),
                            ),
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
                                                ? Icons
                                                    .keyboard_arrow_up_rounded
                                                : Icons
                                                    .keyboard_arrow_down_rounded,
                                            size: 16,
                                            color: kTextBlcknw,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2, // You can adjust the width as needed
                                            height: 10.0,
                                            color: Colors.grey[300],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          // contentChild: Container(),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
