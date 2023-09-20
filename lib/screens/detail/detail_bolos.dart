import 'package:flutter/material.dart';
import 'package:imp_approval/screens/edit/edit_wfa.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
class DetailBolos extends StatefulWidget {
  final dynamic absen;
  DetailBolos({required this.absen});

  @override
  State<DetailBolos> createState() => _DetailBolosState();
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

class _DetailBolosState extends State<DetailBolos> {
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
          textColor =
              const Color(0xffCA4343); // Or any color that matches well with red.
          text = 'Rejected';
          break;
        case 'pending':
          containerColor = const Color(0xffFFEFC6);
          textColor =
              const Color(0xffFFC52D); // Black usually matches well with yellow.
          text = 'Pending';
          break;
        case 'allow_HT':
          containerColor = const Color(0xffFFEFC6);
          textColor =
              const Color(0xffFFC52D); // Black usually matches well with yellow.
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
                    color: kButton,
                    size: MediaQuery.of(context).size.width * 0.050,
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
                      'Detail',
                      style: GoogleFonts.montserrat(
                        fontSize: MediaQuery.of(context).size.width * 0.070,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
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
                  margin: const EdgeInsets.only(top: 20, bottom: 13),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5.5),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.16,
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.8, color: Color(0xffCA4343)),
                                color: Color(0xffF9DCDC),
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.030)),
                            child: Text(
                              "Bolos",
                              style: GoogleFonts.getFont("Montserrat",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.025,
                                  color: Color(0xffCA4343),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                
              ],
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  Container(
                    child:  SvgPicture.asset(
                            "assets/img/bolos.svg",
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.7,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                   Container(
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sayang sekali kamu ',
                          style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                        ),
                        Text(
                          'Bolos',
                          style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                              color: Color(0xffCA4343),
                              fontWeight: FontWeight.w600,
                            ),
                        )
                      ],
                    )
                  ),
                   Container(
                    margin: EdgeInsets.only(top: 1.5),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tidak ada keterangan.',
                          style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            Container(
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Detail waktu : ',
                          style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: Color(0xff727272),
                              fontWeight: FontWeight.w600,
                            ),
                        ),
                        Text(
                          DateFormat('EEEE, dd MMMM yyyy').format(
                              DateTime.parse(widget.absen['date']) ??
                                  DateTime.now()),
                          style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: Color(0xff727272),
                              fontWeight: FontWeight.w600,
                            ),
                        )
                      ],
                    )
                  ),
          ],
        ),
      ),
    );
  }
}
