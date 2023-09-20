import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:imp_approval/screens/home.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final _tinggi = MediaQuery.of(context).size.height;
    final _lebar = MediaQuery.of(context).size.width;

    Future<void> logout() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      var response = await http.post(
        Uri.parse('https://testing.impstudio.id/approvall/api/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        preferences.remove('token');

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout gagal')),
        );
      }
    }

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    height: 300,
                    width: double.infinity,
                    color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Mahesa Alfian Dhika',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          child: Text(
                            'Backend Developer',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: 300 - 75 / 2,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          height: 75,
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '5',
                                    style: GoogleFonts.montserrat(
                                      color: blueText,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'WFA',
                                    style: GoogleFonts.montserrat(
                                      color: greyText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '3',
                                    style: GoogleFonts.montserrat(
                                      color: blueText,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'PERJADIN',
                                    style: GoogleFonts.montserrat(
                                      color: greyText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '1',
                                    style: GoogleFonts.montserrat(
                                      color: blueText,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'WFO',
                                    style: GoogleFonts.montserrat(
                                      color: greyText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 35),

                    width: MediaQuery.of(context)
                        .size
                        .width, // Use width here, not height
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Profile Information',
                              style: GoogleFonts.montserrat(
                                color: blueText,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 110,
                          child: const Divider(
                            color: blueText,
                            indent: 1,
                            thickness: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Jenis Kehadiran

                                    Container(
                                      width: 20,
                                      child: const Divider(
                                        color: blueText,
                                        indent: 1,
                                        thickness: 2,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'First Name',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: greyText,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Mahesa',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: hitamText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),

                                    // DIVISI
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Container(
                                      width: 22,
                                      child: const Divider(
                                        color: blueText,
                                        indent: 1,
                                        thickness: 2,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Divisi',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: greyText,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Engineer',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: hitamText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),

                                    // TANGGAL LAHIR
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Container(
                                      width: 50,
                                      child: const Divider(
                                        color: blueText,
                                        indent: 1,
                                        thickness: 2,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Tanggal Lahir',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: greyText,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '08 - 12 - 2006',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: hitamText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //     width: MediaQuery.of(context).size.width /
                              //         2 /
                              //         3),

                              const Spacer(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // LAST NAME

                                    Container(
                                      width: 20,
                                      child: const Divider(
                                        color: blueText,
                                        indent: 1,
                                        thickness: 2,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Last Name',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: greyText,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Alfian Dhika',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: hitamText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),

                                    // Staff Number
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Container(
                                      width: 22,
                                      child: const Divider(
                                        color: blueText,
                                        indent: 1,
                                        thickness: 2,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Staff Number',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: greyText,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '22022321392',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: hitamText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),

                                    // Jenis Kelamin
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Container(
                                      width: 50,
                                      child: const Divider(
                                        color: blueText,
                                        indent: 1,
                                        thickness: 2,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Jenis Kelamin',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: greyText,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Laki - laki',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            color: hitamText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15),
                                    backgroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    logout();
                                  },
                                  child: Text(
                                    'Log Out',
                                    style: GoogleFonts.inter(
                                      color: whiteText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
