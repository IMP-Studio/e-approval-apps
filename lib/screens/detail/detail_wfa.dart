import 'package:flutter/material.dart';
import 'package:imp_approval/screens/edit/edit_wfa.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:imp_approval/models/presence_model.dart';

class DetailWfa extends StatefulWidget {
  final Presences absen;
  DetailWfa({required this.absen});

  @override
  State<DetailWfa> createState() => _DetailWfaState();
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

class _DetailWfaState extends State<DetailWfa> with WidgetsBindingObserver {
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
    if (widget.absen.category == 'telework') {
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
    String url = 'https://admin.approval.impstudio.id/api/presence/get/' +
        widget.absen.serverId.toString();
    var response = await http.get(Uri.parse(url));
    print(response.body);
    return json.decode(response.body);
  }

  Future destroyPresence() async {
    String url = 'https://admin.approval.impstudio.id/api/presence/delete/' +
        widget.absen.serverId.toString();
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
    final statusAbsen = widget.absen.status?.toUpperCase();
    Widget getStatusRow(String status) {
      Color containerColor;
      Color textColor;
      String text;
      double width;

      switch (status) {
        case 'rejected':
          containerColor = const Color(0xffF9DCDC);
          textColor = const Color(0xffCA4343);
          text = 'Rejected';
          width = 0.16;
          break;
        case 'pending':
          containerColor = const Color(0xffFFEFC6);
          textColor = const Color(0xffFFC52D);
          text = 'Pending';
          width = 0.16;
          break;
        case 'preliminary':
          containerColor = const Color(0xffCAE2FF);
          textColor = const Color(0xffF4381CA);
          text = 'Preliminary';
          width = 0.20;
          break;
        case 'allowed':
          containerColor = kGreenAllow;
          textColor = kGreen;
          text = 'Allowed';
          width = 0.16;
          break;
        default:
          containerColor = Colors.grey;
          textColor = Colors.white;
          text = 'Unknown';
          width = 0.16;
      }

      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.5),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * width,
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

    String currentStatus = widget.absen.status ?? 'Unknown';

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
                        radius: MediaQuery.of(context).size.width * 0.04,
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
                            widget.absen.namaLengkap ?? 'Unknown',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.032,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.absen.posisi ?? 'Unknown',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.026,
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
                    visible: widget.absen.categoryDescription != null,
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
                            text: widget.absen.categoryDescription,
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
                    visible: widget.absen.categoryDescription != null,
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
                          DateFormat('dd MMMM yyyy').format(DateTime.parse(
                              widget.absen.date ?? '0000-00-00')),
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
                            "${widget.absen.teleworkCategory}".toUpperCase(),
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
                            formatDateTime(widget.absen.entryTime),
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
                            formatDateTime(widget.absen.exitTime),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: widget.absen.status == 'pending',
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: widget.absen.status == 'pending',
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: kTextBlocker,
                                  side: const BorderSide(
                                    color: kTextBlocker,
                                  ),
                                ),
                                onPressed: () {
                                  destroyPresence().then((value) {
                                    setState(() {
                                      Navigator.pop(context, 'refresh');
                                    });
                                    // scaffold an asli nanti gua coba0
                                  });
                                },
                                child: Text(
                                  "Delete",
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Visibility(
                              visible: widget.absen.status == 'pending',
                              child: FutureBuilder(
                                future: editPresence(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return Shimmer.fromColors(
                                        baseColor: kButton.withOpacity(0.8),
                                        highlightColor:
                                            kButton.withOpacity(0.5),
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                kButton.withOpacity(0.8),
                                            side: BorderSide(
                                              color: kButton.withOpacity(0.8),
                                            ),
                                          ),
                                          onPressed:
                                              null, // disables the button
                                          child: const Text("Edit"),
                                        ),
                                      );
                                    } else {
                                      return OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: kButton,
                                          side: const BorderSide(
                                            color: kButton,
                                          ),
                                        ),
                                        onPressed: () async {
                                          // ignore: unused_local_variable
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditWfa(
                                                  absen: snapshot.data['data']),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Edit",
                                          style: GoogleFonts.montserrat(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: kButton.withOpacity(0.8),
                                      highlightColor: kButton.withOpacity(0.5),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              kButton.withOpacity(0.8),
                                          side: BorderSide(
                                            color: kButton.withOpacity(0.8),
                                          ),
                                        ),
                                        onPressed: null, // disables the button
                                        child: const Text("Edit"),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.absen.status == 'pending',
                        child: SizedBox(
                          height: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Visibility(
                    visible: widget.absen.status == 'rejected' ||
                        widget.absen.status == 'allowed',
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                    
                              bottom:
                                  MediaQuery.of(context).size.height * 0.03),
                          width: MediaQuery.of(context).size.width * 1 / 1.12,
                          height: 1,
                          color: const Color(0xffC2C2C2).withOpacity(0.30),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Approver Name',
                                          style: GoogleFonts.montserrat(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.040,
                                            color: blueText,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text('Status : ${statusAbsen}',
                                          style: GoogleFonts.montserrat(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.030,
                                            color: greyText,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '“',
                                        style: GoogleFonts.montserrat(
                                          color: kPrimary,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.039,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.absen.statusDescription ??
                                            '-',
                                        style: GoogleFonts.montserrat(
                                          color: greyText,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.039,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '”',
                                        style: GoogleFonts.montserrat(
                                          color: kPrimary,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.039,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        )
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
