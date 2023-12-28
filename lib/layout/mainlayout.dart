import 'package:flutter/material.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/layout/custom_appbar.dart';
import 'package:imp_approval/screens/home.dart';
import 'package:imp_approval/screens/standup.dart';
import 'package:imp_approval/screens/history_attedance.dart';
import 'package:imp_approval/screens/cuti.dart';
import 'package:imp_approval/screens/setting.dart';
import 'package:flutter/services.dart';



class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       appBar: shouldShowAppBar(_currentIndex) 
    ? PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: const CustomAppbarz(),
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
                            index], 
                        color:
                            _currentIndex == index ? Colors.blue : Colors.grey,
                      ),
                      label: '', 
                    );
                  },
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(
                    milliseconds: 300), 
                left: _currentIndex *
                        (MediaQuery.of(context).size.width / _screens.length) +
                    16.0,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width / _screens.length -
                      32.0,
                  height: 2, 
                  color: Colors.blue,
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
