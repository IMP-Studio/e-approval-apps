import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/face_recognition.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';

class CreatePerjadin extends StatefulWidget {
  const CreatePerjadin({super.key});

  @override
  State<CreatePerjadin> createState() => _CreatePerjadinState();
}

class _CreatePerjadinState extends State<CreatePerjadin>
    with WidgetsBindingObserver {
  DateTime? _selectedDate;
  DateTime? _selesaiTanggal;
  DateTime? _tanggalKembali;
  FilePickerResult? _pickedFile;

  late Timer _timer;
  bool _isMounted = false;
  bool _isSnackbarVisible = false;

  bool _timerInitialized = false;

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getUserData().then((_) {
      print(preferences?.getInt('user_id'));
      getProfil();
    });
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
    return jsonDecode(response.body);
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xls', 'xlsx', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> _selectDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime
          .now(), // This ensures that the user can't select a date before today
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _selesaiTanggal = newDate;
      });
    }
  }

  Future<void> _btntanggalKembali() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _tanggalKembali ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _tanggalKembali = newDate;
      });
    }
  }

  int get differenceInDays {
    if (_selectedDate != null && _selesaiTanggal != null) {
      return _selesaiTanggal!.difference(_selectedDate!).inDays;
    }
    return 0; // Default value when either date is null
  }

  int get differenceInDays2 {
    if (_tanggalKembali != null) {
      return _tanggalKembali!.difference(_selesaiTanggal!).inDays;
    }
    return 0; // Default value when the date is null
  }

@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isMounted = true;
  }

  @override
  void dispose() {
    if (_timerInitialized) {
      _timer.cancel();
    }
    _isMounted = false;
    super.dispose();
  }

  void showSnackbarWarning(String message, String submessage,
      Color backgroundColor, Icon customIcon) {
    if (_isSnackbarVisible) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }

    _isSnackbarVisible = true;

    int secondsRemaining = 3; // Set the initial duration to 10 seconds
    if (_timerInitialized) {
      _timer.cancel();
    }

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

    _timerInitialized = true;

    final snackBar = SnackBar(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.9),
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
                height: 50,
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

  bool areInputsValidForWorkTrip() {
    if (_pickedFile == null) {
      showSnackbarWarning("Fail...", "File belum dipilih", kTextBlocker,
          const Icon(LucideIcons.xCircle, size: 26.0, color: kTextBlocker));
      return false;
    }
    if (_selectedDate == null || _selesaiTanggal == null) {
      showSnackbarWarning(
          "Fail...",
          "Tanggal mulai atau akhir belum diisi",
          kTextBlocker,
          const Icon(LucideIcons.xCircle, size: 26.0, color: kTextBlocker));
      return false;
    }
    if (_tanggalKembali == null) {
      showSnackbarWarning("Fail...", "Tanggal masuk belum diisi", kTextBlocker,
          const Icon(LucideIcons.xCircle, size: 26.0, color: kTextBlocker));
      return false;
    }
    if (differenceInDays < 0) {
      showSnackbarWarning(
          "Fail...",
          "Tanggal mulai dan akhir tidak valid",
          kTextBlocker,
          const Icon(LucideIcons.xCircle, size: 26.0, color: kTextBlocker));
      return false;
    }
    if (differenceInDays2 > 3) {
      showSnackbarWarning(
          "Fail...",
          "Maksimal untuk kembali adalah 2 hari",
          kTextBlocker,
          const Icon(LucideIcons.xCircle, size: 26.0, color: kTextBlocker));
      return false;
    }
    return true;
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                LucideIcons.award,
                color: Color.fromRGBO(67, 129, 202, 1),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Container(
              padding: const EdgeInsets.only(right: 30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Divider(
                      color: Color.fromRGBO(67, 129, 202, 1),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Ajukan",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Perjadin",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: const Color.fromRGBO(67, 129, 202, 1),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      "Perjadin mu akan di proses oleh HT & Management.",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // form
            Row(
              children: [
                Text('Upload file',
                    style: GoogleFonts.montserrat(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w600,
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
              width: double.infinity, // Adjust the width here
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: kBorder,
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _pickFile,
                child: Row(
                  children: [
                    Expanded(
                      // Wrapping Text widget in Flexible
                      child: Text(
                        _pickedFile != null
                            ? '${_pickedFile!.files.first.name}'
                            : 'Pilih Berkas',
                        overflow: TextOverflow.ellipsis, // Ellipsis overflow
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: kTextgrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      LucideIcons.arrowDownCircle,
                      color: kBorder,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 5),
                  child: Row(
                    children: [
                      Text(
                        'Tanggal',
                        style: GoogleFonts.montserrat(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 15),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                                  : 'Mulai',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: kTextgrey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              LucideIcons.calendar,
                              color: kBorder,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 15),
                          backgroundColor: Colors.transparent,
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
                              _selesaiTanggal != null
                                  ? "${_selesaiTanggal!.year}/${_selesaiTanggal!.month}/${_selesaiTanggal!.day}"
                                  : 'Akhir',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: kTextgrey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              LucideIcons.calendar,
                              color: kBorder,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            // tgl kembali
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 5),
                  child: Row(
                    children: [
                      Text(
                        'Mulai',
                        style: GoogleFonts.montserrat(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 15),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(
                        color: kBorder,
                        width: 1,
                      ),
                    ),
                  ),
                  onPressed: _btntanggalKembali,
                  child: Row(
                    children: [
                      Text(
                        _tanggalKembali != null
                            ? "${_tanggalKembali!.year}/${_tanggalKembali!.month}/${_tanggalKembali!.day}"
                            : 'Tanggal masuk kembali',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: kTextgrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        LucideIcons.calendar,
                        color: kBorder,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        width: 120,
                        child: FutureBuilder(
                          future: getProfil(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Shimmer.fromColors(
                                  baseColor: kButton.withOpacity(0.5),
                                  highlightColor: kButton.withOpacity(0.7),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: kButton,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 19),
                                  ),
                                );
                              } else {
                                var profileData = snapshot.data['data'][0];

                                return ElevatedButton(
                                  onPressed: () {
                                    if (areInputsValidForWorkTrip()) {
                                      setState(() {
                                        final facePageArgs = {
                                          'category': 'work_trip',
                                          'start_date': _selectedDate,
                                          'end_date': _selesaiTanggal,
                                          'entry_date': _tanggalKembali,
                                          'file': _pickedFile?.files.first.path,
                                        };

                                        print(facePageArgs);
                                        print(
                                            'Muka : ${profileData['facepoint']}');
                                        print(
                                            'Category: ${facePageArgs['category']}');
                                        print(
                                            'Start Date: ${facePageArgs['start_date']}');
                                        print(
                                            'End Date: ${facePageArgs['end_date']}');
                                        print(
                                            'Entry Date: ${facePageArgs['entry_date']}');
                                        print('File: ${facePageArgs['file']}');

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FacePage(
                                                arguments: facePageArgs,
                                                profile: profileData),
                                          ),
                                        );
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    backgroundColor: kButton,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Ajukan Perjadin',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: whiteText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Shimmer.fromColors(
                                baseColor: kButton.withOpacity(0.5),
                                highlightColor: kButton.withOpacity(0.7),
                                child: Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: kButton,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 19),
                                ),
                              );
                            }
                          },
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
    );
  }
}
