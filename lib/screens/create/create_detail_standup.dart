import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailCreateStandup extends StatefulWidget {
  const DetailCreateStandup({super.key});

  @override
  State<DetailCreateStandup> createState() => _DetailCreateStandupState();
}

class _DetailCreateStandupState extends State<DetailCreateStandup> {
  @override
  final double _tinggidesc = 127;
  final double _tinggidescc = 68;

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 20, vertical: 20),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ]),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Image.asset('assets/img/profil.png'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Fauzan Alghifari',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Backend developer',
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: kTextUnselected,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_none_sharp,
                          color: kTextoo,
                        )
                      ],
                    )
                  ],
                ),
              ),
              // HERO
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.35,
                margin: EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      kTextoo,
                      kTextoo
                    ])),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.007,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Poject",
                                style: GoogleFonts.getFont('Montserrat',
                                    textStyle: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.055,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  "Buat rencana project mu dengan metode Done, Doing, Blocker",
                                  style: GoogleFonts.getFont('Montserrat',
                                      textStyle: TextStyle(
                                          fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.028,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SvgPicture.asset("assets/img/hero-image-standupdet.svg", width: MediaQuery.of(context).size.width * 0.3, height: MediaQuery.of(context).size.width * 0.3, fit: BoxFit.cover,),
                    )
                  ],
                ),
              ),

              // FORM CREATE

              const SizedBox(
                height: 20,
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(2),
                                bottomRight: Radius.circular(2),
                              ),
                              border: Border.all(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  width: 2),
                            ),
                            padding: EdgeInsets.only(
                                right: 15, left: 15, top: 10, bottom: 10),
                            height: _tinggidescc,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Project',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.montserrat(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        Text(
                                          'Approvel IMP',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        // Add more widgets as needed
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          width: 7,
                          height: _tinggidescc,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(2),
                                bottomRight: Radius.circular(2),
                              ),
                              border: Border.all(color: kTextoo, width: 2),
                            ),
                            padding: EdgeInsets.only(
                                right: 15, left: 15, top: 10, bottom: 10),
                            height: _tinggidesc,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Done',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.montserrat(
                                        color: kTextoo,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      TextField(
                                        style: GoogleFonts.montserrat(
                                          color: kBlck,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 6,
                                        decoration: InputDecoration.collapsed(
                                          hintText:
                                              "Tulis apa yang kamu telah selesaikan hari ini",
                                          hintStyle: GoogleFonts.montserrat(
                                            color: kTextUnselected,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                        Container(
                          decoration: BoxDecoration(
                            color: kTextoo,
                          ),
                          width: 7,
                          height: _tinggidesc,
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // Doing FORM

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(2),
                                bottomRight: Radius.circular(2),
                              ),
                              border: Border.all(
                                  color: Color(0xffFF7400), width: 2),
                            ),
                            padding: EdgeInsets.only(
                                right: 15, left: 15, top: 10, bottom: 10),
                            height: _tinggidesc,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Doing',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.montserrat(
                                        color: Color(0xffFF7400),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      TextField(
                                        style: GoogleFonts.montserrat(
                                          color: kTextUnselected,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 6,
                                        decoration: InputDecoration.collapsed(
                                          hintText:
                                              "Tulis apa yang masih kamu lakukan hari ini",
                                          hintStyle: GoogleFonts.montserrat(
                                            color: kTextUnselected,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFF7400),
                          ),
                          width: 7,
                          height: _tinggidesc,
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // BLOCKER FORM

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(2),
                                bottomRight: Radius.circular(2),
                              ),
                              border: Border.all(
                                  color: Color(0xffCA4343), width: 2),
                            ),
                            padding: EdgeInsets.only(
                                right: 15, left: 15, top: 10, bottom: 10),
                            height: _tinggidesc,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Blocker',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.montserrat(
                                        color: Color(0xffCA4343),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      TextField(
                                        style: GoogleFonts.montserrat(
                                          color: kTextUnselected,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 6,
                                        decoration: InputDecoration.collapsed(
                                          hintText:
                                              "Tulis apa permasalahan kamu hari ini",
                                          hintStyle: GoogleFonts.montserrat(
                                            color: kTextUnselected,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffCA4343),
                          ),
                          width: 7,
                          height: _tinggidesc,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 8),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: kTextUnselected),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Batal',
                                style: GoogleFonts.inter(
                                  color: kTextUnselected,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 8),
                                backgroundColor: kTextoo,
                                side: BorderSide(color: kTextoo),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // BACK POP
                              },
                              child: Text(
                                'Kirim',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
