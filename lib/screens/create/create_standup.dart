import 'package:flutter/material.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/screens/create/create_detail_standup.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CreateStandup extends StatefulWidget {
  const CreateStandup({super.key});

  @override
  State<CreateStandup> createState() => _CreateStandupState();
}

class _CreateStandupState extends State<CreateStandup> {
  @override
  final double _tinggidesc = 68;
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
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.chevronLeft,
                      color: kButton,
                    ),
                    Text(
                      'Kembali',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: kButton,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Icon(
                  LucideIcons.briefcase,
                  color: Color.fromRGBO(67, 129, 202, 1),
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              // HERO
              Container(
                width: double.infinity,
                height: 130,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color.fromARGB(35, 36, 109, 193),
                      Color.fromARGB(43, 36, 109, 193)
                    ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Container(
                              width: 50.0,
                              height: 3.0,
                              decoration: BoxDecoration(
                                  color: kTextoo,
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          Text(
                            "Project",
                            style: GoogleFonts.getFont('Montserrat',
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: kBlck)),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Buat rencana project mu dengan metode Done,Doing, Blocker.",
                            style: GoogleFonts.getFont('Montserrat',
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: kTextoo)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // FORM CREATE

              const SizedBox(
                height: 20,
              ),

              // NAMA PROJECT

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                           onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateDetailStandup(),
                                ));
                          },
                          child: Container(
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
                              height: _tinggidesc,
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
                                            'Kementrian Agama Islam',
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
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          width: 7,
                          height: _tinggidesc,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateDetailStandup(),
                                ));
                          },
                          child: Container(
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
                              height: _tinggidesc,
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
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
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
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          width: 7,
                          height: _tinggidesc,
                        ),
                      ],
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
