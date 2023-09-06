import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/create/create_standup.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StandUp extends StatefulWidget {
  const StandUp({super.key});

  @override
  State<StandUp> createState() => _StandUpState();
}

class _StandUpState extends State<StandUp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int activeIndex = 0;
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 10.0),
      child: Row(
        children: [
          SizedBox(
            width: 15.0,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 0;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color:
                    activeIndex == 0 ? Colors.transparent : Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: activeIndex == 0 ? kTextoo : Colors.transparent,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "General",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.028,
                      color: activeIndex == 0 ? kTextoo : kTextUnselected,
                      fontWeight:
                          activeIndex == 0 ? FontWeight.w600 : FontWeight.w600),
                ),
              )),
            ),
          ),
          Divider(),
          SizedBox(
            width: 15.0,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color:
                    activeIndex == 1 ? Colors.transparent : Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: activeIndex == 1 ? kTextoo : Colors.transparent,
                  width: 1.0, // Lebar border
                ),
              ),
              child: Center(
                  child: Text(
                "You",
                style: GoogleFonts.getFont(
                  'Montserrat',
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.028,
                      color: activeIndex == 1 ? kTextoo : kTextUnselected,
                      fontWeight:
                          activeIndex == 1 ? FontWeight.w600 : FontWeight.w600),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
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
                            top: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "IMP STANDUP",
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
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Text(
                                  "Tempat berbagi masalah dan project",
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
                        "assets/img/hero-image.svg",
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 1.2,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IndexedStack(
                          index: _tabController.index,
                          children: [
                            buildContent(),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                // height: MediaQuery.of(context).size.width * 0.26,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [kTextoo, kTextoo])),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 22.0),
                            child: Container(
                              margin: EdgeInsets.only(left: 12.0),
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.width * 0.26,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: kTextUnselectedOpa),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 10.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_outlined,
                                          color: kTextUnselectedd,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.044,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          "Mukhamad Arrafi",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kTextUnselectedd,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.028,
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 4.0,
                                          width: 4.0,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [kTextoo, kTextoo]),
                                              borderRadius:
                                                  BorderRadius.circular(2.0)),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Done",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kTextUnselectedd,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.028)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 12.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Splash Screen Approval",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kBlck,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.034,
                                                  fontWeight: FontWeight.w600)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 20.0, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time_outlined,
                                              color: kTextUnselectedd,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.044,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              "08.00",
                                              style: GoogleFonts.getFont(
                                                  'Montserrat',
                                                  textStyle: TextStyle(
                                                      color: kTextUnselectedd,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.028,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          "Click for detail",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kTextUnselectedd,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.028,
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                // height: MediaQuery.of(context).size.width * 0.26,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [kYelw, kYelw])),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 22.0),
                            child: Container(
                              margin: EdgeInsets.only(left: 12.0),
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.width * 0.26,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: kTextUnselectedOpa),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 10.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_outlined,
                                          color: kTextUnselectedd,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.044,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          "Mukhamad Arrafi",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kTextUnselectedd,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.028,
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 4.0,
                                          width: 4.0,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [kYelw, kYelw]),
                                              borderRadius:
                                                  BorderRadius.circular(2.0)),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Doing",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kTextUnselectedd,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.028)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 12.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Splash Screen Approval",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kBlck,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.034,
                                                  fontWeight: FontWeight.w600)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 20.0, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time_outlined,
                                              color: kTextUnselectedd,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.044,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              "08.00",
                                              style: GoogleFonts.getFont(
                                                  'Montserrat',
                                                  textStyle: TextStyle(
                                                      color: kTextUnselectedd,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.028,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          "Click for detail",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kTextUnselectedd,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.028,
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                // height: MediaQuery.of(context).size.width * 0.26,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [kTextBlocker, kTextBlocker])),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 22.0),
                            child: Container(
                              margin: EdgeInsets.only(left: 12.0),
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.width * 0.26,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: kTextUnselectedOpa),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 10.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_outlined,
                                          color: kTextUnselectedd,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.044,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          "Mukhamad Arrafi",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kTextUnselectedd,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.028,
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 4.0,
                                          width: 4.0,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    kTextBlocker,
                                                    kTextBlocker
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(2.0)),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Blocker",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kTextUnselectedd,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.028)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 12.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Splash Screen Approval",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kBlck,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.034,
                                                  fontWeight: FontWeight.w600)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 20.0, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time_outlined,
                                              color: kTextUnselectedd,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.044,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              "08.00",
                                              style: GoogleFonts.getFont(
                                                  'Montserrat',
                                                  textStyle: TextStyle(
                                                      color: kTextUnselectedd,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.028,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          "Click for detail",
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              textStyle: TextStyle(
                                                  color: kTextUnselectedd,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.028,
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
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
                    width: 140.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                        color: kTextoo,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "STAND UP",
                        style: GoogleFonts.getFont('Montserrat',
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.028,
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateStandup(),
                              ));
                        },
                        child: Icon(LucideIcons.users),
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
    );
  }
}
