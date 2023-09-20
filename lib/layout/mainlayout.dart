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
import 'package:shimmer/shimmer.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const StandUp(),
    const CutiScreen(),
    const HistoryAttendance(),
    const SettingPage(),
  ];

  bool shouldShowAppBar(int index) {
    return index != _screens.length - 1;
  }

  

  @override
  Widget build(BuildContext context) {
    Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey[300],
            width: 80, // You can adjust the width as needed
            height: 14, // You can adjust the height as needed
          ),
          const SizedBox(height: 5),
          Container(
            color: Colors.grey[300],
            width: 60, // You can adjust the width as needed
            height: 10, // You can adjust the height as needed
          ),
        ],
      ),
    );

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
      FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.04,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.028,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey[300],
                        width: 80, // Adjust as needed
                        height: 14, // Adjust as needed
                      ),
                      const SizedBox(height: 5),
                      Container(
                        color: Colors.grey[300],
                        width: 60, // Adjust as needed
                        height: 10, // Adjust as needed
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('Error loading preferences');
          } else {
            String name = snapshot.data!.getString('nama_lengkap') ?? 'Guest';
            String divisi = snapshot.data!.getString('divisi') ?? 'Guest';
            return Row(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.04,
                  backgroundImage: const AssetImage(
                    "assets/img/profil2.png",
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.028,
                ),
                Column(
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
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
      const Spacer(),
      const Align(
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
          preferredSize: const Size.fromHeight(kBottomNavigationBarHeight + 5),
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
                        listOfIcons[
                            index], // Replace with your actual icons. listOfIcons data.dart
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
                    const Duration(milliseconds: 300), // Adjust duration as needed
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
