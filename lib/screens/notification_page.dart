import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:imp_approval/data/data.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              'Notification',
              style: GoogleFonts.montserrat(
                color: const Color(0xff000000),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                 size: 20,
              Icons.arrow_back_rounded,
              color: Colors.black,
              ),
              onPressed: () {
                
              Navigator.pop(context);
              },
             
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      children: [
                        Container(
                          height: 30,
                          width: 90,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                             
                              backgroundColor: blueText,
                              side: const BorderSide(color: blueText),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              // BACK POP
                            },
                            child: Text(
                              'Semua',
                              style: GoogleFonts.inter(
                                color: whiteText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                       Container(
                        height: 30,
                        width: 90,
                        child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                               elevation: 0,
                              
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: blueText),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              // BACK POP
                            },
                            child: Text(
                              'WFA',
                              style: GoogleFonts.inter(
                                color: blueText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                       ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                        height: 30,
                        width: 110,
                        child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                               elevation: 0,
                              
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: blueText),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              // BACK POP
                            },
                            child: Text(
                              'PERJADIN',
                              style: GoogleFonts.inter(
                                color: blueText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                       ),
                       
                        const SizedBox(
                          width: 20,
                        ),
                       Container(
                        height: 30,
                        width: 90,
                        child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                               elevation: 0,
                              
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: blueText),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              // BACK POP
                            },
                            child: Text(
                              'WFO',
                              style: GoogleFonts.inter(
                                color: blueText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                       ),
                        const SizedBox(
                          width: 20,
                        ),
                       Container(
                        height: 30,
                        width: 90,
                        child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                               elevation: 0,
                              
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: blueText),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              // BACK POP
                            },
                            child: Text(
                              'CUTI',
                              style: GoogleFonts.inter(
                                color: blueText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                       ),
                        const SizedBox(
                          width: 20,
                        ),
                       Container(
                        height: 30,
                        width: 100,
                        child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                               elevation: 0,
                              
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: blueText),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              // BACK POP
                            },
                            child: Text(
                              'CHECK IN',
                              style: GoogleFonts.inter(
                                color: blueText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                       ),
                        const SizedBox(
                          width: 20,
                        ),
                       Container(
                        height: 30,
                        width: 110,
                        child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                               elevation: 0,
                              
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: blueText),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              // BACK POP
                            },
                            child: Text(
                              'CHECK OUT',
                              style: GoogleFonts.inter(
                                color: blueText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                       ),
                        
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  margin: const EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height * 2,
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        height: 60,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Check In Segera",
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(fontSize: 12.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "Check In",
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(fontSize: 9.0),
                                      fontWeight: FontWeight.w600,
                                      color: blueText),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "4 Minute ago",
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(fontSize: 10.0),
                                      fontWeight: FontWeight.w500,
                                      color: greyText),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Divider(
                                color: Colors.black.withOpacity(0.1),
                                height: 1.2,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        height: 60,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Check In Segera",
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(fontSize: 12.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "Check In",
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(fontSize: 9.0),
                                      fontWeight: FontWeight.w600,
                                      color: blueText),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "4 Minute ago",
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(fontSize: 10.0),
                                      fontWeight: FontWeight.w500,
                                      color: greyText),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Divider(
                                color: Colors.black.withOpacity(0.1),
                                height: 2,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
