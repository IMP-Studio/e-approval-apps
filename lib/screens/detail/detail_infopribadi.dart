import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/screens/detail/detail_infopribadi.dart';

class InformasiPribadi extends StatefulWidget {
  const InformasiPribadi({super.key});

  @override
  State<InformasiPribadi> createState() => _InformasiPribadiState();
}

class _InformasiPribadiState extends State<InformasiPribadi> {
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
          icon: Icon(LucideIcons.chevronLeft),
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              // nama depan
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
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
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text('Fauzan',
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
                padding: EdgeInsets.only(top: 14, bottom: 5),
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
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text('Ghifari',
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
                padding: EdgeInsets.only(top: 14, bottom: 5),
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
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text('Back End Developer',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          Spacer(),
                          Icon(
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

              // jeniskelamin
              Padding(
                padding: EdgeInsets.only(top: 14, bottom: 5),
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
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text('laki-Laki',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          Spacer(),
                          Icon(
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
                padding: EdgeInsets.only(top: 14, bottom: 5),
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
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text('08 August 2006',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          Spacer(),
                          Icon(
                            LucideIcons.gift,
                            color: kBorder,
                            size: 18,
                          ),
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
    );
  }
}
