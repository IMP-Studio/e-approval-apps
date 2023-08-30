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
        'https://85d1-2404-8000-1027-303f-c7c-d051-4a64-56ab.ngrok-free.app/api/absensi/$userId';
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
                        color: Colors.black12,
                      ),
                    ),
                    if (showAtributModalCheckin) _modalCheckinAtribut(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        child: Column(
                          children: [Text('KONCAK')],
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
                        color: Colors.black12,
                      ),
                    ),
                    if (showAtributModalCheckin) _modalCheckinAtribut(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        child: Column(
                          children: [Text('KONCAK')],
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
        'https://85d1-2404-8000-1027-303f-c7c-d051-4a64-56ab.ngrok-free.app/api/profile?id=$userId';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
  }

  Future getAbsensiAll() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://85d1-2404-8000-1027-303f-c7c-d051-4a64-56ab.ngrok-free.app/api/absensi?id=$userId';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
  }

  Future getAbsensiToday() async {
    int userId = preferences?.getInt('user_id') ?? 0;
    // String user = userId.toString();
    final String urlj =
        'https://85d1-2404-8000-1027-303f-c7c-d051-4a64-56ab.ngrok-free.app/api/absensi/today/$userId';
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
          // child: LayoutBuilder(
          //   builder: (BuildContext context, BoxConstraints constraints) {
          //     return _buildNarrowLayout(context);
          //   },
          // ),
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
          padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateWfa(),
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
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(0xff4381ca),
              width: 1,
            ),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('PERJADIN',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: hitamText,
                  fontWeight: FontWeight.w600,
                )),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePerjadin(),
                  ));
              // setState(() {
              //   selectedOption = 'PERJADIN';
              //   _tinggimodal = 420;
              //   showCheckin = false;
              //   showAtributModalCheckin = false;
              // });
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 54,
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
                    builder: (context) => MapSample(),
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

  Widget _modalWfa() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 25),
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
                  Text(
                    '*',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
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
                            style: TextStyle(
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
                scrollPhysics: ScrollPhysics(),
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
                      margin: EdgeInsets.only(right: 10),
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xff4381ca),
                          width: 1,
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FacePage(arguments: facePageArgs),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
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
          child: Column(
            children: [
              Text('Choose your type of WFA'),
            ],
          ),
        )
      ],
    );
  }

  Widget _modalPerjadin() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 25),
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
                  Text('*',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      )),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
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
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
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
                            Text(
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
                          padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
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
                            SizedBox(width: 8),
                            Icon(
                              Icons.calendar_today,
                              color: kBorder,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
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
                            Text(
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
                          padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
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
                            SizedBox(width: 8),
                            Icon(
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
                      margin: EdgeInsets.only(right: 10),
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xff4381ca),
                          width: 1,
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 18),
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
                          padding: EdgeInsets.symmetric(vertical: 18),
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
  Widget _buildNarrowLayout(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 0),
                      padding: const EdgeInsets.only(left:20),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: kCardblue,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "IMP APPROVEL",
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.02,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.67,
                                child: Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  "Focus and finish what you have started.",
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width * 0.044,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                "assets/img/imp-logo2.png",
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height * 0.15,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // jadwal
                // card baru
                Container(
                  padding:
                      EdgeInsets.only(top: 13, bottom: 13, left: 20, right: 30),
                  width: double.infinity,
                  // decoration: BoxDecoration(
                  //     border: Border(
                  //   bottom: BorderSide(width: 1.5, color: kTextoo.withOpacity(0.6)),
                  // )),
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

                // card lama
                // Padding(
                //   padding: const EdgeInsets.only(left: 30, right: 30),
                //   child: Center(
                //     child: Container(
                //       transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                //       width: double.infinity,
                //       height: 120,
                //       decoration: BoxDecoration(
                //         color: kButton,
                //         borderRadius: BorderRadius.circular(10),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.25),
                //             blurRadius: 4.0,
                //             spreadRadius: 0.0, // Set to 0 for no spread
                //             offset:
                //                 Offset(2.0, 2.0), // changes position of shadow
                //           ),
                //         ],
                //       ),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.symmetric(vertical: 10),
                //             child: Text('Total working hours',
                //                 style: GoogleFonts.montserrat(
                //                   color: kText2,
                //                   fontSize: 12,
                //                   fontWeight: FontWeight.w600,
                //                 )),
                //           ),
                //           Divider(
                //             color: Colors.white,
                //             height: 1,
                //             thickness: 1,
                //           ),
                //           IntrinsicHeight(
                //             child: Padding(
                //               padding: const EdgeInsets.only(
                //                   top: 15, right: 30, left: 30, bottom: 5),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       Padding(
                //                         padding: const EdgeInsets.only(
                //                             top: 5, bottom: 5, right: 5),
                //                         child: Container(
                //                           padding: EdgeInsets.symmetric(
                //                               vertical: 10),
                //                           height: 2,
                //                           width: 20,
                //                           color: Colors.white,
                //                         ),
                //                       ),
                //                       Text('Today',
                //                           style: GoogleFonts.montserrat(
                //                             fontSize: 12,
                //                             color: kText2,
                //                             fontWeight: FontWeight.w400,
                //                           )),
                //                       FutureBuilder(
                //                         future: getAbsensiToday(),
                //                         builder: (context, snapshot) {
                //                           if (snapshot.hasData) {
                //                             return Text('');
                //                             // DateTime waktuMasuk =
                //                             //     DateTime.parse(snapshot
                //                             //         .data['waktu_masuk']);
                //                             // DateTime waktuKeluar =
                //                             //     DateTime.parse(snapshot
                //                             //         .data['waktu_keluar']);
                //                             // Duration workDuration = waktuKeluar
                //                             //     .difference(waktuMasuk);
                //                             // String hours =
                //                             //     workDuration.inHours.toString();
                //                             // String minutes =
                //                             //     (workDuration.inMinutes % 60)
                //                             //         .toString();

                //                             // return Text(
                //                             //   '$hours hours  ',
                //                             //   style: GoogleFonts.montserrat(
                //                             //     fontSize: 12,
                //                             //     color: kText2,
                //                             //     fontWeight: FontWeight.w700,
                //                             //   ),
                //                             // );
                //                           } else {
                //                             return CircularProgressIndicator();
                //                           }
                //                         },
                //                       ),
                //                     ],
                //                   ),
                //                   Spacer(),
                //                   // VerticalDivider(
                //                   //   color: Colors.white,
                //                   //   thickness: 2,
                //                   // ),
                //                   Spacer(),
                //                   Column(
                //                     crossAxisAlignment: CrossAxisAlignment.end,
                //                     children: [
                //                       Padding(
                //                         padding: const EdgeInsets.only(
                //                           top: 5,
                //                           bottom: 5,
                //                           left: 5,
                //                         ),
                //                         child: Container(
                //                           height: 2,
                //                           width: 20,
                //                           color: Colors.white,
                //                         ),
                //                       ),
                //                       Text('Attendance',
                //                           style: GoogleFonts.montserrat(
                //                             fontSize: 12,
                //                             color: kText2,
                //                             fontWeight: FontWeight.w400,
                //                           )),
                //                       // FutureBuilder(
                //                       //   future: getAbsensiAll(),
                //                       //   builder: (context, snapshot) {
                //                       //     if (snapshot.hasData) {
                //                       //       return Text(
                //                       //           snapshot.data['data'][]
                //                       //               ['jenis_kehadiran'],
                //                       //           style: GoogleFonts.montserrat(
                //                       //             fontSize: 12,
                //                       //             color: kText2,
                //                       //             fontWeight: FontWeight.w700,
                //                       //           ));
                //                       //     } else {
                //                       //       return CircularProgressIndicator();
                //                       //     }
                //                       //   },
                //                       // ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 20, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
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
                                                              left: 5,
                                                              right: 5),
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
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)),
                                                      color: Color(0xffD9D9D9)
                                                          .withOpacity(0.15),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        bottom: 10,
                                                        top: 10,
                                                        right: 5,
                                                        left: 5,
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Rejected by',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize: 8,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              )),
                                                          Text('HR',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize: 8,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
