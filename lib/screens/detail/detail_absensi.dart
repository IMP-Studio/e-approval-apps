import 'package:flutter/material.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class DetailAbsensi extends StatefulWidget {
  final Map absen;
  const DetailAbsensi({super.key, required this.absen});

  @override
  State<DetailAbsensi> createState() => _DetailAbsensiState();
}

class _DetailAbsensiState extends State<DetailAbsensi> {
  final double _tinggidesc = 70;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: blueText,
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                //CHECK ATTEDANCE
                const SizedBox(
                  height: 30,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 100 / 2,
                      child: Icon(
                        Icons.check_rounded,
                        color: blueText,
                        size: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    Text(
                      'ATTENDANCE COMPLETED',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: whiteText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 40),

                      width: MediaQuery.of(context)
                          .size
                          .width, // Use width here, not height
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Fauzan Alghifari',
                                style: GoogleFonts.montserrat(
                                  color: Color(0xff3E3E3E),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'August 18th, 2023',
                                style: GoogleFonts.montserrat(
                                  color: greyText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 200,
                            child: Divider(
                              color: Colors.black.withOpacity(0.1),
                              indent: 1,
                              thickness: 2,
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Jenis Kehadiran

                                      Row(
                                        children: [
                                          Text(
                                            'Jenis',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                              color: Color(0xffB6B6B6),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),

                                      const SizedBox(height: 5),

                                      Row(
                                        children: [
                                          Text(
                                            'PERJADIN',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                              color: blueText,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),

                                      // check in

                                      const SizedBox(
                                        height: 18,
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            'Check In',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                              color: Color(0xffB6B6B6),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),

                                      const SizedBox(height: 5),

                                      Row(
                                        children: [
                                          Text(
                                            '08.00 AM',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                              color: blueText,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //     width: MediaQuery.of(context).size.width /
                                //         2 /
                                //         3),

                                const Spacer(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Kategori',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                              color: Color(0xffB6B6B6),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),

                                      const SizedBox(height: 5),

                                      Row(
                                        children: [
                                          Text(
                                            'Kesehatan',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                              color: blueText,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),

                                      // check in

                                      const SizedBox(
                                        height: 18,
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            'Check Out',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                              color: Color(0xffB6B6B6),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),

                                      const SizedBox(height: 5),

                                      Row(
                                        children: [
                                          Text(
                                            '06.00 PM',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                              color: blueText,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Surat Perjadin',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                              color: Color(0xffB6B6B6),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xffEEEEEE),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              'PERJADIN.pdf',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.montserrat(
                                                color: greyText,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '2MB',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.montserrat(
                                                color: Color(0xffB6B6B6),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
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

                          const SizedBox(
                            height: 18,
                          ),

                          // deskripsi

                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xffEEEEEE),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(2),
                                              bottomRight: Radius.circular(2),
                                            ),
                                          ),
                                          padding: EdgeInsets.only(
                                              right: 15, left: 25),
                                          height: _tinggidesc,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Description',
                                                    textAlign: TextAlign.left,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: greyText,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Saya ingin melakukan perjalanan dinas ke depok timur, dengan arahan untuk mencoba ini itu',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color:
                                                            greyText, // Adjust color as needed
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: blueText,
                                        ),
                                        width: 15,
                                        height: _tinggidesc,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: blueText),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Back',
                                      style: GoogleFonts.inter(
                                        color: blueText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          )),
        ));
  }
}
