import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/screens/create/create_perjadin.dart';
import 'package:imp_approval/screens/create/emergency_chekout.dart';
import 'package:imp_approval/screens/detail/detail_absensi.dart';
import 'package:imp_approval/screens/detail/detail_bolos.dart';
import 'package:imp_approval/screens/detail/detail_request_cuti.dart';
import 'package:imp_approval/screens/detail/detail_request_perjadin.dart';
import 'package:imp_approval/screens/detail/detail_request_wfa.dart';
import 'package:imp_approval/screens/detail/detail_wfo.dart';
import 'package:imp_approval/screens/face_recognition.dart';
import 'package:file_picker/file_picker.dart';
import 'package:imp_approval/screens/map_wfo.dart';
import 'package:imp_approval/screens/request.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:imp_approval/main.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shimmer/shimmer.dart';
import 'package:imp_approval/screens/detail/detail_cuti.dart';
import 'package:imp_approval/screens/detail/detail_perjadin.dart';
import 'package:imp_approval/screens/detail/detail_wfa.dart';
import 'package:imp_approval/screens/create/create_wfa.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:ntp/ntp.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum AttendanceStatus {
  loading,
  notAttended,
  checkedIn,
  checkedOut,
  completed,
  pendingStatus,
  Perjadin,
  leaveStatus,
  canReAttend,
  Bolos,
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _isRefreshing = false;

  Future<void> _refreshDataa() async {
    setState(() {
      _isRefreshing = true;
    });

    await refreshData(); // Ensure refreshData completes

    setState(() {
      _isRefreshing = false;
    });
  }

  Future<void> _refreshHome() async {
    print("Refreshing home started"); // Debug line
    await _refreshDataa();
    print('Home page refreshed');
  }

  AttendanceStatus _attendanceStatus = AttendanceStatus.loading;
  bool showCheckin = true;
  bool showAtributModalCheckin = true;

  bool showAtributModalCheckOut = true;

  bool showModalWfa = false;
  String selectedOption = '';
  FilePickerResult? _pickedFile;
  DateTime? _selectedDate;
  DateTime? _selesaiTanggal;
  double _tinggimodal = 320;

  Position? _position;
  late bool servicePermission = false;
  late LocationPermission permission;
  String _currentAddress = "";
  late Timer _timer;

  Future? _absensiAll;
  Future? _absensiToday;

  TimeOfDay? _currentTime = TimeOfDay.now();

  String? _timeStatus;

  final List<String> genderItems = [
    'Kesehatan',
    'Pendidikan',
    'Keluarga',
  ];

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

  Future checkOutToday() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://testing.impstudio.id/approvall/api/presence/checkout?user_id=$userId';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
  }

  Future emergencyChekout() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://testing.impstudio.id/approvall/api/presence/emergency/checkout?user_id=$userId';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
  }

  bool isTimeOfDayBefore(TimeOfDay timeToCheck, TimeOfDay timeToCompare) {
    return (timeToCheck.hour < timeToCompare.hour) ||
        (timeToCheck.hour == timeToCompare.hour &&
            timeToCheck.minute < timeToCompare.minute);
  }

  bool isTimeOfDayAfter(TimeOfDay timeToCheck, TimeOfDay timeToCompare) {
    return (timeToCheck.hour > timeToCompare.hour) ||
        (timeToCheck.hour == timeToCompare.hour &&
            timeToCheck.minute > timeToCompare.minute);
  }

  void _fetchStatusAbsensi() async {
    try {
      String status = await checkAbsensi();

      setState(() {
        switch (status) {
          case 'checkedIn':
            _attendanceStatus = AttendanceStatus.checkedIn;
            break;
          case 'checkedOut':
            _attendanceStatus = AttendanceStatus.checkedOut;
            break;
          case 'completed':
            _attendanceStatus = AttendanceStatus.completed;
            break;
          case 'pendingStatus':
            _attendanceStatus = AttendanceStatus.pendingStatus;
            break;
          case 'Perjadin':
            _attendanceStatus = AttendanceStatus.Perjadin;
            break;
          case 'leaveStatus':
            _attendanceStatus = AttendanceStatus.leaveStatus;
            break;
          case 'canReAttend':
            _attendanceStatus = AttendanceStatus.canReAttend;
            break;
          case 'Bolos':
            _attendanceStatus = AttendanceStatus.Bolos;
            break;
          default:
            _attendanceStatus = AttendanceStatus.notAttended;
            break;
        }
      });
    } catch (error) {
      print('Error fetching attendance status: $error');
      setState(() {
        _attendanceStatus =
            AttendanceStatus.notAttended; // setting a default in case of error
      });
    }
  }

  Widget _buildButtonBasedOnStatus() {
    if (_isRefreshing) {
      return _buildShimmerButton();
    }

    switch (_attendanceStatus) {
      case AttendanceStatus.loading:
        return _buildShimmerButton();
      case AttendanceStatus.notAttended:
        return _buildCheckInButton();
      case AttendanceStatus.pendingStatus:
        return _buildPendingButton();
      case AttendanceStatus.Perjadin:
        return _buildPerjadinButton();
      case AttendanceStatus.leaveStatus:
        return _buildLeaveButton();
      case AttendanceStatus.checkedIn:
        return _buildCheckOutButton();
      case AttendanceStatus.checkedOut:
        return _buildCheckedOutButton();
      case AttendanceStatus.Bolos:
        return _buildBolosButton();
      case AttendanceStatus.completed:
      default:
        return _buildCompletedButton();
    }
  }

  Widget _buildShimmerButton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: const ElevatedButton(
        onPressed: null, // make it un-clickable
        child: Text(". . ."), // Placeholder text, adjust as needed
      ),
    );
  }

  Widget _buildCheckInButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Check In',
        style: GoogleFonts.inter(
          color: whiteText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
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
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.05),
              // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                // height: _tinggimodal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 10),
                      width: 60,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                      ),
                    ),
                    if (showAtributModalCheckin) _modalCheckinAtribut(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        child: Column(
                          children: [
                            if (showCheckin) _modalCheckin(),
                            if (selectedOption == 'WFA') _modalWfa(),
                            if (showModalWfa == 'true') _modalWfa(),
                            if (selectedOption == 'WFO') _modalWfo(),
                            if (selectedOption == 'PERJADIN') _modalPerjadin(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPerjadinButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'PERJADIN',
        style: GoogleFonts.inter(
          color: whiteText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _modalvalidasidarurat(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Berikan alasan mu pulang!",
          style: GoogleFonts.montserrat(
            fontSize: MediaQuery.of(context).size.width * 0.039,
            fontWeight: FontWeight.w600,
          )),
      actions: [
        CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Batal",
                style: GoogleFonts.montserrat(
                  fontSize: MediaQuery.of(context).size.width * 0.039,
                  color: kTextBlocker,
                  fontWeight: FontWeight.w600,
                ))),
        CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context); //tambahkan navipop agar tertutup
            },
            child: Text("Kirim",
                style: GoogleFonts.montserrat(
                  fontSize: MediaQuery.of(context).size.width * 0.039,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ))),
      ],
      content: Column(
        children: [
          const SizedBox(height: 10),
          CupertinoTextField(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            placeholder: 'Ketikkan sesuatu...',
            placeholderStyle: GoogleFonts.montserrat(
              fontSize: MediaQuery.of(context).size.width * 0.039,
              color: kTextgrey,
              fontWeight: FontWeight.w500,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyText, width: 0.5),
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckOutButton() {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: null,
          child: Container(
            width: double.infinity,
            height: 48,
            color: Colors.white,
          ),
        ),
      );
    }


    TimeOfDay morningLimit = const TimeOfDay(hour: 0, minute: 1);
    TimeOfDay eveningLimit = const TimeOfDay(hour: 17, minute: 30);

bool isBeforeEveningLimit = _currentTime != null ? isTimeOfDayBefore(_currentTime!, eveningLimit) : false;
  bool isAfterMorningLimit = isTimeOfDayAfter(_currentTime!, morningLimit);

  bool isButtonEnabled = !(isBeforeEveningLimit && isAfterMorningLimit);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Check Out',
        style: GoogleFonts.inter(
          color: whiteText,
          fontSize: MediaQuery.of(context).size.width * 0.039,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
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
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: _tinggimodal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 10),
                      width: 60,
                      height: 5,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black12,
                      ),
                    ),
                    if (showAtributModalCheckOut)
                      _modalCheckOutAtribut(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                minimumSize: const Size(double.infinity, 45),
                                backgroundColor: kButton,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Emergency(),
                                    ));
                              },
                              child: Text('Darurat',
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.034,
                                    color: whiteText,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                             isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
              ),
            )
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                elevation: isBeforeEveningLimit ? 0 : 3,
                backgroundColor: isBeforeEveningLimit
                    ? Colors.transparent
                    : kButton,
                foregroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                side: BorderSide(
                  width: 1,
                  color: isBeforeEveningLimit ? Colors.black : kButton,
                ),
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: isBeforeEveningLimit && isAfterMorningLimit
                  ? null
                  : () {
                      checkOutToday().then((_) {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainLayout(),
                            ),
                          );
                        });
                      });
                    },
              child: Text(
                "Pulang",
                style: GoogleFonts.montserrat(
                  fontSize: MediaQuery.of(context).size.width * 0.034,
                  color: isBeforeEveningLimit ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
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
          },
        );
      },
    );
  }

  Widget _buildCheckedOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
       backgroundColor: Colors.white,
        shadowColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: Colors.black, width: 1)),
      child: Text(
        'Completed',
        style: GoogleFonts.inter(
          color: hitamText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _buildLeaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: Colors.black, width: 1)),
      child: Text(
        'Cuti',
        style: GoogleFonts.inter(
          color: hitamText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _buildCompletedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: Colors.black, width: 1)),
      child: Text(
        'Unknown',
        style: GoogleFonts.inter(
          color: hitamText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _buildBolosButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Bolos',
        style: GoogleFonts.inter(
          color: whiteText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
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
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: _tinggimodal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 10),
                      width: 60,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                      ),
                    ),
                    if (showAtributModalCheckOut) _modalBolosAttribute(),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            child: SvgPicture.asset(
                              "assets/img/bolos.svg",
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.width * 0.5,
                              fit: BoxFit.cover,
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
      },
    );
  }

  Widget _buildPendingButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Pending',
        style: GoogleFonts.inter(
          color: whiteText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
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
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: _tinggimodal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 10),
                      width: 60,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                      ),
                    ),
                    if (showAtributModalCheckOut) _modalPendingAttribute(),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            child: SvgPicture.asset(
                              "assets/img/pending.svg",
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.width * 0.5,
                              fit: BoxFit.cover,
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
      },
    );
  }

  SharedPreferences? preferences;

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

  Future getProfil() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://testing.impstudio.id/approvall/api/profile?user_id=$userId';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    print(urlj);
    return jsonDecode(response.body);
  }

  Future getAbsensiAll() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://testing.impstudio.id/approvall/api/presence?id=$userId&status=allowed&scope=self';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
  }

  Future getAbsensiToday() async {
    await Future.delayed(const Duration(seconds: 3));
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://testing.impstudio.id/approvall/api/presence/today/$userId';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
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

  String? selectedValue;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    refreshData();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _fetchNTPTime();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showModalWfa == 'true') {
        setState(() {
          _tinggimodal = 420;
        });
      }
    });
  }

  Future<void> _fetchNTPTime() async {
  try {
    DateTime ntpTime = await NTP.now(lookUpAddress: 'id.pool.ntp.org');
    setState(() {
      _currentTime = TimeOfDay(hour: ntpTime.hour, minute: ntpTime.minute);
      isLoading = false;
    });
  } catch (e) {
    print('Failed to fetch NTP time: $e');
    // Handle the error appropriately here, maybe by showing an error message to the user
  }
}


  Future<void> refreshData() async {
    await getUserData().then((_) {
      getProfil();
      print(preferences?.getInt('user_id'));
      print("Description: ${_descriptionController.text}");
      getAbsensiAll();
      checkAbsensi();
      _fetchStatusAbsensi();
      getAbsensiToday();
    });
  }

  Future<void> _selectDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
      });
    }
  }

  Future<void> _selesaiTanggall() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selesaiTanggal ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _selesaiTanggal = newDate;
      });
    }
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

  final TextEditingController _descriptionController = TextEditingController();
  String selectedKeterangan = ''; // Initialize to the appropriate default value

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: _refreshHome,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Column(
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
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
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
                                    "IMP APPROVAL",
                                    style: GoogleFonts.montserrat(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      "Focus and finish what you have started.",
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.044,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                            "assets/img/home-hero.svg",
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                  // jadwal
                  // card baru // bikin shimmer

                  FutureBuilder(
                    future: getAbsensiToday(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While data is still loading, show shimmer effect
                        return Container(
                          padding: const EdgeInsets.only(
                              top: 13, bottom: 13, left: 20, right: 30),
                          width: double.infinity,
                          child: Row(
                            children: [
                              shimmerContainer1(),
                              const Spacer(),
                              shimmerContainer2(),
                              const Spacer(),
                              shimmerContainer3(),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          padding: const EdgeInsets.only(
                              top: 13, bottom: 13, left: 20, right: 30),
                          width: double.infinity,
                          child: Row(
                            children: [
                              shimmerContainer1(),
                              const Spacer(),
                              shimmerContainer2(),
                              const Spacer(),
                              shimmerContainer3(),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        Container(
                          padding: const EdgeInsets.only(
                              top: 13, bottom: 13, left: 20, right: 30),
                          width: double.infinity,
                          // decoration: BoxDecoration(
                          //     border: Border(
                          //   bottom: BorderSide(width: 1.5, color: kTextoo.withOpacity(0.6)),
                          // )),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                height: 35,
                                decoration: const BoxDecoration(
                                    border: Border(
                                  left: BorderSide(width: 2, color: kTextoo),
                                )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Check In",
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.034,
                                        fontWeight: FontWeight.w500,
                                        color: kTextoo,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "00:00 AM",
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.034,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                height: 35,
                                decoration: const BoxDecoration(
                                    border: Border(
                                  left: BorderSide(width: 2, color: kTextoo),
                                )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Check Out",
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.034,
                                        fontWeight: FontWeight.w500,
                                        color: kTextoo,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "00:00 AM",
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.034,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                height: 35,
                                decoration: const BoxDecoration(
                                    border: Border(
                                  left: BorderSide(width: 2, color: kTextoo),
                                )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Kehadiran",
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.034,
                                        fontWeight: FontWeight.w500,
                                        color: kTextoo,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Belum Check In",
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.034,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                        return const Text('No data available.');
                      } else if (snapshot.data['category'] == 'Bolos') {
                        var data = snapshot.data;

                        return Container(
                          padding: const EdgeInsets.only(
                              top: 13, bottom: 13, left: 20, right: 30),
                          width: double.infinity,
                          child: Row(
                            children: [
                              dataContainer(formatDateTime(data['entry_time']),
                                  "Check In"),
                              const Spacer(),
                              dataContainer(formatDateTime(data['exit_time']),
                                  "Check Out"),
                              const Spacer(),
                              dataContainer('Bolos', "Kehadiran"),
                            ],
                          ),
                        );
                      } else {
                        // Data has been loaded
                        var data = snapshot.data;

                        return Container(
                          padding: const EdgeInsets.only(
                              top: 13, bottom: 13, left: 20, right: 30),
                          width: double.infinity,
                          child: Row(
                            children: [
                              dataContainer(formatDateTime(data['entry_time']),
                                  "Check In"),
                              const Spacer(),
                              dataContainer(formatDateTime(data['exit_time']),
                                  "Check Out"),
                              const Spacer(),
                              dataContainer(data['category'], "Kehadiran"),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 20, top: 20, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Newest Check',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                      const Spacer(),
                      FutureBuilder(
                        future: getProfil(),
                        builder: (context, snapshot) {
                          print('nullkah?');
                          print(snapshot.data?['data'][0]['nama_lengkap']);
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const Icon(
                                LucideIcons.x,
                                color: kTextoo,
                              );
                            } else {
                              return Visibility(
                                  visible: snapshot.data?['data'][0]
                                              ['permission'] ==
                                          'head_of_tribe' ||
                                      snapshot.data?['data'][0]['permission'] ==
                                          'human_resource' ||
                                      snapshot.data?['data'][0]['permission'] ==
                                          'president',
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RequestScreen(
                                                profile: snapshot.data['data']
                                                    [0]),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        LucideIcons.userCheck,
                                        color: kTextoo,
                                      )));
                            }
                          } else {
                            return Container(color: Colors.transparent);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height / 2.3,
                      child: FutureBuilder(
                        future:
                            getAbsensiAll(), // or getAbsensiToday() for the other one
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Show shimmer or a loading indicator
                            return Column(
                              children: [
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 3,
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
                                                    color:
                                                        const Color(0xffD9D9D9)
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
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 3,
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
                                                    color:
                                                        const Color(0xffD9D9D9)
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
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return Container(
                              color: Colors.white,
                            );
                          } else {
                            // Handle the case when you have data
                            var limitedData =
                                snapshot.data['data'].take(3).toList();
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: limitedData.length,
                                itemBuilder: (context, index) {
                                  print(snapshot.data['data']);
                                  print(limitedData[index]['entry_time']);
                                  print(snapshot.data['data'][index]
                                      ['entry_time']);
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
                                          .push(MaterialPageRoute(
                                        builder: (context) => detailPage,
                                      ));
                                    },
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
                                                                padding: const EdgeInsets
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
                                                                        snapshot.data['data'][index]
                                                                            [
                                                                            'entry_time'],
                                                                        snapshot.data['data'][index]
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
                                                          child:
                                                              VerticalDivider(
                                                            color: Color(
                                                                0xffE6E6E6),
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
                                                                          style:
                                                                              GoogleFonts.montserrat(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                blueText,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          )),
                                                                      const SizedBox(
                                                                        height:
                                                                            3,
                                                                      ),
                                                                      Text(
                                                                          formatDateTime(snapshot.data['data'][index]
                                                                              [
                                                                              'entry_time']),
                                                                          style:
                                                                              GoogleFonts.montserrat(
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
                                                                      width:
                                                                          10),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                          'Check out',
                                                                          style:
                                                                              GoogleFonts.montserrat(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                blueText,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          )),
                                                                      const SizedBox(
                                                                        height:
                                                                            3,
                                                                      ),
                                                                      Text(
                                                                          formatDateTime(snapshot.data['data'][index]
                                                                              [
                                                                              'exit_time']),
                                                                          style:
                                                                              GoogleFonts.montserrat(
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
                                                    color:
                                                        const Color(0xffD9D9D9)
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
                                                                          [
                                                                          index]
                                                                      [
                                                                      'status'],
                                                                  snapshot.data[
                                                                              'data']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'category'],
                                                                  snapshot.data[
                                                                              'data']
                                                                          [
                                                                          index]
                                                                      [
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
                          }
                        },
                      )),
                ],
              ),
              // button check in  \\
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, left: 30, bottom: 7.5, top: 7.5),
                child: Container(
                    width: double.infinity,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                     
                      color: kButton,
                    ),
                    child: _buildButtonBasedOnStatus()),
              ),
            ],
          ),
        ),
      )
          // child: LayoutBuilder(
          //   builder: (BuildContext context, BoxConstraints constraints) {
          //     return _buildNarrowLayout(context);
          //   },
          // ),
          ),
    );
  }

  Widget shimmerContainer1() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        height: 35,
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(width: 2, color: kTextoo),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 10,
              color: Colors.white,
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              width: 40,
              height: 10,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmerContainer2() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        height: 35,
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(width: 2, color: kTextoo),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70, // You can adjust width as necessary
              height: 10, // Adjust height for the shimmer effect
              color: Colors.white,
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              width: 40, // You can adjust width as necessary
              height: 10, // Adjust height for the shimmer effect
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmerContainer3() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        height: 35,
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(width: 2, color: kTextoo),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 10,
              color: Colors.white,
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              width: 90,
              height: 10,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

// widget modal chekcin
  Widget _modalCheckin() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 62,
          decoration: const BoxDecoration(),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateWfa(),
                  ));
              // setState(() {
              //   selectedOption = 'WFA';
              //   _tinggimodal = 420;
              //   showCheckin = false;
              //   showAtributModalCheckin = false;
              // });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kButton,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('WFA',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: whiteText,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ),
        
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 62,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kButton,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('PERJADIN',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: whiteText,
                  fontWeight: FontWeight.w600,
                )),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePerjadin(),
                  ));
              // setState(() {
              //   selectedOption = 'WFO';
              //   showCheckin = false;
              //   showAtributModalCheckin = false;
              // });
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 62,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kButton,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('WFO',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: whiteText,
                  fontWeight: FontWeight.w600,
                )),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapSample(),
                  ));
              // setState(() {
              //   selectedOption = 'WFO';
              //   showCheckin = false;
              //   showAtributModalCheckin = false;
              // });
            },
          ),
        ),
      ],
    );
  }

  // modal chekcin atribut
  Widget _modalCheckinAtribut() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Attendance with',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  ' Approval!',
                  style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(67, 129, 202, 1)),
                ),
              ],
            ),
            Text(
              'Pilih jenis check-in',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(182, 182, 182, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modalPendingAttribute() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Waiting',
                  style: GoogleFonts.montserrat(
                    fontSize: MediaQuery.of(context).size.width * 0.049,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  ' Approval',
                  style: GoogleFonts.montserrat(
                      fontSize: MediaQuery.of(context).size.width * 0.049,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(67, 129, 202, 1)),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Permintaan mu masih dalam status pending',
              style: GoogleFonts.montserrat(
                fontSize: MediaQuery.of(context).size.width * 0.034,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(182, 182, 182, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modalBolosAttribute() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only( top: 16, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kamu',
                  style: GoogleFonts.montserrat(
                    fontSize: MediaQuery.of(context).size.width * 0.039,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  ' Bolos',
                  style: GoogleFonts.montserrat(
                    fontSize: MediaQuery.of(context).size.width * 0.039,
                    fontWeight: FontWeight.w500,
                    color: kTextBlocker,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Text(
              'Kamu sudah bolos hari ini, tolong untuk tidak melakukan lagi dihari berikutnya',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(          
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(182, 182, 182, 1),
              ),
            ),
            )
          ],
        ),
      ),
    );
  }

  Widget _modalCheckOutAtribut(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Have a ',
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'restful break!',
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(67, 129, 202, 1),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Pilih Check Out',
              style: GoogleFonts.montserrat(
                fontSize: MediaQuery.of(context).size.width * 0.039,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(182, 182, 182, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modalWfa() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Choose your type of WFA',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    '*',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                hint: Text(
                  'Select Keterangan WFA',
                  style: GoogleFonts.montserrat(fontSize: 14),
                ),
                items: genderItems
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select option.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    selectedKeterangan = value ?? '';
                  });
                },
                onSaved: (value) {
                  selectedKeterangan = value ?? '';
                },
                selectedItemBuilder: (BuildContext context) {
                  return genderItems.map<Widget>((String item) {
                    return Text(
                      item,
                      style: GoogleFonts.montserrat(fontSize: 14),
                    );
                  }).toList();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'Description ( Optional )',
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              TextField(
                controller:
                    _descriptionController, // Declare TextEditingController
                style: GoogleFonts.montserrat(color: kText),
                keyboardType: TextInputType.text,
                maxLines: 4,
                scrollPhysics: const ScrollPhysics(),
                decoration: InputDecoration(
                  hintText: 'Write description...',
                  hintStyle: GoogleFonts.montserrat(
                    color: Colors.black26,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black38,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(182, 182, 182, 1),
                      width: 1,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xff4381ca),
                          width: 1,
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Back',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: hitamText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedOption = 'BACK';
                            _tinggimodal = 320;
                            showModalWfa = false;
                            showCheckin = true;
                            showAtributModalCheckin = true;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: kButton,
                          width: 1,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final facePageArgs = {
                            'selectedOption': 'WFA',
                            'description': _descriptionController.text,
                            'keteranganWfa': selectedKeterangan,
                          };
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         FacePage(arguments: facePageArgs),
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: kButton,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          'Check In',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: whiteText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _modalWfo() {
    return Column(
      children: [
        Container(
          child: const Column(
            children: [
              Text('Choose your type of WFA'),
            ],
          ),
        )
      ],
    );
  }

  Widget dataContainer(String text, String title) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      height: 35,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 2, color: kTextoo),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: MediaQuery.of(context).size.width * 0.034,
              fontWeight: FontWeight.w500,
              color: kTextoo,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: MediaQuery.of(context).size.width * 0.034,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modalPerjadin() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Upload file',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      )),
                  const Text('*',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      )),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: double.infinity, // Adjust the width here
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: kBorder,
                    width: 1,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 10),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _pickFile,
                  child: Row(
                    children: [
                      Text(
                          _pickedFile != null
                              ? '${_pickedFile!.files.first.name}'
                              : 'Choose file',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: kTextgrey,
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              'Mulai',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Text(
                              '*',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                              color: kBorder,
                              width: 1,
                            ),
                          ),
                        ),
                        onPressed: _selectDate,
                        child: Row(
                          children: [
                            Text(
                              _selectedDate != null
                                  ? "${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}"
                                  : 'mm/dd/yyyy',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: kTextgrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.calendar_today,
                              color: kBorder,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              'Selesai',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Text(
                              '*',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                              color: kBorder,
                              width: 1,
                            ),
                          ),
                        ),
                        onPressed: _selesaiTanggall,
                        child: Row(
                          children: [
                            Text(
                              _selectedDate != null
                                  ? "${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}"
                                  : 'mm/dd/yyyy',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: kTextgrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.calendar_today,
                              color: kBorder,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xff4381ca),
                          width: 1,
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedOption = 'BACK';
                            _tinggimodal = 320;
                            showModalWfa = false;
                            showCheckin = true;
                            showAtributModalCheckin = true;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedOption = 'WFA';
                            showCheckin = false;
                            showAtributModalCheckin = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: kButton,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Check In'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

// LAYAR KECIL <600
}
