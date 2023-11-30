import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class DetailRequestWfa extends StatefulWidget {
  final dynamic absen;
  DetailRequestWfa({required this.absen});

  @override
  State<DetailRequestWfa> createState() => _DetailRequestWfaState();
}

Widget _modalvalidasireject(BuildContext context) {
  return CupertinoAlertDialog(
    title: Text("Alasan Menolak",
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        )),
    actions: [
      CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Batal",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: kTextBlocker,
                fontWeight: FontWeight.w600,
              ))),
      CupertinoDialogAction(
          onPressed: () {},
          child: Text("Kirim",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ))),
    ],
    content: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.010,
        ),
        CupertinoTextField(
          padding: const EdgeInsets.symmetric(vertical: 20),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          placeholder: 'ketikan sesuatu....',
          placeholderStyle: GoogleFonts.montserrat(
            fontSize: 14,
            color: kTextgrey,
            fontWeight: FontWeight.w500,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    ),
  );
}

class _DetailRequestWfaState extends State<DetailRequestWfa>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Widget _category(BuildContext context) {
    if (widget.absen['category'] == 'telework') {
      return Text('Work From Anywhere',
          style: GoogleFonts.montserrat(
            fontSize: MediaQuery.of(context).size.width * 0.040,
            color: blueText,
            fontWeight: FontWeight.w600,
          ));
    } else {
      return const Text('Unknown category');
    }
  }

  Future editPresence() async {
    String url = 'https://testing.impstudio.id/approvall/api/presence/get/' +
        widget.absen['id'].toString();
    var response = await http.get(Uri.parse(url));
    print(response.body);
    return json.decode(response.body);
  }

  Future destroyPresence() async {
    String url = 'https://testing.impstudio.id/approvall/api/presence/delete/' +
        widget.absen['id'].toString();
    var response = await http.delete(Uri.parse(url));
    print(response.body);
    return json.decode(response.body);
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

  @override
  Widget build(BuildContext context) {
    Widget getStatusRow(String status) {
      Color containerColor;
      Color textColor;
      String text;

      switch (status) {
        case 'rejected':
          containerColor = const Color(0xffF9DCDC);
          textColor = const Color(
              0xffCA4343); // Or any color that matches well with red.
          text = 'Rejected';
          break;
        case 'pending':
          containerColor = const Color(0xffFFEFC6);
          textColor = const Color(
              0xffFFC52D); // Black usually matches well with yellow.
          text = 'Pending';
          break;
        case 'preliminary':
          containerColor = const Color(0xffFFEFC6);
          textColor = const Color(
              0xffFFC52D); // Black usually matches well with yellow.
          text = 'Pending';
          break;
        case 'allowed':
          containerColor = kGreenAllow; // Assuming kGreenAllow is green
          textColor = kGreen; // Your green color for text
          text = 'Allowed';
          break;
        default:
          containerColor = Colors.grey;
          textColor = Colors.white;
          text = 'Unknown Status';
      }

      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.5),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.16,
            decoration: BoxDecoration(
                border: Border.all(width: 0.8, color: textColor),
                color: containerColor,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.030)),
            child: Text(
              text,
              style: GoogleFonts.getFont("Montserrat",
                  fontSize: MediaQuery.of(context).size.width * 0.025,
                  color: textColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }

    String currentStatus = widget.absen['status'];

    // ignore: unused_local_variable
    Widget statusWidget = getStatusRow(currentStatus);

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
                  Icon(
                    LucideIcons.chevronLeft,
                    size: MediaQuery.of(context).size.width * 0.050,
                    color: kButton,
                  ),
                  Text(
                    'Kembali',
                    style: GoogleFonts.montserrat(
                      fontSize: MediaQuery.of(context).size.width * 0.0345,
                      fontWeight: FontWeight.w400,
                      color: kTextoo,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.userCheck,
                size: MediaQuery.of(context).size.width * 0.06,
                color: kTextoo,
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Detail ',
                      style: GoogleFonts.montserrat(
                        fontSize: MediaQuery.of(context).size.width * 0.070,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Attendance',
                      style: GoogleFonts.montserrat(
                        color: kTextoo,
                        fontSize: MediaQuery.of(context).size.width * 0.070,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  width: 70,
                  height: 2,
                  color: kTextoo,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: kBorder, width: 1),
                    top: BorderSide(color: kBorder, width: 1),
                  )),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.05,
                        backgroundImage: const AssetImage(
                          "assets/img/profil2.png",
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.028,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.absen['nama_lengkap'],
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.absen['posisi'],
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: greyText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      getStatusRow(currentStatus)
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: widget.absen['category_description'] != null,
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '“',
                            style: GoogleFonts.montserrat(
                              color: kPrimary,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                            ),
                          ),
                          TextSpan(
                            text: widget.absen['category_description'],
                            style: GoogleFonts.montserrat(
                              color: greyText,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                            ),
                          ),
                          TextSpan(
                            text: '”',
                            style: GoogleFonts.montserrat(
                              color: kPrimary,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.absen['category_description'] != null,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.028,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Work From Anywhere',
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.044,
                            color: kTextoo,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                          DateFormat('dd MMMM yyyy').format(
                              DateTime.parse(widget.absen['date'])),
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.030,
                            color: greyText,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "TYPE",
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w600,
                              color: kTextUnselected,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.006,
                          ),
                          Text(
                            "${widget.absen['telework_category']}"
                                .toUpperCase(),
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.045,
                      // ),
                      const Spacer(),
                      Container(
                        width: 1,
                        height: MediaQuery.of(context).size.width * 0.07,
                        decoration: const BoxDecoration(color: kTextoo),
                      ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.045,
                      // ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "IN",
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w600,
                              color: kTextUnselected,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.006,
                          ),
                          Text(
                            formatDateTime(widget.absen['entry_time']),
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.065,
                      // ),
                      const Spacer(),
                      Container(
                        width: 1,
                        height: MediaQuery.of(context).size.width * 0.07,
                        decoration: const BoxDecoration(color: kTextoo),
                      ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.065,
                      // ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Out",
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w600,
                              color: kTextUnselected,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.006,
                          ),
                          Text(
                            formatDateTime(widget.absen['exit_time']),
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
