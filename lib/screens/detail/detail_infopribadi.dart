import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class InformasiPribadi extends StatefulWidget {
  const InformasiPribadi({super.key});

  @override
  State<InformasiPribadi> createState() => _InformasiPribadiState();
}

class _InformasiPribadiState extends State<InformasiPribadi> with WidgetsBindingObserver{

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
    });
  }

  String formatDateRange(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    String formattedStartDay = DateFormat('d').format(start);
    String formattedEndDay = DateFormat('d').format(end);
    String formattedMonth =
        DateFormat('MMMM').format(start); // e.g., "November"
    String formattedYear = DateFormat('y').format(start); // e.g., "2023"

    return '$formattedStartDay-$formattedEndDay $formattedMonth $formattedYear';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground3,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: kButton,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LucideIcons.chevronLeft),
        ),
        title: Text(
          'Informasi Pribadi',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                // nama depan
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Text('Nama Depan',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: kTextgrey,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text('${preferences?.getString('first_name')}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      
                // nama belakang
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Text('Nama Belakang',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: kTextgrey,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text('${preferences?.getString('last_name')}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      
                // divisi
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Text('Divisi',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: kTextgrey,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text('${preferences?.getString('divisi')}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                            const Spacer(),
                            const Icon(
                              LucideIcons.briefcase,
                              color: kBorder,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // divisi
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Text('Posisi',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: kTextgrey,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text('${preferences?.getString('posisi')}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                            const Spacer(),
                            const Icon(
                              LucideIcons.briefcase,
                              color: kBorder,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // staff id
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Text('Staff ID',
                            style: GoogleFonts.montserrat(
                              fontSize: MediaQuery.of(context).size.width * 0.035,
                              color: kTextgrey,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text('${preferences?.getString('id_number')}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      
                // jeniskelamin
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Text('Jenis Kelamin',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: kTextgrey,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            preferences?.getString('gender') == 'male'
                            ? Text('Laki - laki',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ))
                            : Text('Perempuan',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                            const Spacer(),
                            const Icon(
                              LucideIcons.users,
                              color: kBorder,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ulang tahun
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Text('Tanggal Lahir',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: kTextgrey,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text(
                               '${preferences?.getString('birth_date')}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                            // Spacer(),
                            // Icon(
                            //   LucideIcons.gift,
                            //   color: kBorder,
                            //   size: 18,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
