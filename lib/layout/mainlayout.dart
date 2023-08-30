import 'package:flutter/material.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/face_recognition.dart';
import 'package:imp_approval/screens/home.dart';
import 'package:imp_approval/screens/standup.dart';
import 'package:imp_approval/screens/login.dart';
import 'package:imp_approval/screens/history_attedance.dart';
import 'package:imp_approval/screens/profile.dart';
import 'package:imp_approval/screens/cuti.dart';
import 'package:imp_approval/main.dart';
import 'package:imp_approval/screens/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    StandUp(),
    CutiScreen(),
    HistoryAttendance(),
    SettingPage(),
  ];

  bool shouldShowAppBar(int index) {
    return index != _screens.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width / _screens.length;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: shouldShowAppBar(_currentIndex)
            ? AppBar(
                elevation: 1.5,
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.04,
                      backgroundImage: AssetImage(
                        "assets/img/profil2.png",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.028,
                    ),
                    FutureBuilder<SharedPreferences>(
                      future: SharedPreferences.getInstance(),
                      builder: (BuildContext context,
                          AsyncSnapshot<SharedPreferences> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error loading preferences');
                        } else {
                          String name =
                              snapshot.data!.getString('nama_lengkap') ??
                                  'Guest';
                          String divisi =
                              snapshot.data!.getString('divisi') ?? 'Guest';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, ' + name,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                divisi,
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.notifications_none_sharp,
                        color: Color.fromRGBO(67, 129, 202, 1),
                      ),
                    )
                  ],
                ),
              )
            : null,
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: Size.fromHeight(kBottomNavigationBarHeight + 5),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                currentIndex: _currentIndex,
                items: List.generate(
                  _screens.length,
                  (index) {
                    return BottomNavigationBarItem(
                      icon: Icon(
                        listOfIcons[index], // Replace with your actual icons
                        color:
                            _currentIndex == index ? Colors.blue : Colors.grey,
                      ),
                      label: '', // Empty label
                    );
                  },
                ),
              ),
              AnimatedPositioned(
                duration:
                    Duration(milliseconds: 300), // Adjust duration as needed
                left: _currentIndex *
                        (MediaQuery.of(context).size.width / _screens.length) +
                    16.0, // Account for margin
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width / _screens.length -
                      32.0, // Account for margin
                  height: 2, // Height of the underline
                  color: Colors.blue, // Color of the underline
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MainLayout());
}
