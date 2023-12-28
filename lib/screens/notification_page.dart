import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:imp_approval/data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:imp_approval/models/notification_model.dart';
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;
  Future<List<Notifications>>? _notif;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
         _notif = fetchAndUpdateCache(); 
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 30), // Adjust the height as needed
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Notifikasi',
            style: GoogleFonts.montserrat(
              color: const Color(0xff000000),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    buildButton('Semua', 0),
                    const SizedBox(width: 20),
                    buildButton('Presence', 1),
                    const SizedBox(width: 20),
                    buildButton('Approval', 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              FutureBuilder<List<Notifications>>(
                          future: _notif,
                          builder: (context, snapshot) {
                            
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 7,
                                itemBuilder: (context, index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
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

                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                               print('Snapshot Data: ${snapshot.data}');
                                print('Snapshot Error: ${snapshot.error}');
                                print('Snapshot Data: ${snapshot.data.runtimeType}');
                                print('Snapshot Error: ${snapshot.error}');
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 7,
                                      itemBuilder: (context, index) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
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

                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                  child: Column(
                                    children: [
                                      SizedBox( height : MediaQuery.of(context).size.height *
                                        0.08,),
                                      SvgPicture.asset(
                                        "assets/img/EMPTY.svg",
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Notifikasi Kosong",
                                        style: GoogleFonts.getFont('Montserrat',
                                            textStyle: TextStyle(
                                                color: kTextBlcknw,
                                                fontWeight: FontWeight.w600,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.044)),
                                      ),
                                    ],
                                  ));
                            } else {
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!
                                    .length, // Menentukan jumlah total item
                                itemBuilder: (BuildContext context, int index) {
                                  // ignore: unused_local_variable
                                  final itemData = snapshot.data![index];
                    
                                  return GestureDetector(
                                    onTap: () {
                                      
                                    },
                                    // Sisanya sama seperti kode asli Anda...
                                    child: Container(
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

                                  );
                                },
                              );
                            }
                          },
                        ),
            ],
          ),
      ),
    );
  }

Widget buildButton(String text, int index) {
  return GestureDetector(
    onTap: () {
      _tabController.animateTo(index); 
    },
    child: Container(
      width: 80.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: currentIndex == index ? kTextoo : Colors.transparent,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: currentIndex == index ? Colors.transparent : kTextUnselected,
          width: 1.0,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.getFont(
            'Montserrat',
            textStyle: TextStyle(
              fontSize: 10.0,
              color: currentIndex == index ? Colors.white : kTextUnselected,
              fontWeight: currentIndex == index ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
  );
}
}

