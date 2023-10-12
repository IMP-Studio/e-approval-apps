import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/create/create_standup.dart';
import 'package:imp_approval/screens/detail/detail_standup.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/screens/edit/edit_standup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:imp_approval/screens/general_standup.dart';

class StandUp extends StatefulWidget {
  const StandUp({super.key});

  @override
  State<StandUp> createState() => _StandUpState();
}

class _StandUpState extends State<StandUp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Future<void> _refreshStandUp() async {
    print("StandUp page refreshed");
    setState(() {
      _refreshContent();
    });
  }

  Future<List<dynamic>>? standUpData;
  late TabController _tabController;
  int activeIndex = 0;
  bool isButtonVisible = true;
  Future<List<dynamic>>? _dataFuture;

  late Timer _timer; // Define the timer
  bool _isMounted = false;
  bool _isSnackbarVisible = false;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _isMounted = true;
  }

  void showSnackbarWarning(String message, String submessage,
      Color backgroundColor, Icon customIcon) {
    if (_isSnackbarVisible) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }

    _isSnackbarVisible = true;

    int secondsRemaining = 3; // Set the initial duration to 10 seconds
    _timer.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isMounted) {
        timer.cancel();
        return;
      }

      if (secondsRemaining == 0) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _isSnackbarVisible = false;
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
    final snackBar = SnackBar(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.8),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [customIcon],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Text(
                                    message,
                                    style: GoogleFonts.getFont('Montserrat',
                                        textStyle: TextStyle(
                                            color: kBlck,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.034,
                                            fontWeight: FontWeight.w600)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  )),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                              ),
                              Text(
                                submessage,
                                style: GoogleFonts.getFont(
                                  'Montserrat',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              Container(
                width: 5,
                height: 49,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: Duration(seconds: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
    Duration duration = Duration(seconds: 4);
    Future.delayed(duration, hideButton);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _timer = Timer(Duration.zero, () {});
    _tabController = TabController(length: 2, vsync: this);
    getUserData().then((_) {
      _dataFuture = getStandUpUser();
      print(preferences?.getInt('user_id'));
    });
    startTimer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _isMounted = false;
    super.dispose();
  }

  SharedPreferences? preferences;

  int? currentUser; // to store the current user's ID

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();

    currentUser = preferences?.getInt('user_id');

    setState(() {
      isLoading = false;
    });
  }

  Future<List<dynamic>> getStandUpUser() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    final String baseUrl =
        'https://testing.impstudio.id/approvall/api/standup?id=$userId&scope=month';

    print("Fetching data from URL: $baseUrl"); // Debug line

    var response = await http.get(Uri.parse(baseUrl));
    print(response.body);
    var jsonData = jsonDecode(response.body);
    return jsonData['data'] ?? [];
  }

  Future<String> checkAbsensi() async {
    int userId = preferences?.getInt('user_id') ?? 0;

    final urlj = 'https://testing.impstudio.id/approvall/api/presence/$userId';
    var response = await http.get(Uri.parse(urlj));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('Server Response Status: ${jsonData['status']}'); // Debug line
      return jsonData['status'];
    } else {
      throw Exception('Failed to load attendance status');
    }
  }

  Future<void> _refreshContent() async {
    setState(() {
      _dataFuture = getStandUpUser();
    });
  }

  bool isLoading = false;

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
        body: RefreshIndicator(
          onRefresh: _refreshStandUp,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.only(bottom: 10),
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
                              padding: EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.width * 0.007,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 20.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "IMP STAND UP",
                                    style: GoogleFonts.getFont('Montserrat',
                                        textStyle: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.055,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.55,
                                    child: Text(
                                      "Tempat berbagi masalah dan project",
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
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.55,
                                    child: Text(
                                      "Laporkan aktivitasmu",
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
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SvgPicture.asset(
                            "assets/img/hero-image.svg",
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 21, right: 21),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "History Stand Up",
                                style: GoogleFonts.getFont('Montserrat',
                                    textStyle: TextStyle(
                                        color: hitamText,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.044)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GeneralStandUp()),
                                    );
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: activeIndex == 0
                                        ? Colors.transparent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(
                                      color: activeIndex == 0
                                          ? kTextoo
                                          : Colors.transparent,
                                      width: 1.0, // Lebar border
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "View General",
                                    style: GoogleFonts.getFont(
                                      'Montserrat',
                                      textStyle: TextStyle(
                                          fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.028,
                                          color: activeIndex == 0
                                              ? kTextoo
                                              : kTextUnselected,
                                          fontWeight: activeIndex == 0
                                              ? FontWeight.w600
                                              : FontWeight.w600),
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FutureBuilder<List<dynamic>>(
                          future: _dataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 7,
                                itemBuilder: (context, index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: 20, left: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 15),
                                            width: double.infinity,
                                            height: 95,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Color(0xffC2C2C2)
                                                        .withOpacity(0.30))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                IntrinsicHeight(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5,
                                                            left: 10,
                                                            right: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 15,
                                                                      bottom: 7,
                                                                      right: 5),
                                                              child: Container(
                                                                width: 20,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Container(
                                                              width:
                                                                  100, // Arbitrary width
                                                              height: 8.0,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Container(
                                                              width:
                                                                  50, // Arbitrary width
                                                              height: 8.0,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        VerticalDivider(
                                                          color:
                                                              Color(0xffE6E6E6),
                                                          thickness: 1,
                                                        ),
                                                        Spacer(),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              width:
                                                                  50, // Arbitrary width
                                                              height: 8.0,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Container(
                                                              width:
                                                                  30, // Arbitrary width
                                                              height: 8.0,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  color: Color(0xffD9D9D9)
                                                      .withOpacity(0.15),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10,
                                                            top: 10,
                                                            right: 10,
                                                            left: 10),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width:
                                                              50, // Arbitrary width
                                                          height: 8.0,
                                                          color: Colors.grey[300],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  40, // Arbitrary width
                                                              height: 8.0,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                              width:
                                                                  60, // Arbitrary width
                                                              height: 8.0,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
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
                                    ),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: 20, left: 20),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 15),
                                              width: double.infinity,
                                              height: 95,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xffC2C2C2)
                                                          .withOpacity(0.30))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              left: 10,
                                                              right: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 15,
                                                                        bottom: 7,
                                                                        right: 5),
                                                                child: Container(
                                                                  width: 20,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    100, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          VerticalDivider(
                                                            color:
                                                                Color(0xffE6E6E6),
                                                            thickness: 1,
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    30, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    color: Color(0xffD9D9D9)
                                                        .withOpacity(0.15),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10,
                                                              top: 10,
                                                              right: 10,
                                                              left: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width:
                                                                50, // Arbitrary width
                                                            height: 8.0,
                                                            color:
                                                                Colors.grey[300],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    40, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                width:
                                                                    60, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
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
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: 20, left: 20),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 15),
                                              width: double.infinity,
                                              height: 95,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xffC2C2C2)
                                                          .withOpacity(0.30))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              left: 10,
                                                              right: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 15,
                                                                        bottom: 7,
                                                                        right: 5),
                                                                child: Container(
                                                                  width: 20,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    100, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          VerticalDivider(
                                                            color:
                                                                Color(0xffE6E6E6),
                                                            thickness: 1,
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    30, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    color: Color(0xffD9D9D9)
                                                        .withOpacity(0.15),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10,
                                                              top: 10,
                                                              right: 10,
                                                              left: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width:
                                                                50, // Arbitrary width
                                                            height: 8.0,
                                                            color:
                                                                Colors.grey[300],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    40, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                width:
                                                                    60, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
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
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: 20, left: 20),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 15),
                                              width: double.infinity,
                                              height: 95,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xffC2C2C2)
                                                          .withOpacity(0.30))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              left: 10,
                                                              right: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 15,
                                                                        bottom: 7,
                                                                        right: 5),
                                                                child: Container(
                                                                  width: 20,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    100, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          VerticalDivider(
                                                            color:
                                                                Color(0xffE6E6E6),
                                                            thickness: 1,
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    30, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    color: Color(0xffD9D9D9)
                                                        .withOpacity(0.15),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10,
                                                              top: 10,
                                                              right: 10,
                                                              left: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width:
                                                                50, // Arbitrary width
                                                            height: 8.0,
                                                            color:
                                                                Colors.grey[300],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    40, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                width:
                                                                    60, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
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
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: 20, left: 20),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 15),
                                              width: double.infinity,
                                              height: 95,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xffC2C2C2)
                                                          .withOpacity(0.30))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              left: 10,
                                                              right: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 15,
                                                                        bottom: 7,
                                                                        right: 5),
                                                                child: Container(
                                                                  width: 20,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    100, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          VerticalDivider(
                                                            color:
                                                                Color(0xffE6E6E6),
                                                            thickness: 1,
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    30, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    color: Color(0xffD9D9D9)
                                                        .withOpacity(0.15),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10,
                                                              top: 10,
                                                              right: 10,
                                                              left: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width:
                                                                50, // Arbitrary width
                                                            height: 8.0,
                                                            color:
                                                                Colors.grey[300],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    40, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                width:
                                                                    60, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
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
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: 20, left: 20),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 15),
                                              width: double.infinity,
                                              height: 95,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xffC2C2C2)
                                                          .withOpacity(0.30))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              left: 10,
                                                              right: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 15,
                                                                        bottom: 7,
                                                                        right: 5),
                                                                child: Container(
                                                                  width: 20,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    100, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          VerticalDivider(
                                                            color:
                                                                Color(0xffE6E6E6),
                                                            thickness: 1,
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    30, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    color: Color(0xffD9D9D9)
                                                        .withOpacity(0.15),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10,
                                                              top: 10,
                                                              right: 10,
                                                              left: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width:
                                                                50, // Arbitrary width
                                                            height: 8.0,
                                                            color:
                                                                Colors.grey[300],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    40, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                width:
                                                                    60, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
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
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: 20, left: 20),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 15),
                                              width: double.infinity,
                                              height: 95,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xffC2C2C2)
                                                          .withOpacity(0.30))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              left: 10,
                                                              right: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 15,
                                                                        bottom: 7,
                                                                        right: 5),
                                                                child: Container(
                                                                  width: 20,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    100, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          VerticalDivider(
                                                            color:
                                                                Color(0xffE6E6E6),
                                                            thickness: 1,
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    30, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    color: Color(0xffD9D9D9)
                                                        .withOpacity(0.15),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10,
                                                              top: 10,
                                                              right: 10,
                                                              left: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width:
                                                                50, // Arbitrary width
                                                            height: 8.0,
                                                            color:
                                                                Colors.grey[300],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    40, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                width:
                                                                    60, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
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
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: 20, left: 20),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 15),
                                              width: double.infinity,
                                              height: 95,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xffC2C2C2)
                                                          .withOpacity(0.30))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              left: 10,
                                                              right: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 15,
                                                                        bottom: 7,
                                                                        right: 5),
                                                                child: Container(
                                                                  width: 20,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    100, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          VerticalDivider(
                                                            color:
                                                                Color(0xffE6E6E6),
                                                            thickness: 1,
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    50, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width:
                                                                    30, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    color: Color(0xffD9D9D9)
                                                        .withOpacity(0.15),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10,
                                                              top: 10,
                                                              right: 10,
                                                              left: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width:
                                                                50, // Arbitrary width
                                                            height: 8.0,
                                                            color:
                                                                Colors.grey[300],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    40, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                width:
                                                                    60, // Arbitrary width
                                                                height: 8.0,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
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
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                  child: Container(color: Colors.white));
                            } else {
                              return ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: snapshot.data!.map<Widget>((itemData) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (currentUser == itemData['user_id']) {
                                        // If the current user is the owner of the data, navigate to EditScreen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditStandUp(standup: itemData)),
                                        ).then((result) {
                                          if (result == 'refresh') {
                                            _refreshContent(); // Call your refresh logic
                                          }
                                        });
                                      } else {
                                        // Otherwise, navigate to DetailScreen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailStandUp(
                                                  standup: itemData)),
                                        );
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 22.0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10.0),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: itemData[
                                                                  'blocker'] ==
                                                              null
                                                          ? [
                                                              Color(0xff4381CA),
                                                              Color(0xff4381CA)!
                                                            ] // Colors when blocker is not null
                                                          : [
                                                              kTextBlocker,
                                                              kTextBlockerr
                                                            ] // Default colors
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 22.0),
                                            child: Container(
                                              margin: EdgeInsets.only(left: 12.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.26,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: kTextUnselectedOpa),
                                                  borderRadius: BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10.0),
                                                      bottomRight:
                                                          Radius.circular(10.0))),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.person_outlined,
                                                          color: kTextUnselectedd,
                                                          size: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.044,
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        Text(
                                                          itemData[
                                                              'nama_lengkap'],
                                                          style: GoogleFonts.getFont(
                                                              'Montserrat',
                                                              textStyle: TextStyle(
                                                                  color:
                                                                      kTextUnselectedd,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.028,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          height: 4.0,
                                                          width: 4.0,
                                                          decoration: BoxDecoration(
                                                              gradient: LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    kTextoo,
                                                                    kTextoo
                                                                  ]),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2.0)),
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        itemData['blocker'] ==
                                                                null
                                                            ? Text(
                                                                "Done",
                                                                style: GoogleFonts.getFont(
                                                                    'Montserrat',
                                                                    textStyle: TextStyle(
                                                                        color:
                                                                            kTextUnselected,
                                                                        fontSize: MediaQuery.of(context)
                                                                                .size
                                                                                .width *
                                                                            0.028)),
                                                              )
                                                            : Text(
                                                                "Blocker",
                                                                style: GoogleFonts.getFont(
                                                                    'Montserrat',
                                                                    textStyle: TextStyle(
                                                                        color:
                                                                            kTextUnselected,
                                                                        fontSize: MediaQuery.of(context)
                                                                                .size
                                                                                .width *
                                                                            0.028)),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0, left: 12.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 200,
                                                            height: 15,
                                                            child: Text(
                                                              itemData['project'],
                                                              style: GoogleFonts.getFont(
                                                                  'Montserrat',
                                                                  textStyle: TextStyle(
                                                                      color:
                                                                          kBlck,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.034,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              softWrap: true,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 20.0,
                                                            bottom: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .access_time_outlined,
                                                              color:
                                                                  kTextUnselectedd,
                                                              size: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.044,
                                                            ),
                                                            SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            Text(
                                                              itemData['jam'],
                                                              style: GoogleFonts.getFont(
                                                                  'Montserrat',
                                                                  textStyle: TextStyle(
                                                                      color:
                                                                          kTextUnselectedd,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.028,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                            )
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          DateFormat('dd MMM')
                                                              .format(DateTime.parse(
                                                                      itemData[
                                                                          'created_at']) ??
                                                                  DateTime.now()),
                                                          style: GoogleFonts.getFont(
                                                              'Montserrat',
                                                              textStyle: TextStyle(
                                                                  color:
                                                                      kTextUnselectedd,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.028,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: isButtonVisible
            ? Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 140.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                        color: kTextoo,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "STAND UP",
                        style: GoogleFonts.getFont('Montserrat',
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.028,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      height: 45,
                      width: 45,
                      child: FloatingActionButton(
                        onPressed: () async {
                          var responseStatus = await checkAbsensi();
                          if (responseStatus == 'checkedIn' ||
                              responseStatus == 'checkedOut' || responseStatus == 'Perjadin') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateStandup(),
                              ),
                            );
                          } else if (responseStatus == 'pendingStatus') {
                            final snackBar = showSnackbarWarning(
                                "Tunggu sebentar...",
                                "Request dalam status pending.",
                                kYelw,
                                Icon(
                                  LucideIcons.alertCircle,
                                  size: 26.0,
                                  color: kYelw,
                                ));
                          } else if (responseStatus == 'Leave') {
                            final snackBar = showSnackbarWarning(
                                "Kamu sedang cuti",
                                "Nikmati liburanmu sejenak.",
                                kYelw,
                                Icon(
                                  LucideIcons.alertCircle,
                                  size: 26.0,
                                  color: kYelw,
                                ));
                          } else if (responseStatus == 'Bolos') {
                            final snackBar = showSnackbarWarning(
                                "Kamu sedang bolos",
                                "Tolong jangan diulangi lagi.",
                                kTextBlocker,
                                Icon(
                                  LucideIcons.xCircle,
                                  size: 26.0,
                                  color: kTextBlocker,
                                ));
                          } else {
                            final SnackBar = showSnackbarWarning(
                                "Wait...",
                                "Absen terlebih dahulu.",
                                kYelw,
                                Icon(
                                  LucideIcons.alertCircle,
                                  size: 26.0,
                                  color: kYelw,
                                ));
                          }
                        },
                        child: Icon(LucideIcons.users),
                        backgroundColor: kTextooAgakGelap,
                        elevation: 0,
                        hoverElevation: 0,
                      ),
                    ),
                  ),
                ],
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
