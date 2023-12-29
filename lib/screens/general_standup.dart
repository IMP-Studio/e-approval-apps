import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
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
import 'package:imp_approval/models/standup_model.dart';

class GeneralStandUp extends StatefulWidget {
  const GeneralStandUp({super.key});

  @override
  State<GeneralStandUp> createState() => _GeneralStandUpState();
}

class _GeneralStandUpState extends State<GeneralStandUp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  DateTime? _lastRefreshTime;

  Future<void> _refreshStandUp() async {
    final DateTime now = DateTime.now();
    final Duration cooldownDuration = Duration(seconds: 30); // Adjust as needed

    if (_lastRefreshTime != null &&
        now.difference(_lastRefreshTime!) < cooldownDuration) {
      print('Cooldown period. Not refreshing StandUp.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please wait a bit before refreshing StandUp again.')));
      return;
    }

    print("Refreshing StandUp started");

    setState(() {
      _refreshContent();
    });

    print('StandUp page refreshed');
    _lastRefreshTime = now; // update the last refresh time
  }

  String _searchQuery = "";

  late TabController _tabController;
  int activeIndex = 0;
  bool isButtonVisible = true;
  Future<List<StandUps>>? _standUpData;

  List<dynamic> filterData(List<dynamic> data, String query) {
    return data.where((item) {
      final title = item.project ?? '';
      final name = item.namaLengkap ?? '';

      final status = item.blocker != null ? "blocker" : "done";

      bool matchesQuery = title.toLowerCase().contains(query.toLowerCase()) ||
          name.toLowerCase().contains(query.toLowerCase());

      if (query.toLowerCase() == "blocker" || query.toLowerCase() == "done") {
        return status == query.toLowerCase();
      }

      return matchesQuery;
    }).toList();
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _timer = Timer(Duration.zero, () {});
    _tabController = TabController(length: 2, vsync: this);
    getUserData().then((_) {
      int userIdnya = preferences?.getInt('user_id') ?? 0;
      String userId = userIdnya.toString();
      String scope = 'year';
      _standUpData = fetchAndUpdateCache(
          userId, scope); // asumsikan Anda memiliki userId dan scope
      print(preferences?.getInt('user_id'));
    });
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

  Future<List<dynamic>> getStandUpUser({String? filter}) async {
    int userId = preferences?.getInt('user_id') ?? 0;
    final String baseUrl =
        'https://admin.approval.impstudio.id/api/standup?id=$userId&scope=year';

    print("Fetching data from URL: $baseUrl");

    var response = await http.get(Uri.parse(baseUrl));
    print(response.body);
    var jsonData = jsonDecode(response.body);
    var allData = jsonData['data'] ?? [];

    print("Data from server: ${allData.length}");

    if (filter != null && filter.isNotEmpty) {
      return filterData(allData, filter);
    } else {
      return allData;
    }
  }

  Future<void> _refreshContent() async {
    int userIdnya = preferences?.getInt('user_id') ?? 0;
    String userId = userIdnya.toString();
    String scope = 'year';

    setState(() {
      _standUpData = fetchAndUpdateCache(userId, scope);
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: _refreshStandUp,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
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
                                    "GENERAL STAND UP",
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
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
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
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SvgPicture.asset(
                            "assets/img/general-standup.svg",
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
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            // height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 1)),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: TextField(
                                      style: GoogleFonts.montserrat(
                                          color: kTextBlcknw,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.034),
                                      onChanged: (text) {
                                        setState(() {
                                          _searchQuery = text;
                                          _refreshContent();
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Cari Project...",
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.montserrat(
                                            color: kTextBlcknw,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.034),
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  flex: 2,
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.blue,
                                    size: 30.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FutureBuilder<List<dynamic>>(
                          future: _standUpData,
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
                                      padding: const EdgeInsets.only(
                                          right: 20, left: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            width: double.infinity,
                                            height: 95,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: const Color(
                                                            0xffC2C2C2)
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
                                                            const SizedBox(
                                                              height: 3,
                                                            ),
                                                            Container(
                                                              width:
                                                                  100, // Arbitrary width
                                                              height: 8.0,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                            const SizedBox(
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
                                                        const Spacer(),
                                                        const VerticalDivider(
                                                          color:
                                                              Color(0xffE6E6E6),
                                                          thickness: 1,
                                                        ),
                                                        const Spacer(),
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
                                                            const SizedBox(
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
                                                const Spacer(),
                                                Container(
                                                  color: const Color(0xffD9D9D9)
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
                                                            const SizedBox(
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
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 7,
                                      itemBuilder: (context, index) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20, left: 20),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 15),
                                                  width: double.infinity,
                                                  height: 95,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: const Color(
                                                                  0xffC2C2C2)
                                                              .withOpacity(
                                                                  0.30))),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IntrinsicHeight(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 15,
                                                                        bottom:
                                                                            7,
                                                                        right:
                                                                            5),
                                                                    child:
                                                                        Container(
                                                                      width: 20,
                                                                      color: Colors
                                                                              .grey[
                                                                          300],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                        100, // Arbitrary width
                                                                    height: 8.0,
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                        50, // Arbitrary width
                                                                    height: 8.0,
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                  ),
                                                                ],
                                                              ),
                                                              const Spacer(),
                                                              const VerticalDivider(
                                                                color: Color(
                                                                    0xffE6E6E6),
                                                                thickness: 1,
                                                              ),
                                                              const Spacer(),
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
                                                                            .grey[
                                                                        300],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                        30, // Arbitrary width
                                                                    height: 8.0,
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Container(
                                                        color: const Color(
                                                                0xffD9D9D9)
                                                            .withOpacity(0.15),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width:
                                                                        40, // Arbitrary width
                                                                    height: 8.0,
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                        60, // Arbitrary width
                                                                    height: 8.0,
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
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
                                    )
                                  ],
                                ),
                              );
                            } else if (!snapshot.hasData ||
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
                                        "Stand Up Kosong",
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
                            } else {
                              List<dynamic> allData = snapshot.data!;
                              List<dynamic> filteredData =
                                  filterData(allData, _searchQuery);
                              if (filteredData.isEmpty) {
                                return Center(
                                    child: Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: SvgPicture.asset(
                                    "assets/img/404.svg",
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                    fit: BoxFit.cover,
                                  ),
                                ));
                              }
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!
                                    .length, // Menentukan jumlah total item
                                itemBuilder: (BuildContext context, int index) {
                                  final itemData = snapshot.data![index];

                                  return GestureDetector(
                                    onTap: () {
                                      if (currentUser == itemData.userId) {
                                        // If the current user is the owner of the data, navigate to EditScreen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditStandUp(
                                                  standup: itemData)),
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
                                              builder: (context) =>
                                                  DetailStandUp(
                                                      standup: itemData)),
                                        );
                                      }
                                    },
                                    // Sisanya sama seperti kode asli Anda...
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 22.0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: itemData
                                                                  .blocker ==
                                                              null
                                                          ? [
                                                              const Color(
                                                                  0xff4381CA),
                                                              const Color(
                                                                  0xff4381CA)
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
                                              margin: const EdgeInsets.only(
                                                  left: 12.0),
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
                                                      color:
                                                          kTextUnselectedOpa),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10.0))),
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
                                                          color:
                                                              kTextUnselectedd,
                                                          size: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.044,
                                                        ),
                                                        const SizedBox(
                                                            width: 5.0),
                                                        Text(
                                                          itemData.namaLengkap ??
                                                              'lah',
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
                                                              gradient: const LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment.bottomCenter,
                                                                  colors: [
                                                                    kTextoo,
                                                                    kTextoo
                                                                  ]),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2.0)),
                                                        ),
                                                        const SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        itemData.blocker == null
                                                            ? Text(
                                                                "Done",
                                                                style: GoogleFonts.getFont(
                                                                    'Montserrat',
                                                                    textStyle: TextStyle(
                                                                        color:
                                                                            kTextUnselected,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.028)),
                                                              )
                                                            : Text(
                                                                "Blocker",
                                                                style: GoogleFonts.getFont(
                                                                    'Montserrat',
                                                                    textStyle: TextStyle(
                                                                        color:
                                                                            kTextUnselected,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.028)),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0,
                                                            left: 12.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 200,
                                                            height: 15,
                                                            child: Text(
                                                              itemData.project ??
                                                                  'coy',
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
                                                  const Spacer(),
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
                                                            const SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            Text(
                                                              itemData.jam ??
                                                                  'cok',
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
                                                        const Spacer(),
                                                        Text(
                                                          DateFormat('dd MMM')
                                                              .format(itemData
                                                                          .createdAt !=
                                                                      null
                                                                  ? DateTime.parse(
                                                                      itemData
                                                                          .createdAt!)
                                                                  : DateTime
                                                                      .now()),
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
                                },
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
        ));
  }
}
