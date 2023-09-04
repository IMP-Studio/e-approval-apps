import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui_web' as ui;


class HistoryAttendance extends StatefulWidget {
  const HistoryAttendance({super.key});
  

  @override
  State<HistoryAttendance> createState() => _HistoryAttendanceState();
}

class _HistoryAttendanceState extends State<HistoryAttendance>
    with SingleTickerProviderStateMixin {
      

      
  int activeIndex = 0;
  late TabController _tabController;
  DateTime date = DateTime.now();
  bool isButtonVisible = true;

  void hideButton() {
    if (isButtonVisible) {
      setState(() {
        isButtonVisible = false;
      });
    }
  }

  void showButton() {
    if (!isButtonVisible) {
      setState(() {
        isButtonVisible = true;
      });
    }
  }

  void startTimer() {
    // Start a timer to hide the button after 4 seconds of inactivity
    Duration duration = Duration(seconds: 4);
    Future.delayed(duration, hideButton);
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    startTimer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDatePickerModal() {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return DatePickerModal(
          onDateSelected: (selectedDate) {
            // Handle the selected date here as needed
            print("Selected date: $selectedDate");
          },
          tabController: _tabController,
          // buildContent: buildContent,
        );
      },
    );
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
                                          color: kTextoo,
                                        ),
                                      ),
                                      Text('July 16th, 2023',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            color: kTextoo,
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
                                          color: kTextoo,
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
                                                      color: kTextoo,
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
                                                      color: kTextoo,
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
      home: GestureDetector(
        onTap: () {
          showButton();
          startTimer();
        },
        onVerticalDragUpdate: (details) {
          showButton();
          startTimer();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: ListView(
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
                                  color: kTextBlcknw,
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
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.35,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [kTextoo, kTextoo])),
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
                                  "Riwayat Absensi",
                                  style: GoogleFonts.getFont('Montserrat',
                                      textStyle: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.055,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    "Work From Anywhere, Pekerjaan Dinas, Work From Office",
                                    style: GoogleFonts.getFont('Montserrat',
                                        textStyle: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                        child: SvgPicture.asset(
                          "images/hero-image-ha.svg",
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.3,
                          fit: BoxFit.cover,
                        ),
                      )
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
          floatingActionButton: isButtonVisible
              ? Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 110.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                          color: kTextoo,
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Filter",
                          style: GoogleFonts.getFont('Montserrat',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        height: 45,
                        width: 45,
                        child: FloatingActionButton(
                          onPressed: _showDatePickerModal,
                          child: Icon(LucideIcons.slidersHorizontal),
                          backgroundColor: kTextooAgakGelap,
                          elevation: 0,
                          hoverElevation: 0,
                        ),
                      ),
                    ),
                  ],
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
}

class DatePickerModal extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final TabController tabController;

  DatePickerModal({
    required this.onDateSelected,
    required this.tabController,
  });

  @override
  _DatePickerModalState createState() => _DatePickerModalState();
}

class _DatePickerModalState extends State<DatePickerModal> {
  DateTime? selectedDate1;
  DateTime? selectedDate2;

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 10),
            width: 60,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.width * 0.012,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Search",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.012,
              ),
              Text(
                "Filter",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  color: kTextoo,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Start Date",
                        style: GoogleFonts.getFont('Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width * 0.028,
                            color: kBlck),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.02,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: kBlck,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      _showDatePicker(selectedButton: 1);
                    },
                    child: Row(
                      children: [
                        Text(
                          _getButtonText(selectedDate1),
                          style: GoogleFonts.getFont('Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: kBlck),
                        ),
                        Spacer(),
                        Icon(
                          LucideIcons.calendarDays,
                          color: kTextoo,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "End Date",
                        style: GoogleFonts.getFont('Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width * 0.028,
                            color: kBlck),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.02,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: kBlck,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      _showDatePicker(selectedButton: 2);
                    },
                    child: Row(
                      children: [
                        Text(_getButtonText(selectedDate2),
                            style: GoogleFonts.getFont('Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.028,
                                color: kBlck)),
                        Spacer(),
                        Icon(
                          LucideIcons.calendarDays,
                          color: kTextoo,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.015,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IndexedStack(
                          index: widget.tabController.index,
                          children: [buildContent()],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.04,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kTextoo,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: kTextoo,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: ()  {
                      
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Apply Filter',
                          style: GoogleFonts.getFont('Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.033,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: kTextoo,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: ()  {
                      
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Cancel',
                          style: GoogleFonts.getFont('Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: kTextoo),
                        )
                      ],
                    ),
                    
                  ),
                  
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.89,
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SizedBox(
          //   width: 15.0,
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 0;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.065, vertical: 8),
              decoration: BoxDecoration(
                color:
                    activeIndex == 0 ? kTextoo : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: activeIndex == 0 ? kTextoo : kBlck,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "Semua",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.034,
                      color: activeIndex == 0 ? Colors.white : kBlck,
                      fontWeight:
                          activeIndex == 0 ? FontWeight.w600 : FontWeight.w600),
                ),
              )),
            ),
          ),
          Divider(),
          // SizedBox(
          //   width: 15.0,
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.065, vertical: 8),
              decoration: BoxDecoration(
                color:
                    activeIndex == 1 ? kTextoo : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: activeIndex == 1 ? kTextoo : kBlck,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "WFA",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.034,
                      color: activeIndex == 1 ? Colors.white : kBlck,
                      fontWeight:
                          activeIndex == 1 ? FontWeight.w600 : FontWeight.w600),
                ),
              )),
            ),
          ),
          Divider(),
          // SizedBox(
          //   width: 15.0,
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 2;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.065, vertical: 8),
              decoration: BoxDecoration(
                color:
                    activeIndex == 2 ? kTextoo : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: activeIndex == 2 ? kTextoo : kBlck,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "PERJADIN",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.034,
                      color: activeIndex == 2 ? Colors.white : kBlck,
                      fontWeight:
                          activeIndex == 2 ? FontWeight.w600 : FontWeight.w600),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  // void main() {
  //   runApp(HistoryAttendance());
  // }

  Future<void> _showDatePicker({required int selectedButton}) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedButton == 1
          ? selectedDate1 ?? DateTime.now()
          : selectedDate2 ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        if (selectedButton == 1) {
          selectedDate1 = newDate;
        } else if (selectedButton == 2) {
          selectedDate2 = newDate;
        }
      });
      widget.onDateSelected(newDate);
    }
  }

  String _getButtonText(DateTime? selectedDate) {
    return selectedDate != null
        ? "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}"
        : 'Year/Month/Day';
  }
}