import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/detail/detail_absensi.dart';

class HistoryAttendance extends StatefulWidget {
  const HistoryAttendance({super.key});

  @override
  State<HistoryAttendance> createState() => _HistoryAttendanceState();
}

class _HistoryAttendanceState extends State<HistoryAttendance>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime date = DateTime.now();

  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _jadwalContainer() {
    return GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => DetailAbsensi(),
          //     ));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.only(right: 10, left: 10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 99,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4.0,
                            spreadRadius: 0.0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 5, right: 5),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          height: 2,
                                          width: 20,
                                          color: blueText,
                                        ),
                                      ),
                                      Text('July 16th, 2023',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            color: blueText,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      Row(
                                        children: [
                                          Text('00:00 ',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              )),
                                          Text('Total hours',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: VerticalDivider(
                                      color: Colors.black,
                                      thickness: 1,
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 5,
                                          left: 5,
                                        ),
                                        child: Container(
                                          height: 2,
                                          width: 20,
                                          color: blueText,
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text('Check in',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 8,
                                                      color: blueText,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                Text('08:00 AM',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              children: [
                                                Text('Check out',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 8,
                                                      color: blueText,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                Text('08:00 AM',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ],
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
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Color(0xffD9D9D9).withOpacity(0.15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                                top: 10,
                                right: 5,
                                left: 5,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Rejected by',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 8,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  Text('HR',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 8,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ],
                              ),
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 0),
                padding: const EdgeInsets.only(left: 30, right: 30),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(35, 36, 109, 193),
                        Color.fromARGB(43, 36, 109, 193)
                      ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Divider(
                        color: Color.fromRGBO(67, 129, 202, 1),
                        thickness: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: Text(
                        "Riwayat kehadiran",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "You haven’t do a stand up today !",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Color.fromRGBO(67, 129, 202, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: kToolbarHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: kTextoo,
                      unselectedLabelColor: kTextUnselected,
                      tabs: [
                        Tab(
                          child: Text(
                            "WFA",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "PERJADIN",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "WFO",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(fontSize: 12.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 20, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Find by',
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        )),
                    Padding(padding: EdgeInsets.only(right: 8)),
                    //  Text( "${date.year}/${date.month}/${date.day},"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kButton,
                      ),
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (newDate == null) return;

                        setState(() => date = newDate);
                      },
                      child: Text(
                        'Date',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 280, 
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Column(
                      children: [
                        _jadwalContainer(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
