import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/face_recognition.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class EditWfa extends StatefulWidget {
  final Map absen;
  const EditWfa({super.key, required this.absen});

  @override
  State<EditWfa> createState() => _EditWfaState();
}

class _EditWfaState extends State<EditWfa> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    _timer = Timer(Duration.zero, () {});
    selectedValue = widget.absen['telework_category'];
    descriptionController.text = widget.absen['category_description'] ?? '';
  }

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

    int secondsRemaining = 1; // Set the initial duration to 10 seconds
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
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.95),
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
    'kesehatan',
    'keluarga',
    'pendidikan',
    'other',
  ];

  String? selectedValue;

  Future updateWfa() async {
    int idWfa = widget.absen['id'];

    if (selectedValue == 'other' &&
        (descriptionController.text == null ||
            descriptionController.text.isEmpty)) {
      print('Error: Description is required for "other" category.');
      return; // Or you can show an alert dialog or a snackbar to inform the user.
    }

    final response = await http.put(
        Uri.parse(
            'https://testing.impstudio.id/approvall/api/presence/update/$idWfa'),
        body: {
          "user_id": widget.absen['user_id'].toString(),
          "telework_category": selectedValue,
          "category_description":
              (selectedValue != 'other' ? null : descriptionController.text) ??
                  "",
          "status": 'pending',
        });

    print(response.body);
    return json.decode(response.body);
  }

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
              value: selectedValue,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              hint: Text(
                'Pilih jenis cuti',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: kTextgrey,
                ),
              ),
              items: jenisItems
                  .map((item) => DropdownMenuItem<String>(
                        value: item, // <-- Set item value here
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
                  return 'Pilih jenis cuti.';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return jenisItems.map<Widget>((String item) {
                  return Text(
                    item,
                    style: GoogleFonts.montserrat(fontSize: 14),
                  );
                }).toList();
              },
              icon: const Icon(LucideIcons.arrowDownCircle,
                  color: Color(0xffB6B6B6), size: 17),
            ),
            if (selectedValue == 'other') _inputdeskripsi(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedValue == 'other' &&
                                descriptionController.text.isEmpty) {
                              showSnackbarWarning(
                                  "Fail...",
                                  "Deskripsi masih kosong",
                                  kTextBlocker,
                                  Icon(
                                    LucideIcons.xCircle,
                                    size: 26.0,
                                    color: kTextBlocker,
                                  ));
                            } else {
                              showSnackbarWarning(
                                  "Success",
                                  "Berhasil diubah",
                                  kTextoo,
                                  Icon(
                                    LucideIcons.checkCircle2,
                                    size: 26.0,
                                    color: kTextoo,
                                  ));
                              Future.delayed(Duration(seconds: 2), (() {
                                print(selectedValue);
                                print(descriptionController);
                                updateWfa().then((value) {
                                  Navigator.pop(context); // Pop once
                                  Navigator.pop(
                                      context, 'refresh'); // Pop again
                                });
                              }));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: kButton,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Update Wfa'),
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
