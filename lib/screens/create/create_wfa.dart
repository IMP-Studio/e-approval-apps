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
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class CreateWfa extends StatefulWidget {
  const CreateWfa({super.key});

  @override
  State<CreateWfa> createState() => _CreateWfaState();
}

class _CreateWfaState extends State<CreateWfa> {
  TextEditingController descriptionController = TextEditingController();
  late Timer _timer; // Define the timer
  bool _isMounted = false;
  bool _isSnackbarVisible = false;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _isMounted = true;
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
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
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.85),
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
                height: 50,
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

  final List<String> jenisItems = [
    'Kesehatan',
    'Keluarga',
    'Pendidikan',
    'Lainnya',
  ];

  void initState() {
    super.initState();
    _timer = Timer(Duration.zero, () {});
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

  String? selectedValue;

  Widget _inputdeskripsi() {
    return Column(
      children: [
        // alasan
        const Padding(padding: EdgeInsets.only(top: 25)),
        Row(
          children: [
            Text(
              'Alasan',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
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
        const Padding(padding: EdgeInsets.only(bottom: 5)),
        TextField(
          controller: descriptionController,
          style: GoogleFonts.montserrat(color: kText),
          keyboardType: TextInputType.text,
          maxLines: 4,
          scrollPhysics: const ScrollPhysics(),
          decoration: InputDecoration(
            hintText: 'Deskripsi...',
            hintStyle: GoogleFonts.montserrat(
                color: kBorder, fontWeight: FontWeight.w400, fontSize: 14),
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: kBorder,
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
      ],
    );
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
              padding: const EdgeInsets.only(left: 3, right: 30),
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
                        "WFA",
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
                      "Work From Anywhere akan di proses oleh HT & Management.",
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
                'Pilih Jenis WFA',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: kTextgrey,
                ),
              ),
              items: jenisItems
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Container(
                          padding: const EdgeInsets.all(
                              8.0), // Add your desired padding value
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Pilih jenis cuti.';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
              onSaved: (value) {
                selectedValue = value.toString();
              },
              selectedItemBuilder: (BuildContext context) {
                return jenisItems.map<Widget>((String item) {
                  return Text(
                    item,
                    style: GoogleFonts.montserrat(fontSize: 14),
                  );
                }).toList();
              },
            ),
            if (selectedValue == 'Lainnya') _inputdeskripsi(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
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
                                var profileData = snapshot.data;

                                return ElevatedButton(
                                  onPressed: () {
                                    if (selectedValue == null) {
                                      showSnackbarWarning(
                                          "Fail...",
                                          "Opsi belum dipilih",
                                          kTextBlocker,
                                          Icon(
                                            LucideIcons.checkCircle2,
                                            size: 26.0,
                                            color: kTextBlocker,
                                          ));
                                    } else if (selectedValue == 'other' &&
                                        descriptionController.text.isEmpty) {
                                      showSnackbarWarning(
                                          "Fail...",
                                          "Deskripsi masih kosong",
                                          kTextBlocker,
                                          Icon(
                                            LucideIcons.checkCircle2,
                                            size: 26.0,
                                            color: kTextBlocker,
                                          ));
                                    } else {
                                      setState(() {
                                        final facePageArgs = {
                                          'category': 'telework',
                                          'keteranganWfa': selectedValue,
                                          'description':
                                              descriptionController.text,
                                        };

                                        print(facePageArgs);

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
                                    'Ajukan Wfa',
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
