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
import 'package:intl/intl.dart';
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

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
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

  Future<void> _btntanggalKembali() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _tanggalKembali ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _tanggalKembali = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                              :  'Pilih Berkas',
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
                                  return const Text(
                                      'Error occurred while fetching profile');
                                } else {
                                  var profileData = snapshot.data['data'][0];

                                  return ElevatedButton(
                                    onPressed: () {
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 19),
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
      ),
    );
  }
}
