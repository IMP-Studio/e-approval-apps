import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/create/create_cuti.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';

class CutiScreen extends StatefulWidget {
  const CutiScreen({super.key});

  @override
  State<CutiScreen> createState() => _CutiScreenState();
}

class _CutiScreenState extends State<CutiScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime today = DateTime.now();
  int activeIndex = 0;
  SharedPreferences? preferences;
  bool isButtonVisible = true;

  void hideButton() {
    if (isButtonVisible) {
      setState(() {
        isButtonVisible = false;
      });
    }
  }

  void showButton() {
    if (!isButtonVisible) {
      setState(() {
        isButtonVisible = true;
      });
    }
  }

  void startTimer() {
    // Start a timer to hide the button after 2 seconds of inactivity
    Duration duration = Duration(seconds: 2);
    Future.delayed(duration, hideButton);
  }

  @override
  void initState() {
    super.initState();
    getUserData().then((_) {
      getCuti();
      getProfil();
      startTimer();
    });

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  Future getCuti({String? jenisCuti}) async {
    int userId = preferences?.getInt('user_id') ?? 0;
    final String baseUrl =
        'https://85d1-2404-8000-1027-303f-c7c-d051-4a64-56ab.ngrok-free.app/api/cuti';
    final Map<String, String> queryParams = {'id': userId.toString()};

    if (jenisCuti != null) {
      queryParams['jenis_cuti'] = jenisCuti;
    }

    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(uri);
    print("Final API URL: $uri");
    print("API Response: ${response.body}");

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getProfil() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://85d1-2404-8000-1027-303f-c7c-d051-4a64-56ab.ngrok-free.app/api/profile?id=$userId';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
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

  Future? _cutiFuture;

  void refreshData() async {
    String jenisCuti = "";

    switch (activeIndex) {
      case 0:
        jenisCuti = "KHUSUS";
        break;
      case 1:
        jenisCuti = "DARURAT";
        break;
      case 2:
        jenisCuti = "TAHUNAN";
        break;
    }

    setState(() {
      isLoading = true;
      _cutiFuture = getCuti(jenisCuti: jenisCuti); // set the future here
    });

    final data = await _cutiFuture;

    setState(() {
      isLoading = false;
      // Process 'data' and update your UI accordingly
    });
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + ' ...selengkapnya';
    }
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 0;
              });
              refreshData();
            },
            child: Container(
              width: 80.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: activeIndex == 0 ? kTextoo : Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color:
                      activeIndex == 0 ? Colors.transparent : kTextUnselected,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "Khusus",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                    fontSize: 10.0,
                    color: activeIndex == 0 ? Colors.white : kTextUnselected,
                    fontWeight:
                        activeIndex == 0 ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              )),
            ),
          ),
          Divider(),
          SizedBox(
            width: 15.0,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 1;
              });
              refreshData();
            },
            child: Container(
              width: 80.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: activeIndex == 1 ? kTextoo : Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color:
                      activeIndex == 1 ? Colors.transparent : kTextUnselected,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "Darurat",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                      fontSize: 10.0,
                      color: activeIndex == 1 ? Colors.white : kTextUnselected,
                      fontWeight:
                          activeIndex == 1 ? FontWeight.w600 : FontWeight.w500),
                ),
              )),
            ),
          ),
          Divider(),
          SizedBox(
            width: 15.0,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 2;
              });
              refreshData();
            },
            child: Container(
              width: 80.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: activeIndex == 2 ? kTextoo : Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color:
                      activeIndex == 2 ? Colors.transparent : kTextUnselected,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "Tahunan",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                      fontSize: 10.0,
                      color: activeIndex == 2 ? Colors.white : kTextUnselected,
                      fontWeight:
                          activeIndex == 2 ? FontWeight.w600 : FontWeight.w500),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showButton();
        startTimer();
      },
      onVerticalDragUpdate: (details) {
        showButton();
        startTimer();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color.fromARGB(35, 36, 109, 193),
                      Color.fromARGB(43, 36, 109, 193)
                    ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 340,
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12.0)),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50.0,
                      height: 1.0,
                      decoration: BoxDecoration(
                          color: kTextoo,
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Calendar",
                          style: GoogleFonts.getFont('Montserrat',
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black)),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Cuti",
                          style: GoogleFonts.getFont('Montserrat',
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: kTextoo)),
                        ),
                      ],
                    ),
                    Text(
                      "Cuti kamu bulan ini",
                      style: GoogleFonts.getFont('Montserrat',
                          textStyle: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: kTextBlcknw)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      TableCalendar(
                        // locale: "en_US",
                        rowHeight: 25,
                        focusedDay: today,
                        headerStyle: HeaderStyle(
                          leftChevronIcon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: kTextoo,
                            size: 10.0,
                          ),
                          leftChevronMargin: EdgeInsets.only(right: 30.0),
                          rightChevronIcon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: kTextoo,
                            size: 10.0,
                          ),
                          rightChevronMargin: EdgeInsets.only(left: 30.0),
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: GoogleFonts.getFont('Montserrat',
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kTextBlcknw)),
                        ),
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(20024, 1, 1),
                        calendarStyle: CalendarStyle(
                          outsideTextStyle:
                              TextStyle(fontSize: 10, color: Colors.grey),
                          todayTextStyle: GoogleFonts.getFont('Montserrat',
                              fontSize: 10, color: Colors.white),
                          todayDecoration: BoxDecoration(
                              shape: BoxShape.circle, color: kTextoo),
                          tablePadding: EdgeInsets.symmetric(horizontal: 10.0),
                          cellMargin: EdgeInsets.all(4),
                          weekendTextStyle: GoogleFonts.getFont('Montserrat',
                              textStyle: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(244, 67, 54, 1))),
                          defaultTextStyle: GoogleFonts.getFont('Montserrat',
                              textStyle: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: kTextBlcknw)),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: GoogleFonts.getFont(
                            'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                          weekendStyle: GoogleFonts.getFont(
                            'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Container(
                          width: double.infinity,
                          height: 20.0,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 249, 249, 249),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Text(
                                  "Cuti",
                                  style: GoogleFonts.getFont('Montserrat',
                                      fontSize: 10.0,
                                      color: kTextUnselected,
                                      fontWeight: FontWeight.w400),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      "Tahunan",
                                      style: GoogleFonts.getFont('Montserrat',
                                          fontSize: 10.0,
                                          color: kTextBlocker,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      width: 25.0,
                                    ),
                                    Text(
                                      "Khusus",
                                      style: GoogleFonts.getFont('Montserrat',
                                          fontSize: 10.0,
                                          color: kTextoo,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      width: 25.0,
                                    ),
                                    Text(
                                      "Darurat",
                                      style: GoogleFonts.getFont('Montserrat',
                                          fontSize: 10.0,
                                          color: kTextOren,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50.0,
                    height: 1.0,
                    decoration: BoxDecoration(
                        color: kTextoo,
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total",
                        style: GoogleFonts.getFont('Montserrat',
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Cuti",
                        style: GoogleFonts.getFont('Montserrat',
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: kTextoo)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Cuti tahunan, Khusus, dan Darurat",
                    style: GoogleFonts.getFont('Montserrat',
                        textStyle: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: kTextBlcknw)),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IndexedStack(
                    index: _tabController.index,
                    children: [
                      buildContent(),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : FutureBuilder(
                        future: _cutiFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data['data'] == null ||
                                snapshot.data['data'].isEmpty) {
                              // Return an Image or placeholder here
                              return Center(
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              );
                            }
                            return ListView.builder(
                                padding: EdgeInsets.only(top: 4),
                                itemCount: snapshot.data['data'].length,
                                itemBuilder: (context, index) {
                                  print(snapshot.data['data']);
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                              color: kTextoo,
                                              borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(8.0),
                                                  topLeft:
                                                      Radius.circular(8.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                                vertical: 10.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Allowed",
                                                  style: GoogleFonts.getFont(
                                                      'Montserrat',
                                                      color: Colors.white,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "4 January 2023",
                                                      style:
                                                          GoogleFonts.getFont(
                                                              'Montserrat',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      "-",
                                                      style:
                                                          GoogleFonts.getFont(
                                                              'Montserrat',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      "10 August 2023",
                                                      style:
                                                          GoogleFonts.getFont(
                                                              'Montserrat',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 70.0,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(8.0),
                                                  bottomLeft:
                                                      Radius.circular(8.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.25),
                                                    spreadRadius: 0,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 1))
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Alasan",
                                                  style: GoogleFonts.getFont(
                                                      'Montserrat',
                                                      color: Colors.black,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  truncateText(
                                                      "Karena ada acara keluarga yang hanya 3 tahun, Karena ada acara",
                                                      60),
                                                  maxLines: 2,
                                                  style: GoogleFonts.getFont(
                                                      'Montserrat',
                                                      color: Colors.black,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
        floatingActionButton: isButtonVisible
            ? FutureBuilder<Map<String, dynamic>>(
                future: getProfil(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 140.0,
                          height: 55.0,
                          decoration: BoxDecoration(
                              color: kTextoo,
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Minta Cuti",
                              style: GoogleFonts.getFont('Montserrat',
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateCuti(
                                      profile: snapshot.data?['data']?.first,
                                    ),
                                  ));
                            },
                            child: Icon(Icons.add),
                            backgroundColor: kTextooAgakGelap,
                            elevation: 0,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
