import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/screens/cuti.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';

class CreateCuti extends StatefulWidget {
  final Map profile;
  const CreateCuti({super.key, required this.profile});

  @override
  State<CreateCuti> createState() => _CreateCutiState();
}

class _CreateCutiState extends State<CreateCuti> {
  String selectedOption = '';
  // date
  DateTime? _mulaiTanggal;
  DateTime? _selesaiTanggal;
  DateTime? _tanggalMasuknya;

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  TextEditingController mulai_cuti = TextEditingController();
  TextEditingController akhir_cuti = TextEditingController();
  TextEditingController tanggal_masuk = TextEditingController();
  TextEditingController alasan = TextEditingController();

  final List<String> jenisItems = [
    'Tahunan',
    'Khusus',
    'Darurat',
  ];

  String? selectedValue;

  Future storeCuti() async {
    if (_mulaiTanggal == null || _selesaiTanggal == null) {
      print("Error: Start or end date not selected.");
      return;
    }

    final response = await http.post(
        Uri.parse('https://04f1-103-195-58-163.ngrok-free.app/api/cuti/store'),
        body: {
          "user_id": widget.profile['user_id'].toString(),
          "jenis_cuti": selectedValue,
          "tanggal_pemohonan": DateTime.now().toIso8601String(),
          "jumlah_hari_cuti": (_selesaiTanggal!
                      .difference(_mulaiTanggal!)
                      .inDays +
                  1)
              .toString(), // This calculates the days difference and adds 1 to include both start and end dates
          "tanggal_mulai": formatDate(_mulaiTanggal!),
          "tanggal_akhir": formatDate(_selesaiTanggal!),
          "tanggal_masuk": formatDate(_tanggalMasuknya!),
          "alasan": alasan.text,
          "status": 'PENDING',
        });

    print(response.body);
    return json.decode(response.body);
  }

  int computeTotalCuti() {
    if (_mulaiTanggal != null && _selesaiTanggal != null) {
      return _selesaiTanggal!.difference(_mulaiTanggal!).inDays + 1;
    }
    return 0; // Return 0 if any of the dates is null
  }

  // date
  Future<void> _memulaiTanggal() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _mulaiTanggal ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _mulaiTanggal = newDate;
      });
    }
  }

  Future<void> _tanggalMasuk() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _tanggalMasuknya ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _tanggalMasuknya = newDate;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  LucideIcons.chevronLeft,
                  color: kButton,
                ),
              ),
              Text(
                'Kembali',
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  color: kButton,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Align(
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              Container(
                padding: const EdgeInsets.only(left: 3, right: 30),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Divider(
                        color: Color.fromRGBO(67, 129, 202, 1),
                        thickness: 2,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Permintaan",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          "Cuti",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Color.fromRGBO(67, 129, 202, 1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        "Permintaan akan di proses oleh HT & Management",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Jenis Cuti',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
                  'Pilih jenis cuti',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: kTextgrey,
                  ),
                ),
                items: jenisItems
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
                    return 'Pilih jenis cuti.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.only(top: 25, bottom: 5)),
                  Row(
                    children: [
                      Text(
                        'Tanggal',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
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
                        onPressed: _memulaiTanggal,
                        child: Row(
                          children: [
                            Text(
                              _mulaiTanggal != null
                                  ? "${_mulaiTanggal!.year}/${_mulaiTanggal!.month}/${_mulaiTanggal!.day}"
                                  : 'Mulai cuti',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: kTextgrey,
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
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
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
                              _selesaiTanggal != null
                                  ? "${_selesaiTanggal!.year}/${_selesaiTanggal!.month}/${_selesaiTanggal!.day}"
                                  : 'Akhir cuti',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: kTextgrey,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(top: 10)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                    onPressed: _tanggalMasuk,
                    child: Row(
                      children: [
                        Text(
                          _tanggalMasuknya != null
                              ? "${_tanggalMasuknya!.year}/${_tanggalMasuknya!.month}/${_tanggalMasuknya!.day}"
                              : 'Tanggal Masuk',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: kTextgrey,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.calendar_today,
                          color: kBorder,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25)),
                  Row(
                    children: [
                      Text(
                        'Alasan',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
                  Padding(padding: EdgeInsets.only(bottom: 5)),
                  TextField(
                    controller: alasan,
                    style: GoogleFonts.montserrat(color: kText),
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    scrollPhysics: ScrollPhysics(),
                    decoration: InputDecoration(
                      hintText: 'Write description...',
                      hintStyle: GoogleFonts.montserrat(
                          color: kBorder,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Total Cuti : ${computeTotalCuti()} hari',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                storeCuti().then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CutiScreen()));
                                  // Navigator.pop(context);
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: kButton,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text('Ajukan Cuti'),
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
