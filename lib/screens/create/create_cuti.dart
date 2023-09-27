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
import 'package:flutter/services.dart';

class CreateCuti extends StatefulWidget {
  final Map profile;
  const CreateCuti({super.key, required this.profile});

  @override
  State<CreateCuti> createState() => _CreateCutiState();
}

class _CreateCutiState extends State<CreateCuti> with WidgetsBindingObserver{
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance!.addObserver(this);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
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
  final List<String> valueItem = [
    'yearly',
    'exclusive',
    'emergency',
  ];

  String? selectedValue;

  Future storeCuti() async {
    if (_mulaiTanggal == null || _selesaiTanggal == null) {
      print("Error: Start or end date not selected.");
      return;
    }

    final response = await http.post(
        Uri.parse('https://testing.impstudio.id/approvall/api/leave/store'),
        body: {
          "user_id": widget.profile['user_id'].toString(),
          "type": selectedValue,
          "submission_date": DateTime.now().toIso8601String(),
          "total_leave_days":
              (_selesaiTanggal!.difference(_mulaiTanggal!).inDays + 1)
                  .toString(),
          "start_date": formatDate(_mulaiTanggal!),
          "end_date": formatDate(_selesaiTanggal!),
          "entry_date": formatDate(_tanggalMasuknya!),
          "type_description": alasan.text,
          "status": widget.profile['permission'] == 'ordinary_employee' ? 'pending' : 'allow_HT',
        });

    print(response.body);
    return json.decode(response.body);
  }

  int computeTotalCuti() {
    if (_mulaiTanggal != null && _selesaiTanggal != null) {
      return _selesaiTanggal!.difference(_mulaiTanggal!).inDays + 1;
    }
    return 0;
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
          backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
                          "Permintaan",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Cuti",
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
              const SizedBox(
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
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
  items: List.generate(jenisItems.length, (index) {
    return DropdownMenuItem<String>(
      value: valueItem[index], // Use value from valueItem based on the index.
      child: Text(
        jenisItems[index],
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }),
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
  icon: const Icon(LucideIcons.arrowDownCircle,
      color: Color(0xffB6B6B6), size: 17),
),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 18, bottom: 5)),
                  Row(
                    children: [
                      Text(
                        'Tanggal',
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
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 15),
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
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
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: kTextgrey,
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
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
                                    : 'Akhir cuti',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: kTextgrey,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
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
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: kTextgrey,
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
                  const Padding(padding: EdgeInsets.only(top: 18)),
                  Row(
                    children: [
                      Text(
                        'Deskripsi',
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
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  TextField(
                    controller: alasan,
                    style: GoogleFonts.montserrat(color: kText),
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    scrollPhysics: const ScrollPhysics(),
                    decoration: InputDecoration(
                      hintText: 'Ketikan sesuatu...',
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: kTextgrey,
                      ),
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
                    padding: const EdgeInsets.only(top: 8),
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
                          width: 110,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                storeCuti().then((value) {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => CutiScreen()));
                                  Navigator.pop(context);
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: kButton,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
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
