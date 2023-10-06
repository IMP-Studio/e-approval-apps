import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/detail/detail_absensi.dart';
import 'package:imp_approval/screens/detail/detail_bolos.dart';
import 'package:imp_approval/screens/detail/detail_resume_history.dart';
import 'package:imp_approval/screens/detail/detail_wfo.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/screens/detail/detail_request_cuti.dart';
import 'package:imp_approval/screens/detail/detail_request_perjadin.dart';
import 'package:imp_approval/screens/detail/detail_request_wfa.dart';
import 'package:shimmer/shimmer.dart';
import 'package:imp_approval/screens/detail/detail_cuti.dart';
import 'package:imp_approval/screens/detail/detail_perjadin.dart';
import 'package:imp_approval/screens/detail/detail_wfa.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class HistoryAttendance extends StatefulWidget {
  const HistoryAttendance({super.key});

  @override
  State<HistoryAttendance> createState() => _HistoryAttendanceState();
}

class _HistoryAttendanceState extends State<HistoryAttendance>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  SharedPreferences? preferences;
  int activeIndex = 0;
  late TabController _tabController;
  DateTime date = DateTime.now();
  bool isButtonVisible = true;

  DateTime? startDate;
  DateTime? endDate;
  String? type;

  Future? _dataFuture;

  onStartDateSelected(DateTime date) {
    setState(() {
      startDate = date;
    });
  }

  onEndDateSelected(DateTime date) {
    setState(() {
      endDate = date;
    });
  }

  void onActiveIndexChanged(int activeIndex) {
    String selectedType;
    switch (activeIndex) {
      case 0:
        selectedType = 'WFO,telework,work_trip,skip,leave';
        break;
      case 1:
        selectedType = 'telework';
        break;
      case 2:
        selectedType = 'work_trip';
        break;
      default:
        selectedType = ''; // or whatever default you'd like
    }
    onTypeSelected(selectedType);
  }

  onTypeSelected(String selectedType) {
    setState(() {
      type = selectedType;
    });
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return ''; // handle null datetime if necessary
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  bool isLoading = false;

  Future<bool> getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
    return true; // Indicate that user data was fetched successfully.
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

  String formatDateRange(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    String formattedStartDay = DateFormat('d').format(start);
    String formattedEndDay = DateFormat('d').format(end);
    String formattedMonth =
        DateFormat('MMMM').format(start); // e.g., "November"
    String formattedYear = DateFormat('y').format(start); // e.g., "2023"

    return '$formattedStartDay-$formattedEndDay $formattedMonth $formattedYear';
  }

  Future getAbsensiAll(
      {DateTime? startDate, DateTime? endDate, int? activeIndex}) async {
    int userId = preferences?.getInt('user_id') ?? 0;

    // Determine type based on activeIndex
    String? _type;
    switch (activeIndex) {
      case 1:
        _type = 'WFA';
        break;
      case 2:
        _type = 'PERJADIN';
        break;
      case 0:
      default:
        _type = '';
        break;
    }

    String urlj =
        'https://testing.impstudio.id/approvall/api/presence?id=$userId&status=allowed,pending,rejected&scope=self';

    // Check if either startDate or endDate is provided and handle accordingly
    if (startDate != null || endDate != null) {
      DateTime _startDate = startDate ?? DateTime.now();
      DateTime _endDate = endDate ?? DateTime.now();
      urlj += '&start_date=${formatDate(_startDate)}';
      urlj += '&end_date=${formatDate(_endDate)}';
    }

    if (_type != null) {
      urlj += '&type=$_type';
    }

    var response = await http.get(Uri.parse(urlj));
    print("Constructed URL: $urlj");

    print(response.body);
    return jsonDecode(response.body);
  }

  Future<void> _refreshContent(
      {DateTime? startDate, DateTime? endDate, int? activeIndex}) async {
    print(
        "Filter NYA BISA GA YAAAAA: $startDate to $endDate and index: $activeIndex");

    setState(() {
      _dataFuture = getAbsensiAll(
          startDate: startDate, // Passing as it is, can be null or has a value.
          endDate: endDate, // Passing as it is, can be null or has a value.
          activeIndex:
              activeIndex // Passing activeIndex to determine the type within getAbsensiAll
          );
    });
  }

  void startTimer() {
    // Start a timer to hide the button after 4 seconds of inactivity
    Duration duration = const Duration(seconds: 4);
    Future.delayed(duration, hideButton);
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      _refreshContent(activeIndex: _tabController.index);
    });

    // Adjusted sequence
    getUserData().then((success) {
      if (success) {
        _dataFuture = getAbsensiAll();
        _refreshContent();
        startTimer();
      }
    });
  }

  String calculateTotalHours(String entryTime, String exitTime) {
    if (entryTime == '00:00:00' || exitTime == '00:00:00') {
      return 'Ongoing';
    }

    try {
      DateTime entry = DateTime.parse('2023-01-01 ' + entryTime);
      DateTime exit = DateTime.parse('2023-01-01 ' + exitTime);

      Duration difference = exit.difference(entry);
      return '${difference.inHours.toString().padLeft(2, '0')}:${(difference.inMinutes % 60).toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Error';
    }
  }

  void onApplyFilter(DateTime? startDate, DateTime? endDate, int activeIndex) {
    print("onApplyFilter called!");
    _refreshContent(
        startDate: startDate, endDate: endDate, activeIndex: activeIndex);
  }

  String formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return '-- : --';
    }

    try {
      List<String> parts = dateTimeStr.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      String period = hour >= 12 ? 'PM' : 'AM';

      if (hour > 12) hour -= 12;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return '-- : --';
    }
  }

  String formatTime(String? dateTimeStr) {
    if (dateTimeStr == null) {
      return '-- : --';
    }

    try {
      DateTime parsedDateTime = DateTime.parse(dateTimeStr);
      return DateFormat('hh').format(parsedDateTime);
    } catch (e) {
      return '-- : --';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String statusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'allow_HT':
        return 'Diterima oleh';
      case 'allowed':
        return 'Diterima oleh';
      case 'rejected':
        return 'Ditolak oleh';
      default:
        return '';
    }
  }

  String categoryText(String? category) {
    switch (category) {
      case 'WFO':
        return 'Work From Office';
      case 'telework':
        return 'Work From Anywhere';
      case 'work_trip':
        return 'Perjalanan Dinas';
      case 'leave':
        return 'Cuti';
      case 'skip':
        return 'Cuti';
      default:
        return 'Unknown';
    }
  }

  String permissionText(String? status, String category, [String? rejector]) {
    if (category == 'wfo') return 'HR';

    switch (status) {
      case 'pending':
        return 'HT';
      case 'allow_HT':
        return 'HT';
      case 'allowed':
        return 'HT & HR';
      case 'rejected':
        return rejector ?? '';
      default:
        return 'HT & HR';
    }
  }

  void _showDatePickerModal() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return DatePickerModal(
          onDateSelected: (selectedDate) {
            print("Selected date: $selectedDate");
          },
          onApplyFilter: onApplyFilter, // Changed here
          tabController: _tabController,
        );
      },
    );
  }

  Widget _jadwalContainer() {
    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                FutureBuilder(
                    future: _dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 7,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
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
                                          width: double.infinity,
                                          height: 95,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: const Color(0xffC2C2C2)
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
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Column(
                          children: [
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 7,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
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
                                          width: double.infinity,
                                          height: 95,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: const Color(0xffC2C2C2)
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
                            )
                          ],
                        );
                      } else {
                        if (snapshot.hasData) {
                          if (snapshot.data?['data'] == null ||
                              snapshot.data['data'].isEmpty) {
                            // Return an Image or placeholder here
                            return Center(
                              child: Container(
                                color: Colors.white,
                              ),
                            );
                          }

                          var limitedData = snapshot.data['data'].toList();
                          return ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: limitedData.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                print(snapshot.data['data']);
                                print(limitedData[index]['entry_time']);
                                print(
                                    snapshot.data['data'][index]['entry_time']);
                                return GestureDetector(
                                  onTap: () {
                                    String category = snapshot.data['data']
                                            [index][
                                        'category']; // Assuming your data has a 'category' key.

                                    Widget detailPage;

                                    switch (category) {
                                      case 'WFO':
                                        detailPage = DetailWfo(
                                            absen: snapshot.data['data']
                                                [index]);
                                        break;
                                      case 'telework':
                                        detailPage = DetailWfa(
                                            absen: snapshot.data['data']
                                                [index]);
                                        break;
                                      case 'work_trip':
                                        detailPage = DetailPerjadin(
                                            absen: snapshot.data['data']
                                                [index]);
                                        break;
                                      case 'leave':
                                        detailPage = DetailCuti(
                                            absen: snapshot.data['data']
                                                [index]);
                                        break;
                                      case 'skip':
                                        detailPage = DetailBolos(
                                            absen: snapshot.data['data']
                                                [index]);
                                        break;
                                      default:
                                        detailPage = DetailAbsensi(
                                            absen: snapshot.data['data']
                                                [index]);
                                        break;
                                    }

                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                          builder: (context) => detailPage),
                                    )
                                        .then((result) {
                                      if (result == 'refresh') {
                                        _refreshContent();
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 95,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: const Color(0xffC2C2C2)
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
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10),
                                                              height: 2,
                                                              width: 20,
                                                              color: blueText,
                                                            ),
                                                          ),
                                                          Text(
                                                            snapshot.data['data'][index]['category'] ==
                                                                    'leave'
                                                                ? formatDateRange(
                                                                    snapshot.data['data']
                                                                            [index]
                                                                        [
                                                                        'start_date'],
                                                                    snapshot.data['data']
                                                                            [index]
                                                                        [
                                                                        'end_date'])
                                                                : DateFormat(
                                                                        'dd MMMM yyyy')
                                                                    .format(DateTime.parse(
                                                                            snapshot.data['data'][index]['date']) ??
                                                                        DateTime.now()),
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 10,
                                                              color: blueText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                  calculateTotalHours(
                                                                      snapshot.data['data']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'entry_time'],
                                                                      snapshot.data['data']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'exit_time']),
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  )),
                                                              Text(
                                                                  ' Total hours',
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  )),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: VerticalDivider(
                                                          color:
                                                              Color(0xffE6E6E6),
                                                          thickness: 1,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 15,
                                                              bottom: 7,
                                                              left: 5,
                                                            ),
                                                            child: Container(
                                                              height: 2,
                                                              width: 20,
                                                              color: blueText,
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                        'Check in',
                                                                        style: GoogleFonts
                                                                            .montserrat(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              blueText,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        )),
                                                                    const SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Text(
                                                                        formatDateTime(snapshot.data['data'][index]
                                                                            [
                                                                            'entry_time']),
                                                                        style: GoogleFonts
                                                                            .montserrat(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        )),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                        'Check out',
                                                                        style: GoogleFonts
                                                                            .montserrat(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              blueText,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        )),
                                                                    const SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Text(
                                                                        formatDateTime(snapshot.data['data'][index]
                                                                            [
                                                                            'exit_time']),
                                                                        style: GoogleFonts
                                                                            .montserrat(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        )),
                                                                  ],
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
                                              const Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color(0xffD9D9D9)
                                                      .withOpacity(0.15),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 10,
                                                    top: 10,
                                                    right: 10,
                                                    left: 10,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            categoryText(snapshot
                                                                        .data[
                                                                    'data'][index]
                                                                ['category']),
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 8,
                                                              color: const Color(
                                                                  0xffB6B6B6),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            statusText(snapshot
                                                                        .data[
                                                                    'data'][index]
                                                                ['status']),
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 8,
                                                              color: const Color(
                                                                  0xffB6B6B6),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            permissionText(
                                                                snapshot.data[
                                                                            'data']
                                                                        [index]
                                                                    ['status'],
                                                                snapshot.data[
                                                                            'data']
                                                                        [index][
                                                                    'category'],
                                                                snapshot.data[
                                                                            'data']
                                                                        [index][
                                                                    'someKey']),
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 8,
                                                              color: const Color(
                                                                  0xffB6B6B6),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
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
                              });
                        } else {
                          return Column(
                            children: [
                              ListView.builder(
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
                              )
                            ],
                          );
                        }
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          showButton();
          startTimer();
        },
        onVerticalDragUpdate: (details) {
          showButton();
          startTimer();
        },
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshContent,
            child: ListView(
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
                                  "Riwayat Absensi",
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    "Work From Anywhere, Pekerjaan Dinas, Work From Office",
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
                          "assets/img/hero-image-ha.svg",
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.3,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailHistoryResume(),
                              ));
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: 140.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: kTextoo,
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    color: Colors.black.withOpacity(0.25),
                                    offset: Offset(0, 2))
                              ]),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Lihat Resume",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.034,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 45,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: kTextooAgakGelap,
                                    borderRadius: BorderRadius.circular(25.0)),
                                child: Icon(
                                  LucideIcons.clipboard,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.width * 0.054,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _jadwalContainer(),
                const SizedBox(
                  height: 10,
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
                  width: 110.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                      color: kTextoo,
                      borderRadius: BorderRadius.circular(25.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Filter",
                      style: GoogleFonts.getFont('Montserrat',
                          color: Colors.white,
                          fontSize: 14,
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
                      heroTag: 'next1',
                      onPressed: _showDatePickerModal,
                      child: const Icon(LucideIcons.slidersHorizontal),
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
    );
  }
}

class DatePickerModal extends StatefulWidget {
  final Function(DateTime?, DateTime?, int) onApplyFilter;
  final Function(DateTime) onDateSelected;
  final TabController tabController;

  DatePickerModal({
    required this.onApplyFilter,
    required this.onDateSelected,
    required this.tabController,
  });

  @override
  _DatePickerModalState createState() => _DatePickerModalState();
}

class _DatePickerModalState extends State<DatePickerModal> {
  DateTime? selectedDate1;
  DateTime? selectedDate2;

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
      child: SizedBox(
        // height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 10),
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8.0)),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.width * 0.012,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Search",
                  style: GoogleFonts.getFont(
                    'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * 0.055,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.012,
                ),
                Text(
                  "Filter",
                  style: GoogleFonts.getFont(
                    'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * 0.055,
                    color: kTextoo,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date",
                          style: GoogleFonts.getFont('Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: kBlck),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.02,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: kBlck,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        _showDatePicker(selectedButton: 1);
                      },
                      child: Row(
                        children: [
                          Text(
                            _getButtonText(selectedDate1),
                            style: GoogleFonts.getFont('Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.028,
                                color: kBlck),
                          ),
                          const Spacer(),
                          const Icon(
                            LucideIcons.calendarDays,
                            color: kTextoo,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "End Date",
                          style: GoogleFonts.getFont('Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: kBlck),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.02,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: kBlck,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        _showDatePicker(selectedButton: 2);
                      },
                      child: Row(
                        children: [
                          Text(_getButtonText(selectedDate2),
                              style: GoogleFonts.getFont('Montserrat',
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.028,
                                  color: kBlck)),
                          const Spacer(),
                          const Icon(
                            LucideIcons.calendarDays,
                            color: kTextoo,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.015,
                    ),
                    Container(
                      child: IndexedStack(
                        index: widget.tabController.index,
                        children: [buildContent()],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.04,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kTextoo,
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.035,
                          horizontal: 20,
                        ),
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: kTextoo,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () {
                        print("Selected Start Date: $selectedDate1");
                        print("Selected End Date: $selectedDate2");
                        print("Active Index: $activeIndex");

                        Navigator.pop(context); // Close the modal first

                        widget.onApplyFilter(selectedDate1, selectedDate2,
                            activeIndex); // Then inform the parent
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Apply Filter',
                            style: GoogleFonts.getFont('Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.044,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.033,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.035,
                          horizontal: 20,
                        ),
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: kTextoo,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel',
                            style: GoogleFonts.getFont('Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.044,
                                color: kTextoo),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.79,
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SizedBox(
          //   width: 15.0,
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 0;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.065,
                  vertical: 8),
              decoration: BoxDecoration(
                color: activeIndex == 0 ? kTextoo : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: activeIndex == 0 ? kTextoo : kBlck,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "Semua",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.034,
                      color: activeIndex == 0 ? Colors.white : kBlck,
                      fontWeight:
                          activeIndex == 0 ? FontWeight.w600 : FontWeight.w600),
                ),
              )),
            ),
          ),
          const Divider(),
          // SizedBox(
          //   width: 15.0,
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.065,
                  vertical: 8),
              decoration: BoxDecoration(
                color: activeIndex == 1 ? kTextoo : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: activeIndex == 1 ? kTextoo : kBlck,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "WFA",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.034,
                      color: activeIndex == 1 ? Colors.white : kBlck,
                      fontWeight:
                          activeIndex == 1 ? FontWeight.w600 : FontWeight.w600),
                ),
              )),
            ),
          ),
          const Divider(),
          // SizedBox(
          //   width: 15.0,
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 2;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.065,
                  vertical: 8),
              decoration: BoxDecoration(
                color: activeIndex == 2 ? kTextoo : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: activeIndex == 2 ? kTextoo : kBlck,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "PERJADIN",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.034,
                      color: activeIndex == 2 ? Colors.white : kBlck,
                      fontWeight:
                          activeIndex == 2 ? FontWeight.w600 : FontWeight.w600),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  // void main() {
  //   runApp(HistoryAttendance());
  // }

  Future<void> _showDatePicker({required int selectedButton}) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedButton == 1
          ? selectedDate1 ?? DateTime.now()
          : selectedDate2 ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        if (selectedButton == 1) {
          selectedDate1 = newDate;
        } else if (selectedButton == 2) {
          selectedDate2 = newDate;
        }
      });
      widget.onDateSelected(newDate);
    }
  }

  String _getButtonText(DateTime? selectedDate) {
    return selectedDate != null
        ? DateFormat('y/M/d').format(selectedDate)
        : 'Year/Month/Day';
  }
}
