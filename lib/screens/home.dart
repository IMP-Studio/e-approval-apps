import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/create/create_perjadin.dart';
import 'package:imp_approval/screens/detail/detail_absensi.dart';
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
import 'package:imp_approval/screens/create/create_wfa.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
}

class _HomePageState extends State<HomePage> {
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

  final List<String> genderItems = [
    'Kesehatan',
    'Pendidikan',
    'Keluarga',
  ];

  Future<String> checkAbsensi() async {
    int userId = preferences?.getInt('user_id') ?? 0;

    final urlj =
        'https://147d-2404-8000-1027-303f-51a4-2ec9-e5e5-1128.ngrok-free.app/api/absensi/$userId';
    var response = await http.get(Uri.parse(urlj));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('Server Response Status: ${jsonData['status']}'); // Debug line
      return jsonData['status'];
    } else {
      throw Exception('Failed to load attendance status');
    }
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
          default:
            _attendanceStatus = AttendanceStatus.notAttended;
            break;
        }
      });
    } catch (error) {
      print('Error fetching attendance status: $error');
      // Handle error accordingly.
    }
  }

  Widget _buildButtonBasedOnStatus() {
    switch (_attendanceStatus) {
      case AttendanceStatus.loading:
        return _buildShimmerButton();
      case AttendanceStatus.notAttended:
        return _buildCheckInButton();
      case AttendanceStatus.checkedIn:
        return _buildCheckOutButton();
      case AttendanceStatus.checkedOut:
        return _buildCheckedOutButton();
      case AttendanceStatus.completed:
      default:
        return _buildCompletedButton();
    }
  }

  Widget _buildShimmerButton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ElevatedButton(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
              // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                // height: _tinggimodal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 10),
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
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
          SizedBox(height: 10),
          CupertinoTextField(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
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
          shape: RoundedRectangleBorder(
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
                      margin: EdgeInsets.only(top: 15, bottom: 10),
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
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
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                minimumSize: Size(double.infinity, 45),
                                backgroundColor: kButton,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _modalvalidasidarurat(context),
                                      ],
                                    );
                                  },
                                );
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
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xff4381ca),
                                ),
                                // Mengatur lebar tombol menjadi double.infinity
                                minimumSize: Size(double.infinity, 45),
                              ),
                              onPressed: () {},
                              child: Text("Pulang",
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.034,
                                    color: hitamText,
                                    fontWeight: FontWeight.w600,
                                  )),
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
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Completed',
        style: GoogleFonts.inter(
          color: whiteText,
          fontSize: MediaQuery.of(context).size.width * 0.039,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _buildCompletedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Completed',
        style: GoogleFonts.inter(
          color: whiteText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {},
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
        'https://147d-2404-8000-1027-303f-51a4-2ec9-e5e5-1128.ngrok-free.app/api/profile?id=$userId';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
  }

  Future getAbsensiAll() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://147d-2404-8000-1027-303f-51a4-2ec9-e5e5-1128.ngrok-free.app/api/absensi?id=$userId';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
  }

  Future getAbsensiToday() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://147d-2404-8000-1027-303f-51a4-2ec9-e5e5-1128.ngrok-free.app/api/absensi/today/$userId';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
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
    getUserData().then((_) {
      print("Description: ${_descriptionController.text}");
      _fetchStatusAbsensi();
      getProfil();
      getAbsensiAll();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showModalWfa == 'true') {
        setState(() {
          _tinggimodal = 420;
        });
      }
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

  String formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) {
      return '-- : --';
    }

    try {
      DateTime parsedDateTime = DateTime.parse(dateTimeStr);
      return DateFormat('hh:mm a').format(parsedDateTime);
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _buildNarrowLayout(context),
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            minimumSize: Size(double.infinity, 35),
            backgroundColor: kButton,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateWfa(),
                ));
          },
          child: Text('WFA',
              style: GoogleFonts.montserrat(
                fontSize: MediaQuery.of(context).size.width * 0.034,
                color: whiteText,
                fontWeight: FontWeight.w600,
              )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            side: const BorderSide(
              width: 1,
              color: Color(0xff4381ca),
            ),
            minimumSize: Size(double.infinity, 35),
          ),
          onPressed: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePerjadin(),
                  ));
          },
          child: Text("PERJADIN",
              style: GoogleFonts.montserrat(
                fontSize: MediaQuery.of(context).size.width * 0.034,
                color: hitamText,
                fontWeight: FontWeight.w600,
              )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
         ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            minimumSize: Size(double.infinity, 35),
            backgroundColor: kButton,
          ),
          onPressed: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapSample(),
                  ));
          },
          child: Text('WFO',
              style: GoogleFonts.montserrat(
                fontSize: MediaQuery.of(context).size.width * 0.034,
                color: whiteText,
                fontWeight: FontWeight.w600,
              )),
        ),
      ],
    );
  }

  // modal chekcin atribut
  Widget _modalCheckinAtribut() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 16, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Welcome to',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Text(
                  ' Approval!',
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(67, 129, 202, 1)),
                ),
              ],
            ),
            Text(
              'Choose your type of Check In',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(182, 182, 182, 1),
              ),
            ),
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
                      color: Color.fromRGBO(67, 129, 202, 1),
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
                color: Color.fromRGBO(182, 182, 182, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

// LAYAR KECIL <600
  Widget _buildNarrowLayout(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Column(
              children: [
                // hero img
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
                                  "IMP APPROVEL",
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
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
                      Spacer(),
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
                // card baru
                Container(
                  padding:
                      EdgeInsets.only(top: 13, bottom: 13, left: 20, right: 30),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        height: 50,
                        decoration: BoxDecoration(
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
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.w500,
                                color: kTextoo,
                              ),
                            ),
                            Text(
                              "08:32 AM",
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        height: 50,
                        decoration: BoxDecoration(
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
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.w500,
                                color: kTextoo,
                              ),
                            ),
                            Text(
                              "08:32 AM",
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border(
                          left: BorderSide(width: 2, color: kTextoo),
                        )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "kehadiran",
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.w500,
                                color: kTextoo,
                              ),
                            ),
                            Text(
                              "WFA",
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 15, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Newest Check',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    Spacer(),
                    Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RequestScreen(),
                                ),
                              );
                            },
                            child: Icon(
                              LucideIcons.userCheck,
                              color: kTextoo,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.2,
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : FutureBuilder(
                          future: getAbsensiAll(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data['data'] == null ||
                                  snapshot.data['data'].isEmpty) {
                                // Return an Image or placeholder here
                                return Center(
                                  child: Container(
                                    color: Colors.white,
                                  ), // Replace with your image path
                                );
                              }
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data['data'].length,
                                  itemBuilder: (context, index) {
                                    print(snapshot.data['data']);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailAbsensi(
                                                    absen: snapshot.data['data']
                                                        [index],
                                                  )),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
                                              width: double.infinity,
                                              height: 99,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.25),
                                                    blurRadius: 4.0,
                                                    spreadRadius: 0.0,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
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
                                                                            5,
                                                                        right:
                                                                            5),
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              10),
                                                                  height: 2,
                                                                  width: 20,
                                                                  color:
                                                                      blueText,
                                                                ),
                                                              ),
                                                              Text(
                                                                  DateFormat(
                                                                          'dd MMMM yyyy')
                                                                      .format(DateTime.parse(snapshot.data['data'][index]
                                                                              [
                                                                              'tanggal']) ??
                                                                          DateTime
                                                                              .now()),
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        blueText,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  )),
                                                              Row(
                                                                children: [
                                                                  Text('00:00 ',
                                                                      style: GoogleFonts
                                                                          .montserrat(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      )),
                                                                  Text(
                                                                      'Total hours',
                                                                      style: GoogleFonts
                                                                          .montserrat(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      )),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10),
                                                            child:
                                                                VerticalDivider(
                                                              color:
                                                                  Colors.black,
                                                              thickness: 1,
                                                            ),
                                                          ),
                                                          Spacer(),
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
                                                                child:
                                                                    Container(
                                                                  height: 2,
                                                                  width: 20,
                                                                  color:
                                                                      blueText,
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Text(
                                                                            'Check in',
                                                                            style:
                                                                                GoogleFonts.montserrat(
                                                                              fontSize: 8,
                                                                              color: blueText,
                                                                              fontWeight: FontWeight.w600,
                                                                            )),
                                                                        Text(
                                                                            formatDateTime(snapshot.data['data'][index][
                                                                                'waktu_masuk']),
                                                                            style:
                                                                                GoogleFonts.montserrat(
                                                                              fontSize: 10,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w500,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Column(
                                                                      children: [
                                                                        Text(
                                                                            'Check out',
                                                                            style:
                                                                                GoogleFonts.montserrat(
                                                                              fontSize: 8,
                                                                              color: blueText,
                                                                              fontWeight: FontWeight.w600,
                                                                            )),
                                                                        Text(
                                                                            formatDateTime(snapshot.data['data'][index][
                                                                                'waktu_keluar']),
                                                                            style:
                                                                                GoogleFonts.montserrat(
                                                                              fontSize: 10,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w500,
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
                                                  Spacer(),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffD9D9D9)
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
                                                          Text(
                                                              'Work From Office',
                                                              // snapshot.data['data'][index]['jenis_kehadiran'],
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.02,
                                                                color:
                                                                    kTextgrey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )),
                                                          Text('Ditolak oleh',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.02,
                                                                color:
                                                                    kTextgrey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )),
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
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                ),
              ],
            ),
            // button check in  \\
            Padding(
              padding: EdgeInsets.only(right: 30, left: 30, bottom: 15),
              child: Container(
                  width: double.infinity,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4.0,
                        spreadRadius: 0.0, // Set to 0 for no spread
                        offset: Offset(1, 1), // changes position of shadow
                      ),
                    ],
                    color: kButton,
                  ),
                  child: _buildButtonBasedOnStatus()),
            ),
          ],
        ),
      ),
    );
  }
}
