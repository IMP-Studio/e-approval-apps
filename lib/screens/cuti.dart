import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/create/create_cuti.dart';
import 'package:imp_approval/screens/detail/detail_cuti.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';
import 'package:imp_approval/models/leave_model.dart';
import 'package:imp_approval/models/national_leave_model.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CutiScreen extends StatefulWidget {
  const CutiScreen({super.key});

  @override
  State<CutiScreen> createState() => _CutiScreenState();
}

class _CutiScreenState extends State<CutiScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  DateTime today = DateTime.now();
  int activeIndex = 0;
  SharedPreferences? preferences;
  bool isButtonVisible = true;
  DateTime? _lastRefreshTime;

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
    Duration duration = const Duration(seconds: 2);
    Future.delayed(duration, hideButton);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getUserData().then((_) {
      setState(() {
        refreshData();
        processCutiData();
        getProfil();
        startTimer();
        _cutiDays = getLeaveDays();
        _cutiYearlyDays = getLeaveYearlyDays();
      });
    });


    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          activeIndex = _tabController.index;
          refreshData();
        });
      }
    });

    activeIndex = 1;
    _timer = Timer(Duration.zero, () {});
    _isMounted = true;
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging || _tabController.index == 0) {
      setState(() {
        activeIndex = _tabController.index;
        refreshData();
      });
    }
  }

  Future getLeaveDays() async {
   int userId = preferences?.getInt('user_id') ?? 0;

    final String baseUrl =
        'https://admin.approval.impstudio.id/api/leave/days?id=$userId';

    var response = await http.get(Uri.parse(baseUrl));
    print("Final API URL: $baseUrl");
    print("API Response: ${response.body}");

    return jsonDecode(response.body);
  }

  Future getLeaveYearlyDays() async {
    int userId = preferences?.getInt('user_id') ?? 0;

    final String baseUrl =
        'https://admin.approval.impstudio.id/api/leave/yearly/days?id=$userId';

    var response = await http.get(Uri.parse(baseUrl));
    print("Final API URL: $baseUrl");
    print("API Response: ${response.body}");

    return jsonDecode(response.body);
  }

  Future<String> checkAbsensi() async {
    int userId = preferences?.getInt('user_id') ?? 0;

    final urlj = 'https://admin.approval.impstudio.id/api/presence/$userId';
    var response = await http.get(Uri.parse(urlj));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('Server Response Status: ${jsonData['status']}'); // Debug line
      return jsonData['status'];
    } else {
      throw Exception('Failed to load attendance status');
    }
  }

  Map<DateTime, String> leaveDays = {};

  Future<void> processCutiData() async {
    try {
      print("Start processing leaves");
      final leaves = await _cutiFuture;
      print("Leaves data: $leaves");

      for (var leave in leaves ?? []) {
        if (leave?.status == "allowed") {
          // Use null-aware operators to safely access nullable properties
          DateTime? startDate = DateTime.tryParse(leave?.startDate ?? "");
          DateTime? endDate = DateTime.tryParse(leave?.endDate ?? "");
          String? type = leave?.type;

          if (startDate != null && endDate != null && type != null) {
            for (var day = startDate;
                day.isBefore(endDate.add(const Duration(days: 1)));
                day = day.add(const Duration(days: 1))) {
              leaveDays[day] = type;
            }
          }
        }
      }

      print("Start fetching national leaves");
      final nationalLeaves = await fetchAllNationalLeaves("2023");
      print("National leaves data: $nationalLeaves");

      for (var nationalLeave in nationalLeaves) {
        print("Processing national leave: $nationalLeave");
        DateTime? nationalDate =
            DateTime.tryParse(nationalLeave.holidayDate ?? "");

        if (nationalDate != null) {
          leaveDays[nationalDate] = 'national';
        }
      }

      setState(() {});
      print("Updated leaveDays: $leaveDays");
    } catch (e, stackTrace) {
      print("Error processing leave data: $e");
      print("StackTrace: $stackTrace");
    }
  }

  Future<Map<String, dynamic>> getProfil() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://admin.approval.impstudio.id/api/profile?user_id=$userId';
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

  Future<List<Leaves>>? _cutiFuture;
  Future? _cutiDays;
  Future? _cutiYearlyDays;

  Future<void> refreshData() async {
    String jenisCuti = "";

    switch (activeIndex) {
      case 0:
        jenisCuti = "2";
        break;
      case 1:
        jenisCuti = "3";
        break;
      case 2:
        jenisCuti = "1";
        break;
    }

    setState(() {
      isLoading = true;
      int userIdnya = preferences?.getInt('user_id') ?? 0;
      String userId = userIdnya.toString();
      _cutiFuture = fetchAndUpdateCache(userId, jenisCuti);
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> refreshContent() async {
    final DateTime now = DateTime.now();
    final Duration cooldownDuration = Duration(seconds: 10);

    if (_lastRefreshTime != null &&
        now.difference(_lastRefreshTime!) < cooldownDuration) {
      print('Cooldown period. Not refreshing.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please wait a bit before refreshing again.')));
      return;
    }

    print("Refreshing home started");
    await refreshData();

    _cutiDays = getLeaveDays();
    _cutiYearlyDays = getLeaveYearlyDays();
    print('Cuti page refreshed');
    _lastRefreshTime = now;
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + ' ...selengkapnya';
    }
  }

  Widget shimmerLayout() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            3,
            (index) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 7),
                      Container(
                        color: Colors.grey,
                        height: MediaQuery.of(context).size.width * 0.028,
                        width: 80,
                      ),
                      const SizedBox(height: 7),
                      Container(
                        color: Colors.grey,
                        height: 1,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 7),
                      Container(
                        color: Colors.grey,
                        height: MediaQuery.of(context).size.width * 0.044,
                        width: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  late Timer _timer; // Define the timer
  bool _isMounted = false;
  bool _isSnackbarVisible = false;

  @override
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
                padding: const EdgeInsets.all(4.0),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [customIcon],
                          ),
                          const SizedBox(
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
                              const Padding(
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
              ),
              Container(
                width: 5,
                height: 49,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
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
      duration: const Duration(seconds: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
          const Divider(),
          const SizedBox(
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
          const Divider(),
          const SizedBox(
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
        body: RefreshIndicator(
          onRefresh: refreshContent,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.35,
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
                                height:
                                    MediaQuery.of(context).size.width * 0.007,
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
                                    "Kalender Cuti",
                                    style: GoogleFonts.getFont('Montserrat',
                                        textStyle: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.055,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Text(
                                      "Kalender cuti dan riwayat cuti",
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
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Text(
                                      "Ajukan cuti jika berkenan",
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
                            "assets/img/calendar-cuti.svg",
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: FutureBuilder(
                        future: _cutiDays,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return shimmerLayout();
                          } else if (snapshot.hasData) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // CONTAINER START
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(width: 1, color: kTextoo),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 1,
                                          offset: const Offset(0, 1),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                "Tahunan",
                                                style: GoogleFonts.getFont(
                                                    'Montserrat',
                                                    textStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.028,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kTextoo)),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              const Divider(
                                                color: kTextoo,
                                                thickness: 1,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text(
                                                    snapshot.data['data']
                                                            ['yearly']
                                                        .toString(),
                                                    style: GoogleFonts.getFont(
                                                        'Montserrat',
                                                        textStyle: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.044,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: kTextoo)),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text(
                                                    "/12",
                                                    style: GoogleFonts.getFont(
                                                        'Montserrat',
                                                        textStyle: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.028,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: kTextoo)),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 7.0,
                                ),

                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(width: 1, color: kTextoo),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 1,
                                          offset: const Offset(0, 1),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                "Khusus",
                                                style: GoogleFonts.getFont(
                                                    'Montserrat',
                                                    textStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.028,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kTextoo)),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              const Divider(
                                                color: kTextoo,
                                                thickness: 1,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                snapshot.data['data']
                                                        ['exclusive']
                                                    .toString(),
                                                style: GoogleFonts.getFont(
                                                    'Montserrat',
                                                    textStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.044,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kTextoo)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 7.0,
                                ),

                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(width: 1, color: kTextoo),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 1,
                                          offset: const Offset(0, 1),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                "Darurat",
                                                style: GoogleFonts.getFont(
                                                    'Montserrat',
                                                    textStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.028,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kTextoo)),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              const Divider(
                                                color: kTextoo,
                                                thickness: 1,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                snapshot.data['data']
                                                        ['emergency']
                                                    .toString(),
                                                style: GoogleFonts.getFont(
                                                    'Montserrat',
                                                    textStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.044,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kTextoo)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return shimmerLayout(); 
                          }
                        },
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          TableCalendar(
                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, date, _) {
                                print('Processing date: $date');
                                final formattedDate =
                                    DateTime(date.year, date.month, date.day);
                                final eventType = leaveDays[formattedDate];

                                TextStyle textStyle;
                                Color cellColor = Colors.transparent;
                                // ignore: unused_local_variable
                                Color fontColor;
                                // ignore: unused_local_variable
                                FontWeight tebal;

                                switch (eventType) {
                                  case 'yearly':
                                    textStyle = GoogleFonts.montserrat(
                                        color: kTextBlocker,
                                        fontSize: 10,
                                        fontWeight: tebal = FontWeight.bold);
                                    cellColor = Colors.transparent;
                                    fontColor = kGreen;
                                    break;
                                  case 'exclusive':
                                    textStyle = GoogleFonts.montserrat(
                                        color: kTextoo,
                                        fontSize: 10,
                                        fontWeight: tebal = FontWeight.bold);
                                    cellColor = Colors.transparent;
                                    fontColor = kTextoo;
                                    break;
                                  case 'emergency':
                                    textStyle = GoogleFonts.montserrat(
                                        color: kTextOren,
                                        fontSize: 10,
                                        fontWeight: tebal = FontWeight.bold);
                                    fontColor =
                                        Color.fromARGB(255, 239, 218, 25);
                                    break;
                                  case 'national':
                                    textStyle = GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: tebal = FontWeight.bold);
                                    cellColor = kTextBlocker;
                                    break;
                                  default:
                                    textStyle = GoogleFonts.getFont(
                                      'Montserrat',
                                      textStyle: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                    break;
                                }

                                return Center(
                                  child: Container(
                                    padding: EdgeInsets.all(2.2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: cellColor,
                                    ),
                                    child: Text(
                                      '${date.day}',
                                      style: textStyle,
                                    ),
                                  ),
                                );
                              },
                            ),
                            rowHeight: 25,
                            focusedDay: today,
                            headerStyle: HeaderStyle(
                              leftChevronIcon: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: kTextoo,
                                size: 10.0,
                              ),
                              leftChevronMargin:
                                  const EdgeInsets.only(right: 30.0),
                              rightChevronIcon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: kTextoo,
                                size: 10.0,
                              ),
                              rightChevronMargin:
                                  const EdgeInsets.only(left: 30.0),
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: GoogleFonts.getFont('Montserrat',
                                  textStyle: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: kTextBlcknw)),
                            ),
                            firstDay: DateTime(DateTime.now().year, 1, 1),
                            lastDay: DateTime(DateTime.now().year, 12, 31),
                            calendarStyle: CalendarStyle(
                              outsideTextStyle: GoogleFonts.montserrat(
                                  fontSize: 10, color: Colors.grey),
                              todayTextStyle: GoogleFonts.getFont('Montserrat',
                                  fontSize: 10, color: Colors.white),
                              todayDecoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: kTextoo),
                              tablePadding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              cellMargin: const EdgeInsets.all(4),
                              weekendTextStyle: GoogleFonts.getFont(
                                  'Montserrat',
                                  textStyle: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(244, 67, 54, 1))),
                              defaultTextStyle: GoogleFonts.getFont(
                                  'Montserrat',
                                  textStyle: const TextStyle(
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
                                  color:
                                      const Color.fromARGB(255, 249, 249, 249),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Cuti",
                                      style: GoogleFonts.getFont('Montserrat',
                                          fontSize: 10.0,
                                          color: kTextUnselected,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          "Tahunan",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              fontSize: 10.0,
                                              color: kGreen,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          width: 25.0,
                                        ),
                                        Text(
                                          "Khusus",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              fontSize: 10.0,
                                              color: kTextoo,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          width: 25.0,
                                        ),
                                        Text(
                                          "Darurat",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              fontSize: 10.0,
                                              color: Color.fromARGB(
                                                  255, 239, 218, 25),
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
                  const SizedBox(
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
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total",
                            style: GoogleFonts.getFont('Montserrat',
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "Cuti",
                            style: GoogleFonts.getFont('Montserrat',
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: kTextoo)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Cuti khusus, darurat, tahunan",
                        style: GoogleFonts.getFont('Montserrat',
                            textStyle: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: kTextBlcknw)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 2.0,
                      child: FutureBuilder(
                        future: _cutiFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                spreadRadius: 0,
                                                blurRadius: 4,
                                                offset: const Offset(0, 1))
                                          ],
                                        ),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    8.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    8.0))),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width:
                                                            60, 
                                                        height: 10.0,
                                                        color: Colors.grey[300],
                                                      ),
                                                      const Spacer(),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width:
                                                                50, 
                                                            height: 10.0,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                          const SizedBox(
                                                              width: 5.0),
                                                          Container(
                                                            width:
                                                                5, 
                                                            height: 10.0,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                          const SizedBox(
                                                              width: 5.0),
                                                          Container(
                                                            width:
                                                                50, 
                                                            height: 10.0,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8.0)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 15.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width:
                                                            40, 
                                                        height: 10.0,
                                                        color: Colors.grey[300],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Container(
                                                        width: double
                                                            .infinity, 
                                                        height: 10.0,
                                                        color: Colors.grey[300],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Container(
                                                        width: double
                                                            .infinity, 
                                                        height: 10.0,
                                                        color: Colors.grey[300],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                            );
                          } else if (snapshot.hasData) {
                            if (snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              return Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.08,
                                  ),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/img/EMPTY.svg",
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Cuti Kosong",
                                        style: GoogleFonts.getFont('Montserrat',
                                            textStyle: TextStyle(
                                                color: kTextBlcknw,
                                                fontWeight: FontWeight.w600,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.044)),
                                      ),
                                    ],
                                  ));
                            }
                            return ListView.builder(
                                padding: const EdgeInsets.only(top: 4),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final itemData = snapshot.data![index];
                                  print(snapshot.data);
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                              builder: (context) => DetailCuti(
                                                    absen: itemData,
                                                  )),
                                        )
                                            .then((result) {
                                          if (result == 'refresh') {
                                            refreshData(); // Call your refresh logic
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                spreadRadius: 0,
                                                blurRadius: 4,
                                                offset: const Offset(0, 1))
                                          ]),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 40.0,
                                                decoration: const BoxDecoration(
                                                    color: kTextoo,
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    8.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    8.0))),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "${itemData.status![0].toUpperCase()}${itemData.status!.substring(1).toLowerCase()}",
                                                        style:
                                                            GoogleFonts.getFont(
                                                                'Montserrat',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                      const Spacer(),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            DateFormat(
                                                                    'dd MMMM yyyy')
                                                                .format(DateTime
                                                                    .parse(itemData
                                                                            .startDate ??
                                                                        '2006-03-03')),
                                                            style: GoogleFonts.getFont(
                                                                'Montserrat',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          const SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Text(
                                                            "-",
                                                            style: GoogleFonts.getFont(
                                                                'Montserrat',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          const SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                                    'dd MMMM yyyy')
                                                                .format(DateTime
                                                                    .parse(itemData
                                                                            .endDate ??
                                                                        '2006-03-03')),
                                                            style: GoogleFonts.getFont(
                                                                'Montserrat',
                                                                color: Colors
                                                                    .white,
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
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8.0)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 15.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Alasan",
                                                        style:
                                                            GoogleFonts.getFont(
                                                                'Montserrat',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      const SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        truncateText(
                                                            itemData.descriptionLeave ??
                                                                'Unknown',
                                                            60),
                                                        maxLines: 2,
                                                        style:
                                                            GoogleFonts.getFont(
                                                                'Montserrat',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                });
                          } else if (snapshot.hasError) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                spreadRadius: 0,
                                                blurRadius: 4,
                                                offset: const Offset(0, 1))
                                          ],
                                        ),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    8.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    8.0))),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width:
                                                            60, 
                                                        height: 10.0,
                                                        color: Colors.grey[300],
                                                      ),
                                                      const Spacer(),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width:
                                                                50, 
                                                            height: 10.0,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                          const SizedBox(
                                                              width: 5.0),
                                                          Container(
                                                            width:
                                                                5, 
                                                            height: 10.0,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                          const SizedBox(
                                                              width: 5.0),
                                                          Container(
                                                            width:
                                                                50, 
                                                            height: 10.0,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8.0)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 15.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width:
                                                            40,
                                                        height: 10.0,
                                                        color: Colors.grey[300],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Container(
                                                        width: double
                                                            .infinity, 
                                                        height: 10.0,
                                                        color: Colors.grey[300],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Container(
                                                        width: double
                                                            .infinity,
                                                        height: 10.0,
                                                        color: Colors.grey[300],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                            );
                          } else {
                            return Container(
                                margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/img/EMPTY.svg",
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Cuti Kosong",
                                      style: GoogleFonts.getFont('Montserrat',
                                          textStyle: TextStyle(
                                              color: kTextBlcknw,
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.044)),
                                    ),
                                  ],
                                ));
                          }
                        },
                      )),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: isButtonVisible
            ? FutureBuilder<List>(
                // Wait for both futures to complete
                future: Future.wait(
                    [getProfil(), _cutiYearlyDays ?? Future.value(null)]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Assuming getProfil returns a map and _cutiYearlyDays returns a single value or another map
                    final profileData = snapshot.data![0]['data']?.first;
                    final yearlyDaysData = snapshot.data![1];

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
                            onPressed: () async {
                              var responseStatus = await checkAbsensi();
                                if (responseStatus == 'Leave') {
                                // ignore: unused_local_variable
                                final snackBar = showSnackbarWarning(
                                    "Kamu sedang cuti",
                                    "Tunggu masa cutimu habis untuk mengajukan lagi!",
                                    kYelw,
                                    const Icon(
                                      LucideIcons.alertCircle,
                                      size: 26.0,
                                      color: kYelw,
                                    ));
                                }else{
                                   Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateCuti(
                                      profile: profileData,
                                      yearly: yearlyDaysData,
                                    ),
                                  ));
                                }
                            },
                            child: const Icon(Icons.add),
                            backgroundColor: kTextooAgakGelap,
                            elevation: 0,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      color: Colors.transparent,
                    );
                  }
                },
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
