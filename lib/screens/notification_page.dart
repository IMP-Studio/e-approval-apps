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
             centerTitle: true,
       
  backgroundColor: Colors.white,
  title: 
          Text(
        'Notification',
        style: GoogleFonts.montserrat(
          color: Color(0xff000000),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),

  leading:Icon(
    size: 20,
        Icons.arrow_back_rounded,
        color: Colors.black,
      ),

  bottom: PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: Padding(
      padding: const EdgeInsets.only(top: 0, left: 10, right: 10), // Adjusted padding
      child: TabBar(
        controller: _tabController,
        labelColor: blueText,
        unselectedLabelColor: greyText,
        indicatorColor: blueText, // Optional: Set indicator color
        isScrollable: true, // Enable scrolling if there are many tabs
        tabs: [
          Tab(
            child: Text(
              "All",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(fontSize: 10.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Tab(
            child: Text(
              "Check In",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(fontSize: 10.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Tab(
            child: Text(
              "Check Out",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(fontSize: 10.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Tab(
            child: Text(
              "Stand Up",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(fontSize: 10.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
)
,
        body: SingleChildScrollView(
          child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 22),
              height: MediaQuery.of(context).size.height * 2,
              child: ListView(
                children: [
                  Container(
                    
            
                    padding: EdgeInsets.only(top: 15,),
                    height: 60,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Check In Segera",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(fontSize: 12.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Check In",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(fontSize: 9.0),
                                fontWeight: FontWeight.w600,
                                color: blueText
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                              "4 Minute ago",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(fontSize: 10.0),
                                fontWeight: FontWeight.w500,
                                color: greyText
                              ),
                            ),
                            
                          ],
                        ),
                        const SizedBox(height: 10,),
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
                    
                    padding: EdgeInsets.only(top: 15),
                    height: 60,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Check In Segera",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(fontSize: 12.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Check In",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(fontSize: 9.0),
                                fontWeight: FontWeight.w600,
                                color: blueText
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                              "4 Minute ago",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(fontSize: 10.0),
                                fontWeight: FontWeight.w500,
                                color: greyText
                              ),
                            ),
                            
                          ],
                        ),
                        const SizedBox(height: 10,),
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
        )
      ),
    );
  }
}
