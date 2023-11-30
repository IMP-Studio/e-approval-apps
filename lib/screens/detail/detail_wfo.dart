import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:imp_approval/models/presence_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class DetailWfo extends StatefulWidget {
  final Presences absen;
  DetailWfo({required this.absen});

  @override
  State<DetailWfo> createState() => _DetailWfoState();
}

class _DetailWfoState extends State<DetailWfo> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    calculateDistance();
  }

  Widget _category(BuildContext context) {
    if (widget.absen.category == 'WFO') {
      return Text('Work From Office',
          style: GoogleFonts.montserrat(
            fontSize: MediaQuery.of(context).size.width * 0.039,
            color: kTextgrey,
            fontWeight: FontWeight.w600,
          ));
    } else {
      return const Text('Unknown category');
    }
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

  String distanceText = '';

 Future<void> calculateDistance() async {
  final Distance distance = Distance();

  final LatLng point1 = LatLng(-6.332826, 106.864530);

  final LatLng point2 = LatLng(
    double.parse(widget.absen.latitude ?? '-6.332835026352704'),
    double.parse(widget.absen.longitude ?? '106.86452087283757'),
  );

  double distanceInMeters = distance(point1, point2);

  print('Target Coordinates: ${point2.latitude}, ${point2.longitude}');
  print('Distance: ${distanceInMeters.toStringAsFixed(2)} meters');
  distanceText = '${distanceInMeters.toStringAsFixed(2)}';
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
                            widget.absen.namaLengkap ?? 'Unknown',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.absen.posisi ?? 'Unknown',
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
                                border: Border.all(width: 0.8, color: kGreen),
                                color: kGreenAllow,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.030)),
                            child: Text(
                              "Allowed",
                              style: GoogleFonts.getFont("Montserrat",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.025,
                                  color: kGreen,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 10, left: 20, right: 30),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Work From Office',
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.044,
                                color: kTextoo,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Text(
                                  DateFormat('dd MMMM yyyy').format(
                                      DateTime.parse(
                                          widget.absen.date ?? '0000-00-00')),
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.030,
                                    color: greyText,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.08,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Distance",
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.024,
                                  fontWeight: FontWeight.w600,
                                  color: kTextUnselected,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.006,
                              ),
                              if (distanceText.isEmpty)
                                CircularProgressIndicator()
                              else
                                Text(
                                  '${distanceText} Meter',
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.045,
                          ),
                          Container(
                            width: 1,
                            height: MediaQuery.of(context).size.width * 0.07,
                            decoration: const BoxDecoration(color: kTextoo),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.045,
                          ),
                          // Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "IN",
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.024,
                                  fontWeight: FontWeight.w600,
                                  color: kTextUnselected,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.006,
                              ),
                              Text(
                                formatDateTime(
                                    widget.absen.entryTime ?? '00:00'),
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.065,
                          ),
                          Container(
                            width: 1,
                            height: MediaQuery.of(context).size.width * 0.07,
                            decoration: const BoxDecoration(color: kTextoo),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.065,
                          ),
                          // Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Out",
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.024,
                                  fontWeight: FontWeight.w600,
                                  color: kTextUnselected,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.006,
                              ),
                              Text(
                                formatDateTime(
                                    widget.absen.exitTime ?? '00:00'),
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
            Container(
              width: double.infinity,
              height: 180.0,
              decoration: const BoxDecoration(
                  // boxShadow: [
                  //   BoxShadow(
                  //       blurRadius: 4,
                  //       offset: Offset(0, 1),
                  //       color: Colors.black.withOpacity(0.25))
                  // ],
                  border: Border(
                      top: BorderSide(color: Color(0xffD9D9D9), width: 0.5),
                      bottom: BorderSide(
                          color: Color(
                            0xffD9D9D9,
                          ),
                          width: 0.5)),
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/img/map1.jpg',
                      ),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            widget.absen.emergencyDescription == null
                ? Center(
                    child: Column(
                      children: [
                        Container(
                          child: SvgPicture.asset(
                            "assets/img/emergency-desc.svg",
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 6, bottom: 10),
                          child: Text('Tidak ada deskripsi',
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.039,
                                color: kTextgrey,
                                fontWeight: FontWeight.w600,
                              )),
                        )
                      ],
                    ),
                  )
                : Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text('Deskripsi Darurat',
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.044,
                                color: kTextgrey,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '“',
                                style: GoogleFonts.montserrat(
                                  color: kPrimary,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.034,
                                ),
                              ),
                              TextSpan(
                                text: widget.absen.emergencyDescription,
                                style: GoogleFonts.montserrat(
                                  color: greyText,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.034,
                                ),
                              ),
                              TextSpan(
                                text: '”',
                                style: GoogleFonts.montserrat(
                                  color: kPrimary,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.034,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
